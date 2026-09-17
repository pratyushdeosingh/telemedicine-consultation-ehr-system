require('dotenv').config();
const express = require('express');
const oracledb = require('oracledb');
const cors = require('cors');
const fs = require('node:fs');
const path = require('node:path');
const crypto = require('node:crypto');
const dbConfig = require('./dbConfig');

const app = express();
const PORT = Number(process.env.PORT) || 3000;
const HOST = process.env.HOST || '127.0.0.1';
const isProduction = process.env.NODE_ENV === 'production';
const allowedOrigin = process.env.CORS_ORIGIN || 'http://localhost:5173';
const publicOrigin = process.env.PUBLIC_ORIGIN;
const serveFrontend = process.env.SERVE_FRONTEND === 'true';
const frontendDist = path.resolve(__dirname, '../frontend/dist');
const vercelMode = process.env.DEPLOY_TARGET === 'vercel' || Boolean(process.env.VERCEL);
const authRequired = isProduction && process.env.EXTERNAL_AUTH !== 'true';
const authHash = process.env.DEMO_PASSWORD_SCRYPT;
const sessionSecret = process.env.SESSION_SECRET;
const sessionMaxAge = 8 * 60 * 60;

if (isProduction && (!publicOrigin || !publicOrigin.startsWith('https://'))) {
    throw new Error('PUBLIC_ORIGIN must be an HTTPS origin in production');
}
if (serveFrontend && !fs.existsSync(path.join(frontendDist, 'index.html'))) {
    throw new Error('Frontend build is missing; build frontend before starting the server');
}
if (authRequired && (!authHash || !sessionSecret || sessionSecret.length < 32)) {
    throw new Error('Application authentication configuration is missing');
}
if (vercelMode && (!process.env.CRON_SECRET || process.env.CRON_SECRET.length < 32)) {
    throw new Error('Cron authentication configuration is missing');
}

app.disable('x-powered-by');
app.use((req, res, next) => {
    res.setHeader('X-Content-Type-Options', 'nosniff');
    res.setHeader('Referrer-Policy', 'no-referrer');
    res.setHeader('X-Frame-Options', 'DENY');
    res.setHeader('Cache-Control', 'no-store');
    if (isProduction) {
        res.setHeader('Strict-Transport-Security', 'max-age=31536000');
        res.setHeader('Content-Security-Policy', "default-src 'self'; base-uri 'self'; object-src 'none'; frame-ancestors 'none'; form-action 'self'; img-src 'self' data:; connect-src 'self'");
        res.setHeader('Permissions-Policy', 'camera=(), microphone=(), geolocation=()');
    }
    next();
});

if (!isProduction) app.use(cors({ origin: allowedOrigin }));

app.use(express.json({ limit: '32kb' }));
app.use('/api', (req, res, next) => {
    if (isProduction && !['GET', 'HEAD', 'OPTIONS'].includes(req.method)
        && req.get('origin') !== publicOrigin) {
        return res.status(403).json({ error: 'Request origin is not allowed' });
    }
    next();
});

function sameValue(a, b) {
    const left = Buffer.from(a);
    const right = Buffer.from(b);
    return left.length === right.length && crypto.timingSafeEqual(left, right);
}

function validPassword(password) {
    if (typeof password !== 'string' || password.length > 256) return false;
    const [salt, hash] = (authHash || '').split(':');
    if (!salt || !hash || !/^[a-f0-9]+$/i.test(salt + hash)) return false;
    return sameValue(crypto.scryptSync(password, Buffer.from(salt, 'hex'), 64).toString('hex'), hash);
}

function validSession(req) {
    const cookie = req.get('cookie')?.split(';').map((part) => part.trim())
        .find((part) => part.startsWith('demo_session='))?.slice('demo_session='.length);
    if (!cookie) return false;
    const parts = cookie.split('.');
    if (parts.length !== 3 || parts[0] !== 'v1') return false;
    const expiry = Number(parts[1]);
    if (!Number.isSafeInteger(expiry) || expiry < Date.now() || expiry > Date.now() + sessionMaxAge * 1000) return false;
    const signature = crypto.createHmac('sha256', sessionSecret).update(`${parts[0]}.${parts[1]}`).digest('hex');
    return sameValue(signature, parts[2]);
}

