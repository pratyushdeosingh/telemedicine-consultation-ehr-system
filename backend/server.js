require('dotenv').config();
const express = require('express');
const oracledb = require('oracledb');
const cors = require('cors');

const app = express();
const PORT = Number(process.env.PORT) || 3000;
const allowedOrigin = process.env.CORS_ORIGIN || 'http://localhost:5173';

app.use(cors({ origin: allowedOrigin }));

app.use(express.json());

const dbConfig = {
    user: process.env.ORACLE_USER,
    password: process.env.ORACLE_PASSWORD,
    connectString: process.env.ORACLE_CONNECT_STRING
};

const requiredDbConfig = ['ORACLE_USER', 'ORACLE_PASSWORD', 'ORACLE_CONNECT_STRING'];
const missingDbConfig = requiredDbConfig.filter((name) => !process.env[name]);

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

app.get('/', (req, res) => {
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
                error: `Backend database configuration is incomplete: ${missingDbConfig.join(', ')}`
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
            error: err.message
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
            error: err.message
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
            error: err.message
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
            error: err.message
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
            error: err.message
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
            error: err.message
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
            error: err.message
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
        res.status(500).json({ error: err.message });

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
            error: err.message
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
            error: err.message
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
            error: err.message
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
            error: err.message
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
            error: err.message
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
            error: err.message
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
                ? err.message.replace(/^ORA-20002:\s*/, '').split('\n')[0]
                : err.message
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
            error: err.message
        });

    } finally {
        if (connection) {
            await connection.close();
        }
    }
});

app.listen(PORT, () => {
    console.log(`Server running at http://localhost:${PORT}`);
    if (missingDbConfig.length > 0) {
        console.warn(`Database configuration missing: ${missingDbConfig.join(', ')}`);
    }
});
