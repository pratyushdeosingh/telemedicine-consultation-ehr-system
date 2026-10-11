// Integration verification: use real Oracle SQL, but never commit test changes.
const path = require('node:path');
const assert = require('node:assert/strict');
const crypto = require('node:crypto');
require('dotenv').config({ path: path.join(__dirname, '..', '.env'), quiet: true });
const oracle = require('oracledb');
const dbConfig = require('../dbConfig');

async function main() {
    let connection;
    let server;
    const originalGetConnection = oracle.getConnection;
    const timer = setTimeout(() => { console.error('Verification timed out; Oracle rolls back when the connection is terminated.'); process.exit(1); }, 60000);
    try {
        connection = await originalGetConnection({ ...dbConfig, connectTimeout: 10, transportConnectTimeout: 10, retryCount: 0 });
        connection.callTimeout = 10000;
        const trigger = await connection.execute(`SELECT t.Status, o.Status FROM USER_TRIGGERS t JOIN USER_OBJECTS o
            ON o.Object_Name = t.Trigger_Name AND o.Object_Type = 'TRIGGER' WHERE t.Trigger_Name = 'PREVENT_ALLERGIC_PRESCRIPTION'`);
        assert.deepEqual(trigger.rows[0], ['ENABLED', 'VALID'], 'Allergy trigger must be enabled and valid');
        console.log('PASS: allergy trigger enabled and valid');
        const conflict = await connection.execute(`SELECT la.Patient_ID, m.Medicine_ID FROM LOG_ALLERGIES la JOIN MEDICINE m
            ON UPPER(TRIM(la.Allergy_Name)) = UPPER(TRIM(m.Allergen_Class)) FETCH FIRST 1 ROW ONLY`);
        assert.ok(conflict.rows.length, 'Need a synthetic patient/medicine allergy pair');
        const [patientId, conflictMedicine] = conflict.rows[0];
        const conflictClass = (await connection.execute('SELECT Allergen_Class FROM MEDICINE WHERE Medicine_ID = :id', { id: conflictMedicine })).rows[0][0];
        const doctorId = (await connection.execute('SELECT Doctor_ID FROM DOCTOR FETCH FIRST 1 ROW ONLY')).rows[0][0];
        const safeMedicine = (await connection.execute('SELECT Medicine_ID FROM MEDICINE WHERE Allergen_Class IS NULL FETCH FIRST 1 ROW ONLY')).rows[0][0];
        const testId = (await connection.execute('SELECT Test_Catalog_ID FROM LAB_TEST_CATALOG FETCH FIRST 1 ROW ONLY')).rows[0][0];
        const appointmentId = `CHK-${crypto.randomBytes(4).toString('hex')}`;
        // Share one transaction through HTTP. Each route rollback returns to its savepoint.
        oracle.getConnection = async () => ({
            execute: (...args) => connection.execute(...args),
            commit: async () => {},
            rollback: () => connection.execute('ROLLBACK TO SAVEPOINT api_request'),
            close: async () => {},
        });
        const app = require('../server');
        server = app.listen(0, '127.0.0.1');
        await new Promise((resolve) => server.once('listening', resolve));
        const base = `http://127.0.0.1:${server.address().port}/api`;
        async function request(route, method = 'GET', body, expected = 200) {
            await connection.execute('SAVEPOINT api_request');
            const response = await fetch(base + route, { method, headers: { 'Content-Type': 'application/json' }, body: body === undefined ? undefined : JSON.stringify(body) });
            const result = await response.json();
            assert.equal(response.status, expected, `${method} ${route}: ${result.error || 'unexpected status'}`);
            return result;
        }
        const patients = await request('/patients');
        const phoneRows = (await connection.execute('SELECT Patient_ID, Phone_Number FROM PATIENT_PHONE ORDER BY Patient_ID, Phone_Number')).rows;
        assert.ok(phoneRows.length, 'Need sample phone records to verify website coverage');
        for (const patient of patients) {
            assert.deepEqual(patient.phone_numbers, phoneRows.filter(row => row[0] === patient.patient_id).map(row => row[1]));
        }
        const providers = await request('/insurance-providers');
        assert.ok(providers.length, 'Need sample insurance providers');
        for (const patient of patients.filter(row => row.policy_no)) {
            const provider = providers.find(row => row.policy_no === patient.policy_no);
            assert.ok(provider);
            assert.equal(patient.provider_name, provider.provider_name);
            assert.equal(patient.coverage_limit, provider.coverage_limit);
        }
        assert.ok(patients.some(row => !row.policy_no), 'LEFT JOIN must retain self-pay patients');
        const doctors = await request('/doctors');
        const qualificationRows = (await connection.execute('SELECT Doctor_ID, Qualification FROM DOCTOR_QUALIFICATION ORDER BY Doctor_ID, Qualification')).rows;
        assert.ok(qualificationRows.length, 'Need sample qualification records');
        for (const doctor of doctors) {
            assert.deepEqual(doctor.qualifications, qualificationRows.filter(row => row[0] === doctor.doctor_id).map(row => row[1]));
        }
        const sessions = await request('/telemedicine-sessions');
        assert.equal(sessions.length, (await connection.execute('SELECT COUNT(*) FROM TELEMEDICINE_SESSION')).rows[0][0]);
        assert.ok(sessions.length, 'Need sample session records');
        const virtual = await request('/appointments', 'POST', { patient_id: patientId, doctor_id: doctorId,
            appointment_date: '2026-10-11', appointment_time: '09:00 AM', status: 'Scheduled', consultation_mode: 'Virtual', meeting_link: null }, 201);
        const placeholder = (await request('/telemedicine-sessions')).find(row => row.appointment_id === virtual.appointment_id);
        assert.ok(placeholder, 'Virtual booking must create a session in the same transaction');
        assert.equal(placeholder.start_time, null);
        assert.equal(placeholder.network_quality_log, 'Session created automatically');
        console.log('PASS: website phone arrays, insurance join/selector, qualifications and virtual session trigger/readback');
        await connection.execute(`INSERT INTO APPOINTMENT (Appointment_ID, Patient_ID, Doctor_ID, Appointment_Date, Appointment_Time, Status, Consultation_Mode)
            VALUES (:id, :patientId, :doctorId, DATE '2026-10-10', '10:00 AM', 'Scheduled', 'In-Person')`, { id: appointmentId, patientId, doctorId });
        const appointments = await request('/appointments');
        assert.equal(appointments.find((a) => a.appointment_id === appointmentId).patient_id, patientId);
        await request('/allergies');
        await request('/medical-logs');
        await request('/lab-catalog');
        console.log('PASS: history, allergies, catalog and appointment patient identity');
        await request('/medical-logs', 'POST', { patient_id: patientId, log_date: '2026-02-30', diagnosis: 'Invalid date' }, 400);
        const history = { patient_id: patientId, log_date: '2026-10-10', diagnosis: 'Synthetic verification only' };
        await request('/medical-logs', 'POST', { ...history, known_allergies: ['Not a catalog class'] }, 400);
        await request('/medical-logs', 'POST', { ...history, other_allergies: [conflictClass] }, 400);
        const log = await request('/medical-logs', 'POST', { ...history, known_allergies: [conflictClass.toLowerCase(), conflictClass], other_allergies: ['Verification allergen'] }, 201);
        const savedAllergies = (await request('/allergies')).filter((row) => row.patient_id === patientId && row.log_seq_no === log.log_seq_no);
        assert.deepEqual(savedAllergies.map((row) => row.allergy_name).sort(), [conflictClass.toUpperCase(), 'VERIFICATION ALLERGEN'].sort());
        console.log('PASS: known classes validated; other allergies stored; duplicate/case normalization');
        console.log('PASS: history and allergy transaction; invalid date rejected');
        const prescription = { appointment_id: appointmentId, prescription_no: 'CHK-RX', issue_date: '2026-10-10', notes: null, pharmacy_id: null,
            items: [{ item_seq_no: 1, medicine_id: safeMedicine, dosage: 'Verification only', duration_days: 1, quantity: 1 },
                { item_seq_no: 2, medicine_id: conflictMedicine, dosage: 'Verification only', duration_days: 1, quantity: 1 }] };
        await request('/prescriptions', 'POST', prescription, 409);
        const rejected = await connection.execute('SELECT COUNT(*) FROM PRESCRIPTION WHERE Appointment_ID = :id', { id: appointmentId });
        assert.equal(rejected.rows[0][0], 0);
        const rejectedItems = await connection.execute('SELECT COUNT(*) FROM PRESCRIPTION_ITEM WHERE Appointment_ID = :id', { id: appointmentId });
        assert.equal(rejectedItems.rows[0][0], 0);
        console.log('PASS: real allergy trigger returns HTTP 409; header and earlier safe item rolled back');
        prescription.items.pop();
        await request('/prescriptions', 'POST', prescription, 201);
        const order = await request('/lab-orders', 'POST', { appointment_id: appointmentId, test_catalog_id: testId, order_date: '2026-10-10', priority: 'Routine' }, 201);
        await request('/test-results', 'POST', { order_id: order.order_id, report_date: '2026-10-09', result_value: 'Invalid date' }, 400);
        await request('/test-results', 'POST', { order_id: order.order_id, report_date: '2026-10-10', result_value: 'Synthetic result', technician_remarks: 'Verification only' }, 201);
        assert.ok((await request('/test-results')).some((r) => r.order_id === order.order_id));
        console.log('PASS: safe prescription, lab order and test result persist within transaction');
        const invoice = await request('/billing', 'POST', { appointment_id: appointmentId, billing_date: '2026-10-10', total_amount: 1 }, 201);
        await request('/billing', 'POST', { appointment_id: appointmentId, billing_date: '2026-10-10' }, 409);
        const route = `/billing/${appointmentId}/${invoice.invoice_no}`;
        const items = await request(`/billing/${appointmentId}/items`);
        let record = (await request('/billing')).find((i) => i.invoice_no === invoice.invoice_no);
        assert.equal(record.stored_total, items.reduce((sum, item) => sum + item.amount, 0));
        await request('/lab-orders', 'POST', { appointment_id: appointmentId, test_catalog_id: testId, order_date: '2026-10-10', priority: 'Urgent' }, 201);
        await request(route, 'PUT', { action: 'pay' }, 409);
        await request(route, 'PUT', { action: 'recalculate' });
        await request(route, 'PUT', { action: 'refund' }, 409);
        await request(route, 'PUT', { action: 'pay' });
        await request(route, 'PUT', { action: 'recalculate' }, 409);
        await request('/lab-orders', 'POST', { appointment_id: appointmentId, test_catalog_id: testId, order_date: '2026-10-10', priority: 'Routine' }, 409);
        await request('/prescriptions', 'POST', { ...prescription, prescription_no: 'CHK-RX2' }, 409);
        await request(route, 'PUT', { action: 'refund' });
        record = (await request('/billing')).find((i) => i.invoice_no === invoice.invoice_no);
        assert.equal(record.payment_status, 'Refunded');
        console.log('PASS: calculated billing, duplicate protection, recalculation, payment/refund transitions and settled-charge protection');
        await connection.rollback();
        assert.equal((await connection.execute('SELECT COUNT(*) FROM APPOINTMENT WHERE Appointment_ID = :id', { id: appointmentId })).rows[0][0], 0);
        console.log('PASS: all synthetic verification changes rolled back; no test records retained');
    } finally {
        clearTimeout(timer);
        oracle.getConnection = originalGetConnection;
        if (server) { server.closeAllConnections(); await new Promise((resolve) => server.close(resolve)); }
        if (connection) { await connection.rollback(); await connection.close(); }
    }
}

main().catch((error) => {
    // Do not print Oracle descriptors, credentials or raw stack traces.
    console.error(`Verification failed: ${error.code || error.name}${error.name === 'AssertionError' ? `: ${error.message}` : ''}`);
    process.exitCode = 1;
});