app.post('/api/login', (req, res) => {
    if (!authRequired) return res.status(404).json({ error: 'Not found' });
    if (!validPassword(req.body?.password)) return res.status(401).json({ error: 'Incorrect password' });
    const expiry = Date.now() + sessionMaxAge * 1000;
    const payload = `v1.${expiry}`;
    const signature = crypto.createHmac('sha256', sessionSecret).update(payload).digest('hex');
    res.setHeader('Set-Cookie', `demo_session=${payload}.${signature}; Path=/; HttpOnly; Secure; SameSite=Strict; Max-Age=${sessionMaxAge}`);
    res.json({ success: true });
});

app.post('/api/logout', (req, res) => {
    res.setHeader('Set-Cookie', 'demo_session=; Path=/; HttpOnly; Secure; SameSite=Strict; Max-Age=0');
    res.json({ success: true });
});

app.get('/api/session', (req, res) => res.json({ authenticated: !authRequired || validSession(req) }));

app.use('/api', (req, res, next) => {
    if (req.path === '/cron/keepalive') return next();
    if (authRequired && !validSession(req)) return res.status(401).json({ error: 'Sign in required' });
    next();
});

function safeError(err) {
    return isProduction ? 'The request could not be completed' : err.message;
}

const requiredDbConfig = ['ORACLE_USER', 'ORACLE_PASSWORD', 'ORACLE_CONNECT_STRING'];
const missingDbConfig = requiredDbConfig.filter((name) => !process.env[name]);
if (vercelMode && (!process.env.ORACLE_WALLET_B64 || !process.env.ORACLE_WALLET_PASSWORD)) {
    missingDbConfig.push('ORACLE_WALLET_B64', 'ORACLE_WALLET_PASSWORD');
}
if (isProduction && missingDbConfig.length > 0) {
    throw new Error(`Database configuration missing: ${missingDbConfig.join(', ')}`);
}

function requireFields(body, fields) {
    return fields.filter((field) => {
        const value = body[field];
        return value === undefined || value === null || value === '';
    });
}

function sendValidationError(res, missingFields) {
    return res.status(400).json({
        success: false,
        error: `Missing required fields: ${missingFields.join(', ')}`
    });
}

app.get('/', (req, res, next) => {
    if (serveFrontend) return next();
    res.json({
        message: 'Telemedicine API is running'
    });
});

app.get('/api/test-db', async (req, res) => {
    let connection;

    try {
        if (missingDbConfig.length > 0) {
            return res.status(503).json({
                success: false,
                error: isProduction ? 'Database unavailable' : `Backend database configuration is incomplete: ${missingDbConfig.join(', ')}`
            });
        }

        connection = await oracledb.getConnection(dbConfig);

        const result = await connection.execute(
            `SELECT 'Oracle connection successful' AS MESSAGE FROM DUAL`
        );

        res.json({
            success: true,
            message: result.rows[0][0]
        });

    } catch (err) {
        console.error(err);
        res.status(500).json({
            success: false,
            error: safeError(err)
        });

    } finally {
        if (connection) {
            await connection.close();
        }
    }
});

app.get('/api/patients', async (req, res) => {
    let connection;

    try {
        connection = await oracledb.getConnection(dbConfig);

        const result = await connection.execute(`
            SELECT
                Patient_ID,
                First_Name,
                Last_Name,
                City,
                State,
                Gender,
                Policy_No
            FROM PATIENT
            ORDER BY Patient_ID
        `);

        const patients = result.rows.map(row => ({
            patient_id: row[0],
            first_name: row[1],
            last_name: row[2],
            city: row[3],
            state: row[4],
            gender: row[5],
            policy_no: row[6]
        }));

        res.json(patients);

    } catch (err) {
        console.error(err);
        res.status(500).json({
            error: safeError(err)
        });

    } finally {
        if (connection) {
            await connection.close();
        }
    }
});

