function calendarDate(value) {
    if (typeof value !== 'string' || !/^\d{4}-\d{2}-\d{2}$/.test(value)) throw new Error('Invalid source calendar date');
    const date = new Date(`${value}T00:00:00.000Z`);
    if (Number.isNaN(date.getTime()) || date.toISOString().slice(0, 10) !== value) throw new Error('Invalid source calendar date');
    return { event_month: value.slice(0, 7), event_time: date };
}

function mapSourceRecords(source) {
    const events = [];
    const allergies = new Map();
    for (const row of source.allergies) {
        const key = `${row.PATIENT_ID}:${row.LOG_SEQ_NO}`;
        const names = allergies.get(key) || [];
        names.push(row.ALLERGY_NAME);
        allergies.set(key, names);
    }
    function add(row, type, identity, summary) {
        events.push({ patient_id: row.PATIENT_ID, patient_name: row.PATIENT_NAME,
            ...calendarDate(row.EVENT_DATE), event_id: `${type.toLowerCase()}:${identity}`,
            event_type: type, summary, source_record_id: identity, appointment_id: row.APPOINTMENT_ID || null });
    }
    for (const row of source.logs) {
        const names = allergies.get(`${row.PATIENT_ID}:${row.LOG_SEQ_NO}`) || [];
        add(row, 'MEDICAL_HISTORY', `${row.PATIENT_ID}:${row.LOG_SEQ_NO}`,
            `${row.DIAGNOSIS}${names.length ? ` · Recorded allergies: ${names.join(', ')}` : ''}`);
    }
    for (const row of source.appointments) {
        add(row, 'APPOINTMENT', row.APPOINTMENT_ID,
            `${row.CONSULTATION_MODE} consultation · Dr. ${row.DOCTOR_NAME} · ${row.STATUS}`);
    }
    const prescriptions = new Map();
    for (const row of source.prescriptions) {
        const id = `${row.APPOINTMENT_ID}:${row.PRESCRIPTION_NO}`;
        const current = prescriptions.get(id) || { row, medicines: [] };
        if (row.MEDICINE_NAME) current.medicines.push(`${row.MEDICINE_NAME} (${row.DOSAGE})`);
        prescriptions.set(id, current);
    }
    for (const [id, group] of prescriptions) add(group.row, 'PRESCRIPTION', id, group.medicines.join('; ') || 'Prescription recorded');
    for (const row of source.orders) add(row, 'LAB_ORDER', row.ORDER_ID, `${row.TEST_NAME} · ${row.PRIORITY}`);
    for (const row of source.results) add(row, 'LAB_RESULT', `${row.ORDER_ID}:${row.RESULT_SEQ_NO}`,
        `${row.TEST_NAME}: ${row.RESULT_VALUE}${row.TECHNICIAN_REMARKS ? ` · ${row.TECHNICIAN_REMARKS}` : ''}`);
    for (const row of source.invoices) add(row, 'INVOICE', `${row.APPOINTMENT_ID}:${row.INVOICE_NO}`,
        `Invoice ${row.INVOICE_NO} · INR ${Number(row.TOTAL_AMOUNT).toFixed(2)} · Current status: ${row.PAYMENT_STATUS || 'Unspecified'}`);
    return events;
}

function validatePartition(patient, month) {
    if (typeof patient !== 'string' || !/^[A-Za-z0-9_-]{1,12}$/.test(patient)) throw new Error('Choose a valid patient ID');
    if (typeof month !== 'string' || !/^\d{4}-(0[1-9]|1[0-2])$/.test(month) || month.startsWith('0000')) throw new Error('Choose a valid month (YYYY-MM)');
    return { patient, month };
}

module.exports = { calendarDate, mapSourceRecords, validatePartition };
