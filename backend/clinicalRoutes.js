const crypto = require('node:crypto');

function fail(status, message) {
    const error = new Error(message);
    error.status = status;
    throw error;
}

function text(value, name, max, required = true) {
    if (!required && (value === undefined || value === null || value === '')) return null;
    if (typeof value !== 'string' || !value.trim() || value.trim().length > max) {
        fail(400, `${name} must contain 1-${max} characters`);
    }
    return value.trim();
}

function date(value, name) {
    if (typeof value !== 'string' || !/^\d{4}-\d{2}-\d{2}$/.test(value)
        || Number.isNaN(Date.parse(value)) || new Date(value).toISOString().slice(0, 10) !== value) {
        fail(400, `${name} must be a valid date (YYYY-MM-DD)`);
    }
    return value;
}

async function lockAppointment(connection, appointmentId, allowSettled = false) {
    const appointment = await connection.execute(
        'SELECT Appointment_ID FROM APPOINTMENT WHERE Appointment_ID = :id FOR UPDATE', { id: appointmentId });
    if (!appointment.rows.length) fail(404, 'Appointment not found');
    if (!allowSettled) {
        const settled = await connection.execute(
            "SELECT Invoice_No FROM BILLING_INVOICE WHERE Appointment_ID = :id AND Payment_Status IN ('Paid', 'Refunded')", { id: appointmentId });
        if (settled.rows.length) fail(409, 'Charges cannot be added after an invoice is paid or refunded. Use a new appointment.');
    }
}