app.get('/api/doctors', async (req, res) => {
    let connection;

    try {
        connection = await oracledb.getConnection(dbConfig);

        const result = await connection.execute(`
            SELECT
                d.Doctor_ID,
                d.First_Name,
                d.Last_Name,
                d.Specialization,
                d.Email,
                d.Primary_Phone,
                dept.Dept_Name
            FROM DOCTOR d
            JOIN DEPARTMENT dept
                ON d.Dept_ID = dept.Dept_ID
            ORDER BY d.Doctor_ID
        `);

        const doctors = result.rows.map(row => ({
            doctor_id: row[0],
            first_name: row[1],
            last_name: row[2],
            specialization: row[3],
            email: row[4],
            primary_phone: row[5],
            department: row[6]
        }));

        res.json(doctors);

    } catch (err) {
        console.error(err);
        res.status(500).json({
            error: safeError(err)
        });

    } finally {
        if (connection) {
            await connection.close();
        }
    }
});

app.get('/api/medicines', async (req, res) => {
    let connection;

    try {
        connection = await oracledb.getConnection(dbConfig);

        const result = await connection.execute(`
            SELECT
                Medicine_ID,
                Medicine_Name,
                Manufacturer,
                Dosage_Form,
                Unit_Price,
                Allergen_Class
            FROM MEDICINE
            ORDER BY Medicine_ID
        `);

        const medicines = result.rows.map(row => ({
            medicine_id: row[0],
            medicine_name: row[1],
            manufacturer: row[2],
            dosage_form: row[3],
            unit_price: row[4],
            allergen_class: row[5]
        }));

        res.json(medicines);

    } catch (err) {
        console.error(err);
        res.status(500).json({
            error: safeError(err)
        });

    } finally {
        if (connection) {
            await connection.close();
        }
    }
});

app.get('/api/pharmacies', async (req, res) => {
    let connection;

    try {
        connection = await oracledb.getConnection(dbConfig);

        const result = await connection.execute(`
            SELECT
                Pharmacy_ID,
                Pharmacy_Name,
                Location,
                Contact_Number
            FROM PHARMACY
            ORDER BY Pharmacy_ID
        `);

        const pharmacies = result.rows.map(row => ({
            pharmacy_id: row[0],
            pharmacy_name: row[1],
            location: row[2],
            contact_number: row[3]
        }));

        res.json(pharmacies);

    } catch (err) {
        console.error(err);
        res.status(500).json({
            error: safeError(err)
        });

    } finally {
        if (connection) {
            await connection.close();
        }
    }
});

app.get('/api/medical-logs', async (req, res) => {
    let connection;

    try {
        connection = await oracledb.getConnection(dbConfig);

        const result = await connection.execute(`
            SELECT
                ml.Patient_ID,
                p.First_Name || ' ' || p.Last_Name AS Patient_Name,
                ml.Log_Seq_No,
                ml.Log_Date,
                ml.Diagnosis,
                ml.Attachment_Path
            FROM MEDICAL_LOG ml
            JOIN PATIENT p
                ON ml.Patient_ID = p.Patient_ID
            ORDER BY ml.Patient_ID, ml.Log_Seq_No
        `);

        const logs = result.rows.map(row => ({
            patient_id: row[0],
            patient_name: row[1],
            log_seq_no: row[2],
            log_date: row[3],
            diagnosis: row[4],
            attachment_path: row[5]
        }));

        res.json(logs);

    } catch (err) {
        console.error(err);
        res.status(500).json({
            error: safeError(err)
        });

    } finally {
        if (connection) {
            await connection.close();
        }
    }
});

app.get('/api/lab-orders', async (req, res) => {
    let connection;

    try {
        connection = await oracledb.getConnection(dbConfig);

        const result = await connection.execute(`
            SELECT
                lo.Order_ID,
                lo.Appointment_ID,
                p.First_Name || ' ' || p.Last_Name AS Patient_Name,
                lc.Test_Name,
                lc.Category,
                lc.Standard_Cost,
                lo.Order_Date,
                lo.Priority
            FROM LAB_ORDER lo
            JOIN APPOINTMENT a
                ON lo.Appointment_ID = a.Appointment_ID
            JOIN PATIENT p
                ON a.Patient_ID = p.Patient_ID
            JOIN LAB_TEST_CATALOG lc
                ON lo.Test_Catalog_ID = lc.Test_Catalog_ID
            ORDER BY lo.Order_Date, lo.Order_ID
        `);

        const labOrders = result.rows.map(row => ({
            order_id: row[0],
            appointment_id: row[1],
            patient_name: row[2],
            test_name: row[3],
            category: row[4],
            standard_cost: row[5],
            order_date: row[6],
            priority: row[7]
        }));

        res.json(labOrders);

    } catch (err) {
        console.error(err);
        res.status(500).json({
            error: safeError(err)
        });

    } finally {
        if (connection) {
            await connection.close();
        }
    }
});

