const oracle = require('oracledb');
const { mapSourceRecords } = require('./timelineModel');
const config = require('./cassandraConfig');

// Simple Oracle joins produce one consistent read-only source snapshot.
const queries = {
    allergies: 'SELECT Patient_ID, Log_Seq_No, Allergy_Name FROM LOG_ALLERGIES ORDER BY Patient_ID, Log_Seq_No, Allergy_Name',
    logs: `SELECT ml.Patient_ID, ml.Log_Seq_No, TO_CHAR(ml.Log_Date, 'YYYY-MM-DD') AS Event_Date,
        p.First_Name || ' ' || p.Last_Name AS Patient_Name, ml.Diagnosis
        FROM MEDICAL_LOG ml JOIN PATIENT p ON p.Patient_ID = ml.Patient_ID`,
    appointments: `SELECT a.Patient_ID, a.Appointment_ID, TO_CHAR(a.Appointment_Date, 'YYYY-MM-DD') AS Event_Date,
        p.First_Name || ' ' || p.Last_Name AS Patient_Name, d.First_Name || ' ' || d.Last_Name AS Doctor_Name,
        a.Consultation_Mode, a.Status FROM APPOINTMENT a
        JOIN PATIENT p ON p.Patient_ID = a.Patient_ID JOIN DOCTOR d ON d.Doctor_ID = a.Doctor_ID`,
    prescriptions: `SELECT a.Patient_ID, rx.Appointment_ID, rx.Prescription_No, TO_CHAR(rx.Issue_Date, 'YYYY-MM-DD') AS Event_Date,
        p.First_Name || ' ' || p.Last_Name AS Patient_Name, m.Medicine_Name, pi.Dosage
        FROM PRESCRIPTION rx JOIN APPOINTMENT a ON a.Appointment_ID = rx.Appointment_ID
        JOIN PATIENT p ON p.Patient_ID = a.Patient_ID
        LEFT JOIN PRESCRIPTION_ITEM pi ON pi.Appointment_ID = rx.Appointment_ID AND pi.Prescription_No = rx.Prescription_No
        LEFT JOIN MEDICINE m ON m.Medicine_ID = pi.Medicine_ID ORDER BY rx.Appointment_ID, rx.Prescription_No, pi.Item_Seq_No`,
    orders: `SELECT a.Patient_ID, lo.Appointment_ID, lo.Order_ID, TO_CHAR(lo.Order_Date, 'YYYY-MM-DD') AS Event_Date,
        p.First_Name || ' ' || p.Last_Name AS Patient_Name, lc.Test_Name, lo.Priority
        FROM LAB_ORDER lo JOIN APPOINTMENT a ON a.Appointment_ID = lo.Appointment_ID
        JOIN PATIENT p ON p.Patient_ID = a.Patient_ID JOIN LAB_TEST_CATALOG lc ON lc.Test_Catalog_ID = lo.Test_Catalog_ID`,
    results: `SELECT a.Patient_ID, lo.Appointment_ID, tr.Order_ID, tr.Result_Seq_No, TO_CHAR(tr.Report_Date, 'YYYY-MM-DD') AS Event_Date,
        p.First_Name || ' ' || p.Last_Name AS Patient_Name, lc.Test_Name, tr.Result_Value, tr.Technician_Remarks
        FROM TEST_RESULT tr JOIN LAB_ORDER lo ON lo.Order_ID = tr.Order_ID
        JOIN APPOINTMENT a ON a.Appointment_ID = lo.Appointment_ID JOIN PATIENT p ON p.Patient_ID = a.Patient_ID
        JOIN LAB_TEST_CATALOG lc ON lc.Test_Catalog_ID = lo.Test_Catalog_ID`,
    invoices: `SELECT a.Patient_ID, bi.Appointment_ID, bi.Invoice_No, TO_CHAR(bi.Billing_Date, 'YYYY-MM-DD') AS Event_Date,
        p.First_Name || ' ' || p.Last_Name AS Patient_Name, bi.Total_Amount, bi.Payment_Status
        FROM BILLING_INVOICE bi JOIN APPOINTMENT a ON a.Appointment_ID = bi.Appointment_ID
        JOIN PATIENT p ON p.Patient_ID = a.Patient_ID`,
};

async function readSource(connection) {
    await connection.execute('SET TRANSACTION READ ONLY');
    const source = {};
    for (const [name, sql] of Object.entries(queries)) {
        source[name] = (await connection.execute(sql, [], { outFormat: oracle.OUT_FORMAT_OBJECT })).rows;
    }
    return source;
}

async function importEvents(client, events) {
    const query = `INSERT INTO ${config.keyspace()}.clinical_events_by_patient_month
        (patient_id, event_month, event_time, event_id, event_type, patient_name, appointment_id, summary, source_record_id)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)`;
    const failures = [];
    let written = 0;
    for (const event of events) {
        try {
            await client.execute(query, [event.patient_id, event.event_month, event.event_time, event.event_id,
                event.event_type, event.patient_name, event.appointment_id, event.summary, event.source_record_id], { prepare: true });
            written++;
        } catch {
            // Report stable identifiers, never credentials or raw driver errors.
            failures.push({ patient_id: event.patient_id, event_id: event.event_id });
        }
    }
    return { attempted: events.length, written, failed: failures.length, failures };
}

module.exports = { queries, readSource, importEvents, mapSourceRecords };