function registerClinicalRoutes(app, oracle, dbConfig, safeError) {
    // Every write uses one connection: all statements commit together or roll back.
    function route(method, path, write, action) {
        app[method](path, async (req, res) => {
            let connection;
            try {
                connection = await oracle.getConnection(dbConfig);
                const result = await action(connection, req);
                if (write) await connection.commit();
                res.status(method === 'post' ? 201 : 200).json(result);
            } catch (error) {
                if (connection && write) await connection.rollback();
                const status = error.status || ([1, 2291].includes(error.errorNum) ? 409 : 500);
                res.status(status).json({ error: error.status ? error.message
                    : status === 409 ? 'A related record is missing or this record already exists' : safeError(error) });
            } finally {
                if (connection) await connection.close();
            }
        });
    }

    route('get', '/api/allergies', false, async (connection) => {
        const result = await connection.execute('SELECT Patient_ID, Log_Seq_No, Allergy_Name FROM LOG_ALLERGIES ORDER BY Patient_ID, Log_Seq_No, Allergy_Name');
        return result.rows.map(([patient_id, log_seq_no, allergy_name]) => ({ patient_id, log_seq_no, allergy_name }));
    });

    route('post', '/api/medical-logs', true, async (connection, req) => {
        const body = req.body || {};
        const patient_id = text(body.patient_id, 'Patient', 12);
        const log_date = date(body.log_date, 'Log date');
        const diagnosis = text(body.diagnosis, 'Diagnosis', 150);
        const attachment_path = text(body.attachment_path, 'Attachment reference', 2048, false);
        const normalize = (values, label) => {
            if (values === undefined) return [];
            if (!Array.isArray(values) || values.length > 20) fail(400, `Supply at most 20 ${label}`);
            return [...new Set(values.map((value) => text(value, 'Allergy', 50).toUpperCase()))];
        };
        const known = normalize(body.known_allergies, 'known allergies');
        const other = normalize(body.other_allergies, 'other allergies');
        // Accept the original array contract for existing API clients.
        const legacy = normalize(body.allergies, 'allergies');
        const catalog = await connection.execute('SELECT DISTINCT UPPER(TRIM(Allergen_Class)) FROM MEDICINE WHERE Allergen_Class IS NOT NULL');
        const classes = catalog.rows.map((row) => row[0]);
        if (known.some((value) => !classes.includes(value))) fail(400, 'Select known allergy classes from the current medicine catalog');
        if (other.some((value) => classes.includes(value))) fail(400, 'Select medicine-class allergies in the known classes field');
        const allergies = [...new Set([...known, ...other, ...legacy])];
        if (allergies.length > 20) fail(400, 'Supply at most 20 allergies in total');
        // Lock the patient before MAX+1 so simultaneous logs receive different numbers.
        const patient = await connection.execute('SELECT Patient_ID FROM PATIENT WHERE Patient_ID = :id FOR UPDATE', { id: patient_id });
        if (!patient.rows.length) fail(404, 'Patient not found');
        const next = await connection.execute('SELECT NVL(MAX(Log_Seq_No), 0) + 1 FROM MEDICAL_LOG WHERE Patient_ID = :id', { id: patient_id });
        const log_seq_no = next.rows[0][0];
        await connection.execute(`INSERT INTO MEDICAL_LOG (Patient_ID, Log_Seq_No, Log_Date, Diagnosis, Attachment_Path)
            VALUES (:patient_id, :log_seq_no, TO_DATE(:log_date, 'YYYY-MM-DD'), :diagnosis, :attachment_path)`,
        { patient_id, log_seq_no, log_date, diagnosis, attachment_path });
        for (const allergy_name of allergies) {
            await connection.execute('INSERT INTO LOG_ALLERGIES (Patient_ID, Log_Seq_No, Allergy_Name) VALUES (:patient_id, :log_seq_no, :allergy_name)',
                { patient_id, log_seq_no, allergy_name });
        }
        return { success: true, patient_id, log_seq_no };
    });

    route('get', '/api/lab-catalog', false, async (connection) => {
        const result = await connection.execute('SELECT Test_Catalog_ID, Test_Name, Category, Standard_Cost FROM LAB_TEST_CATALOG ORDER BY Test_Name');
        return result.rows.map(([test_catalog_id, test_name, category, standard_cost]) => ({ test_catalog_id, test_name, category, standard_cost }));
    });

    route('post', '/api/lab-orders', true, async (connection, req) => {
        const body = req.body || {};
        const appointment_id = text(body.appointment_id, 'Appointment', 12);
        const test_catalog_id = text(body.test_catalog_id, 'Test', 10);
        const order_date = date(body.order_date, 'Order date');
        const priority = body.priority;
        if (!['Routine', 'Urgent', 'Stat'].includes(priority)) fail(400, 'Choose Routine, Urgent or Stat priority');
        await lockAppointment(connection, appointment_id);
        const order_id = `LAB-${crypto.randomBytes(4).toString('hex').toUpperCase()}`;
        await connection.execute(`INSERT INTO LAB_ORDER (Order_ID, Appointment_ID, Test_Catalog_ID, Order_Date, Priority)
            VALUES (:order_id, :appointment_id, :test_catalog_id, TO_DATE(:order_date, 'YYYY-MM-DD'), :priority)`,
        { order_id, appointment_id, test_catalog_id, order_date, priority });
        return { success: true, order_id };
    });

    route('post', '/api/test-results', true, async (connection, req) => {
        const body = req.body || {};
        const order_id = text(body.order_id, 'Lab order', 12);
        const report_date = date(body.report_date, 'Report date');
        const result_value = text(body.result_value, 'Result', 100);
        const technician_remarks = text(body.technician_remarks, 'Remarks', 200, false);
        const document_url = text(body.document_url, 'Document reference', 2048, false);
        const file_format = text(body.file_format, 'File format', 10, false);
        const order = await connection.execute('SELECT Order_Date FROM LAB_ORDER WHERE Order_ID = :id FOR UPDATE', { id: order_id });
        if (!order.rows.length) fail(404, 'Lab order not found');
        const validDate = await connection.execute("SELECT Order_ID FROM LAB_ORDER WHERE Order_ID = :id AND TRUNC(Order_Date) <= TO_DATE(:report_date, 'YYYY-MM-DD')", { id: order_id, report_date });
        if (!validDate.rows.length) fail(400, 'Report date cannot precede the order date');
        const next = await connection.execute('SELECT NVL(MAX(Result_Seq_No), 0) + 1 FROM TEST_RESULT WHERE Order_ID = :id', { id: order_id });
        const result_seq_no = next.rows[0][0];
        await connection.execute(`INSERT INTO TEST_RESULT (Order_ID, Result_Seq_No, Result_Value, Report_Date, Technician_Remarks, Document_URL, File_Format)
            VALUES (:order_id, :result_seq_no, :result_value, TO_DATE(:report_date, 'YYYY-MM-DD'), :technician_remarks, :document_url, :file_format)`,
        { order_id, result_seq_no, result_value, report_date, technician_remarks, document_url, file_format });
        return { success: true, order_id, result_seq_no };
    });

    route('get', '/api/billing/:appointment_id/items', false, async (connection, req) => {
        const id = text(req.params.appointment_id, 'Appointment', 12);
        const result = await connection.execute(`
            SELECT 'Medicine' AS Item_Type, m.Medicine_Name AS Item_Name, pi.Quantity, m.Unit_Price, pi.Quantity * m.Unit_Price AS Amount
            FROM PRESCRIPTION_ITEM pi JOIN MEDICINE m ON m.Medicine_ID = pi.Medicine_ID WHERE pi.Appointment_ID = :id
            UNION ALL
            SELECT 'Lab test', lc.Test_Name, 1, lc.Standard_Cost, lc.Standard_Cost
            FROM LAB_ORDER lo JOIN LAB_TEST_CATALOG lc ON lc.Test_Catalog_ID = lo.Test_Catalog_ID WHERE lo.Appointment_ID = :id`, { id });
        return result.rows.map(([item_type, item_name, quantity, unit_price, amount]) => ({ item_type, item_name, quantity, unit_price, amount }));
    });

    route('post', '/api/billing', true, async (connection, req) => {
        const appointment_id = text(req.body?.appointment_id, 'Appointment', 12);
        const billing_date = date(req.body?.billing_date, 'Billing date');
        await lockAppointment(connection, appointment_id, true);
        const existing = await connection.execute('SELECT Invoice_No FROM BILLING_INVOICE WHERE Appointment_ID = :id', { id: appointment_id });
        if (existing.rows.length) fail(409, 'This appointment already has an invoice');
        const invoice_no = `INV-${crypto.randomBytes(5).toString('hex').toUpperCase()}`;
        await connection.execute(`INSERT INTO BILLING_INVOICE (Appointment_ID, Invoice_No, Billing_Date, Total_Amount, Payment_Status)
            VALUES (:appointment_id, :invoice_no, TO_DATE(:billing_date, 'YYYY-MM-DD'), Calculate_Invoice_Total(:appointment_id), 'Pending')`,
        { appointment_id, invoice_no, billing_date });
        return { success: true, appointment_id, invoice_no };
    });

    route('put', '/api/billing/:appointment_id/:invoice_no', true, async (connection, req) => {
        const appointment_id = text(req.params.appointment_id, 'Appointment', 12);
        const invoice_no = text(req.params.invoice_no, 'Invoice', 15);
        const action = req.body?.action;
        if (!['recalculate', 'pay', 'refund'].includes(action)) fail(400, 'Choose recalculate, pay or refund');
        await lockAppointment(connection, appointment_id, true);
        const result = await connection.execute(`SELECT Payment_Status, Total_Amount, Calculate_Invoice_Total(Appointment_ID)
            FROM BILLING_INVOICE WHERE Appointment_ID = :appointment_id AND Invoice_No = :invoice_no FOR UPDATE`, { appointment_id, invoice_no });
        if (!result.rows.length) fail(404, 'Invoice not found');
        const [status, stored, calculated] = result.rows[0];
        if (action === 'refund' ? status !== 'Paid' : status !== 'Pending') fail(409, 'This action is not allowed for the current payment status');
        if (action === 'pay' && Math.round(stored * 100) !== Math.round(calculated * 100)) fail(409, 'Recalculate the pending invoice before marking it paid');
        if (action === 'recalculate') {
            await connection.execute(`UPDATE BILLING_INVOICE SET Total_Amount = Calculate_Invoice_Total(Appointment_ID)
                WHERE Appointment_ID = :appointment_id AND Invoice_No = :invoice_no`, { appointment_id, invoice_no });
        } else {
            await connection.execute(`UPDATE BILLING_INVOICE SET Payment_Status = :status
                WHERE Appointment_ID = :appointment_id AND Invoice_No = :invoice_no`,
            { appointment_id, invoice_no, status: action === 'pay' ? 'Paid' : 'Refunded' });
        }
        return { success: true };
    });
}

module.exports = { registerClinicalRoutes, lockAppointment };