app.get('/api/test-results', async (req, res) => {
    let connection;

    try {
        connection = await oracledb.getConnection(dbConfig);

        const result = await connection.execute(`
            SELECT
                tr.Order_ID,
                tr.Result_Seq_No,
                lo.Appointment_ID,
                p.First_Name || ' ' || p.Last_Name AS Patient_Name,
                lc.Test_Name,
                tr.Result_Value,
                tr.Report_Date,
                tr.Technician_Remarks,
                tr.Document_URL,
                tr.File_Format
            FROM TEST_RESULT tr
            JOIN LAB_ORDER lo
                ON tr.Order_ID = lo.Order_ID
            JOIN APPOINTMENT a
                ON lo.Appointment_ID = a.Appointment_ID
            JOIN PATIENT p
                ON a.Patient_ID = p.Patient_ID
            JOIN LAB_TEST_CATALOG lc
                ON lo.Test_Catalog_ID = lc.Test_Catalog_ID
            ORDER BY tr.Report_Date, tr.Order_ID, tr.Result_Seq_No
        `);

        const testResults = result.rows.map(row => ({
            order_id: row[0],
            result_seq_no: row[1],
            appointment_id: row[2],
            patient_name: row[3],
            test_name: row[4],
            result_value: row[5],
            report_date: row[6],
            technician_remarks: row[7],
            document_url: row[8],
            file_format: row[9]
        }));

        res.json(testResults);

    } catch (err) {
        console.error(err);
        res.status(500).json({ error: safeError(err) });

    } finally {
        if (connection) {
            await connection.close();
        }
    }
});

app.get('/api/telemedicine-sessions', async (req, res) => {
    let connection;

    try {
        connection = await oracledb.getConnection(dbConfig);

        const result = await connection.execute(`
            SELECT
                ts.Session_ID,
                ts.Appointment_ID,
                p.First_Name || ' ' || p.Last_Name AS Patient_Name,
                d.First_Name || ' ' || d.Last_Name AS Doctor_Name,
                ts.Start_Time,
                ts.End_Time,
                ts.Network_Quality_Log,
                ts.Chat_Transcript_URL
            FROM TELEMEDICINE_SESSION ts
            JOIN APPOINTMENT a
                ON ts.Appointment_ID = a.Appointment_ID
            JOIN PATIENT p
                ON a.Patient_ID = p.Patient_ID
            JOIN DOCTOR d
                ON a.Doctor_ID = d.Doctor_ID
            ORDER BY ts.Session_ID
        `);

        const sessions = result.rows.map(row => ({
            session_id: row[0],
            appointment_id: row[1],
            patient_name: row[2],
            doctor_name: row[3],
            start_time: row[4],
            end_time: row[5],
            network_quality_log: row[6],
            chat_transcript_url: row[7]
        }));

        res.json(sessions);

    } catch (err) {
        console.error(err);
        res.status(500).json({
            error: safeError(err)
        });

    } finally {
        if (connection) {
            await connection.close();
        }
    }
});

app.get('/api/appointments', async (req, res) => {
    let connection;

    try {
        connection = await oracledb.getConnection(dbConfig);

        const result = await connection.execute(`
            SELECT
                a.Appointment_ID,
                p.First_Name || ' ' || p.Last_Name AS Patient_Name,
                d.First_Name || ' ' || d.Last_Name AS Doctor_Name,
                dept.Dept_Name AS Department,
                a.Appointment_Date,
                a.Appointment_Time,
                a.Status,
                a.Consultation_Mode,
                a.Meeting_Link
            FROM APPOINTMENT a
            JOIN PATIENT p
                ON a.Patient_ID = p.Patient_ID
            JOIN DOCTOR d
                ON a.Doctor_ID = d.Doctor_ID
            JOIN DEPARTMENT dept
                ON d.Dept_ID = dept.Dept_ID
            ORDER BY a.Appointment_Date, a.Appointment_Time
        `);

        const appointments = result.rows.map(row => ({
            appointment_id: row[0],
            patient_name: row[1],
            doctor_name: row[2],
            department: row[3],
            appointment_date: row[4],
            appointment_time: row[5],
            status: row[6],
            consultation_mode: row[7],
            meeting_link: row[8]
        }));

        res.json(appointments);

    } catch (err) {
        console.error(err);
        res.status(500).json({
            error: safeError(err)
        });

    } finally {
        if (connection) {
            await connection.close();
        }
    }
});

app.get('/api/prescriptions', async (req, res) => {
    let connection;

    try {
        connection = await oracledb.getConnection(dbConfig);

        const result = await connection.execute(`
            SELECT
                p.Prescription_No,
                p.Appointment_ID,
                pt.First_Name || ' ' || pt.Last_Name AS Patient_Name,
                m.Medicine_Name,
                pi.Dosage,
                pi.Duration_Days,
                pi.Quantity,
                m.Unit_Price,
                pi.Quantity * m.Unit_Price AS Medicine_Cost
            FROM PRESCRIPTION_ITEM pi
            JOIN PRESCRIPTION p
                ON pi.Appointment_ID = p.Appointment_ID
                AND pi.Prescription_No = p.Prescription_No
            JOIN APPOINTMENT a
                ON p.Appointment_ID = a.Appointment_ID
            JOIN PATIENT pt
                ON a.Patient_ID = pt.Patient_ID
            JOIN MEDICINE m
                ON pi.Medicine_ID = m.Medicine_ID
            ORDER BY p.Appointment_ID, p.Prescription_No
        `);

        const prescriptions = result.rows.map(row => ({
            prescription_no: row[0],
            appointment_id: row[1],
            patient_name: row[2],
            medicine_name: row[3],
            dosage: row[4],
            duration_days: row[5],
            quantity: row[6],
            unit_price: row[7],
            medicine_cost: row[8]
        }));

        res.json(prescriptions);

    } catch (err) {
        console.error(err);
        res.status(500).json({
            error: safeError(err)
        });

    } finally {
        if (connection) {
            await connection.close();
        }
    }
});

app.get('/api/billing', async (req, res) => {
    let connection;

    try {
        connection = await oracledb.getConnection(dbConfig);

        const result = await connection.execute(`
            SELECT
                bi.Invoice_No,
                bi.Appointment_ID,
                pt.First_Name || ' ' || pt.Last_Name AS Patient_Name,
                bi.Billing_Date,
                bi.Total_Amount,
                bi.Payment_Status,
                Calculate_Invoice_Total(bi.Appointment_ID) AS Calculated_Total
            FROM BILLING_INVOICE bi
            JOIN APPOINTMENT a
                ON bi.Appointment_ID = a.Appointment_ID
            JOIN PATIENT pt
                ON a.Patient_ID = pt.Patient_ID
            ORDER BY bi.Billing_Date
        `);

        const billing = result.rows.map(row => ({
            invoice_no: row[0],
            appointment_id: row[1],
            patient_name: row[2],
            billing_date: row[3],
            stored_total: row[4],
            payment_status: row[5],
            calculated_total: row[6]
        }));

        res.json(billing);

    } catch (err) {
        console.error(err);
        res.status(500).json({
            error: safeError(err)
        });

    } finally {
        if (connection) {
            await connection.close();
        }
    }
});

app.post('/api/patients', async (req, res) => {
    let connection;

    try {
        const {
            first_name,
            last_name,
            street,
            city,
            state,
            zip_code,
            dob,
            gender,
            emergency_contact,
            policy_no
        } = req.body;

        const missingFields = requireFields(req.body, [
            'first_name',
            'last_name',
            'dob'
        ]);

        if (missingFields.length > 0) {
            return sendValidationError(res, missingFields);
        }

        connection = await oracledb.getConnection(dbConfig);

        await connection.execute(
            `
            BEGIN
                Register_New_Patient(
                    :first_name,
                    :last_name,
                    :street,
                    :city,
                    :state,
                    :zip_code,
                    TO_DATE(:dob, 'YYYY-MM-DD'),
                    :gender,
                    :emergency_contact,
                    :policy_no
                );
            END;
            `,
            {
                first_name,
                last_name,
                street,
                city,
                state,
                zip_code,
                dob,
                gender,
                emergency_contact,
                policy_no
            }
        );

        await connection.commit();

        res.status(201).json({
            success: true,
            message: 'Patient registered successfully'
        });

    } catch (err) {
        console.error(err);

        if (connection) {
            await connection.rollback();
        }

        res.status(500).json({
            success: false,
            error: safeError(err)
        });

    } finally {
        if (connection) {
            await connection.close();
        }
    }
});

app.post('/api/appointments', async (req, res) => {
    let connection;

    try {
        const {
            patient_id,
            doctor_id,
            appointment_date,
            appointment_time,
            status,
            consultation_mode,
            meeting_link
        } = req.body;

        const missingFields = requireFields(req.body, [
            'patient_id',
            'doctor_id',
            'appointment_date',
            'appointment_time',
            'status',
            'consultation_mode'
        ]);

        if (missingFields.length > 0) {
            return sendValidationError(res, missingFields);
        }

        connection = await oracledb.getConnection(dbConfig);

        const result = await connection.execute(
            `
            SELECT 'APT-' || LPAD(seq_appointment_id.NEXTVAL, 2, '0')
            FROM DUAL
            `,
        );

        const appointment_id = result.rows[0][0];

        await connection.execute(
            `
            INSERT INTO APPOINTMENT (
                Appointment_ID,
                Patient_ID,
                Doctor_ID,
                Appointment_Date,
                Appointment_Time,
                Status,
                Consultation_Mode,
                Meeting_Link
            )
            VALUES (
                :appointment_id,
                :patient_id,
                :doctor_id,
                TO_DATE(:appointment_date, 'YYYY-MM-DD'),
                :appointment_time,
                :status,
                :consultation_mode,
                :meeting_link
            )
            `,
            {
                appointment_id,
                patient_id,
                doctor_id,
                appointment_date,
                appointment_time,
                status,
                consultation_mode,
                meeting_link
            }
        );

        await connection.commit();

        res.status(201).json({
            success: true,
            message: 'Appointment booked successfully',
            appointment_id
        });

    } catch (err) {
        console.error(err);

        if (connection) {
            await connection.rollback();
        }

        res.status(500).json({
            success: false,
            error: safeError(err)
        });

    } finally {
        if (connection) {
            await connection.close();
        }
    }
});

app.post('/api/prescriptions', async (req, res) => {
    let connection;

    try {
        const {
            appointment_id,
            prescription_no,
            issue_date,
            notes,
            pharmacy_id,
            items
        } = req.body;

        const missingFields = requireFields(req.body, [
            'appointment_id',
            'prescription_no',
            'issue_date'
        ]);

        if (missingFields.length > 0) {
            return sendValidationError(res, missingFields);
        }

        if (!Array.isArray(items) || items.length === 0) {
            return res.status(400).json({
                success: false,
                error: 'At least one prescription item is required'
            });
        }

        const invalidItemIndex = items.findIndex((item) => requireFields(item, [
            'item_seq_no',
            'medicine_id',
            'dosage',
            'duration_days',
            'quantity'
        ]).length > 0);

        if (invalidItemIndex !== -1) {
            return res.status(400).json({
                success: false,
                error: `Prescription item ${invalidItemIndex + 1} is incomplete`
            });
        }

        connection = await oracledb.getConnection(dbConfig);

        await connection.execute(
            `
            INSERT INTO PRESCRIPTION (
                Appointment_ID,
                Prescription_No,
                Issue_Date,
                Notes,
                Pharmacy_ID
            )
            VALUES (
                :appointment_id,
                :prescription_no,
                TO_DATE(:issue_date, 'YYYY-MM-DD'),
                :notes,
                :pharmacy_id
            )
            `,
            {
                appointment_id,
                prescription_no,
                issue_date,
                notes,
                pharmacy_id
            }
        );

        for (const item of items) {
            await connection.execute(
                `
                INSERT INTO PRESCRIPTION_ITEM (
                    Appointment_ID,
                    Prescription_No,
                    Item_Seq_No,
                    Medicine_ID,
                    Dosage,
                    Duration_Days,
                    Quantity
                )
                VALUES (
                    :appointment_id,
                    :prescription_no,
                    :item_seq_no,
                    :medicine_id,
                    :dosage,
                    :duration_days,
                    :quantity
                )
                `,
                {
                    appointment_id,
                    prescription_no,
                    item_seq_no: item.item_seq_no,
                    medicine_id: item.medicine_id,
                    dosage: item.dosage,
                    duration_days: item.duration_days,
                    quantity: item.quantity
                }
            );
        }

        await connection.commit();

        res.status(201).json({
            success: true,
            message: 'Prescription created successfully',
            appointment_id,
            prescription_no
        });

    } catch (err) {
        console.error(err);

        if (connection) {
            await connection.rollback();
        }

        const isAllergyConflict = err.errorNum === 20002;

        res.status(isAllergyConflict ? 409 : 500).json({
            success: false,
            error: isAllergyConflict
                ? 'The selected medicine conflicts with a recorded allergy'
                : safeError(err)
        });

    } finally {
        if (connection) {
            await connection.close();
        }
    }
});

app.put('/api/appointments/:appointment_id/status', async (req, res) => {
    let connection;

    try {
        const { appointment_id } = req.params;
        const { status } = req.body;

        const allowedStatuses = ['Scheduled', 'Completed', 'Cancelled', 'In-Progress'];

        if (!allowedStatuses.includes(status)) {
            return res.status(400).json({
                success: false,
                error: `Status must be one of: ${allowedStatuses.join(', ')}`
            });
        }

        connection = await oracledb.getConnection(dbConfig);

        await connection.execute(
            `
            BEGIN
                Update_Appointment_Status(
                    :appointment_id,
                    :status
                );
            END;
            `,
            {
                appointment_id,
                status
            }
        );

        await connection.commit();

        res.json({
            success: true,
            message: 'Appointment status updated successfully',
            appointment_id,
            status
        });

    } catch (err) {
        console.error(err);

        if (connection) {
            await connection.rollback();
        }

        res.status(500).json({
            success: false,
            error: safeError(err)
        });

    } finally {
        if (connection) {
            await connection.close();
        }
    }
});

if (serveFrontend) {
    app.use(express.static(frontendDist, { index: false }));
    app.use((req, res, next) => {
        if (req.method === 'GET' && !req.path.startsWith('/api') && req.accepts('html')) {
            return res.sendFile(path.join(frontendDist, 'index.html'));
        }
        next();
    });
}

app.use((err, req, res, next) => {
    console.error(err);
    if (res.headersSent) return next(err);
    const status = err.status >= 400 && err.status < 500 ? err.status : 500;
    res.status(status).json({ error: status === 500 ? safeError(err) : 'Invalid request' });
});

app.get('/api/cron/keepalive', async (req, res) => {
    const expected = process.env.CRON_SECRET;
    if (!vercelMode || !expected || !sameValue(req.get('authorization') || '', `Bearer ${expected}`)) {
        return res.status(401).json({ error: 'Unauthorized' });
    }
    let connection;
    try {
        connection = await oracledb.getConnection(dbConfig);
        await connection.execute('SELECT 1 FROM DUAL');
        res.json({ success: true });
    } catch (err) {
        console.error(err);
        res.status(503).json({ error: 'Database unavailable' });
    } finally {
        if (connection) await connection.close();
    }
});

if (require.main === module) {
    app.listen(PORT, HOST, () => {
        console.log(`Server running at http://${HOST}:${PORT}`);
        if (missingDbConfig.length > 0) {
            console.warn(`Database configuration missing: ${missingDbConfig.join(', ')}`);
        }
    });
}

module.exports = app;
