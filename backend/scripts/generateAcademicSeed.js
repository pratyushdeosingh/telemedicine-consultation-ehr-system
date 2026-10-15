// Generates deterministic, synthetic academic records; never connects to a database.
const fs = require('node:fs');
const path = require('node:path');
const root = path.resolve(__dirname, '../..');
const tables = [
    'INSURANCE_PROVIDER', 'DEPARTMENT', 'PHARMACY', 'MEDICINE', 'LAB_TEST_CATALOG',
    'PATIENT', 'DOCTOR', 'PATIENT_PHONE', 'DOCTOR_QUALIFICATION', 'MEDICAL_LOG',
    'LOG_ALLERGIES', 'APPOINTMENT', 'TELEMEDICINE_SESSION', 'PRESCRIPTION',
    'PRESCRIPTION_ITEM', 'LAB_ORDER', 'TEST_RESULT', 'BILLING_INVOICE',
];
const quote = value => value === null ? 'NULL' : typeof value === 'number' ? String(value) : `'${value.replaceAll("'", "''")}'`;
const raw = sql => ({ sql });
const literal = value => value && typeof value === 'object' ? value.sql : quote(value);
const statements = new Map(tables.map(table => [table, []]));
function add(table, columns, values, keys) {
    const cols = columns.split(',');
    statements.get(table).push(`MERGE INTO ${table} t\nUSING (SELECT ${cols.map((column, i) => `${literal(values[i])} AS ${column}`).join(', ')} FROM dual) s\nON (${keys.split(',').map(key => `t.${key} = s.${key}`).join(' AND ')})\nWHEN NOT MATCHED THEN INSERT (${columns})\nVALUES (${cols.map(column => `s.${column}`).join(', ')});`);
}
const firstNames = ['Aadhya', 'Aditya', 'Bhavana', 'Dinesh', 'Divya', 'Gautham', 'Harini', 'Ishaan', 'Janani', 'Kavin', 'Lavanya', 'Mohan', 'Nithya', 'Pranav', 'Revathi', 'Surya', 'Yamini'];
const lastNames = ['Iyer', 'Kumar', 'Menon', 'Rao', 'Nair', 'Shankar', 'Pillai', 'Reddy', 'Mani', 'Raj', 'Das', 'Babu', 'Krishnan', 'Varma', 'Srinivasan', 'Narayan', 'Sekar'];
const departments = ['Ophthalmology', 'ENT', 'Urology', 'Nephrology', 'Endocrinology', 'Rheumatology', 'Oncology', 'Psychiatry', 'Obstetrics', 'Gynecology', 'Geriatrics', 'Emergency Medicine', 'Physiotherapy', 'Dentistry', 'Nutrition', 'Infectious Diseases', 'Family Medicine'];
const diagnoses = ['Seasonal allergic rhinitis', 'Vitamin D deficiency follow-up', 'Tension headache review', 'Mild eczema follow-up', 'Routine wellness review'];
const allergies = ['Dust Mites', 'Pollen', 'Latex', 'Peanuts', 'Shellfish'];
for (let i = 1; i <= 17; i++) {
    const suffix = `S${String(i).padStart(2, '0')}`;
    const id = prefix => `${prefix}-${suffix}`;
    const date = raw(`DATE '2026-10-${String(i % 12 + 1).padStart(2, '0')}'`);
    const phone = `900000${String(i).padStart(4, '0')}`;
    const medPrice = 10 + i;
    const labCost = 200 + i * 25;
    add('INSURANCE_PROVIDER', 'Policy_No,Provider_Name,Coverage_Limit', [id('POL'), `Synthetic Health Plan ${i}`, 200000 + i * 25000], 'Policy_No');
    add('DEPARTMENT', 'Dept_ID,Dept_Name,Location_Block', [id('DEP'), departments[i - 1], `Block-${String.fromCharCode(69 + Math.ceil(i / 3))}`], 'Dept_ID');
    add('PHARMACY', 'Pharmacy_ID,Pharmacy_Name,Location,Contact_Number', [id('PHARM'), `Demo Community Pharmacy ${i}`, `${i} Sample Street, Chennai`, phone], 'Pharmacy_ID');
    add('MEDICINE', 'Medicine_ID,Medicine_Name,Manufacturer,Dosage_Form,Allergen_Class,Unit_Price', [id('MED'), `Synthetic Teaching Medicine ${i}`, 'Academic Demo Labs', 'Demo tablet', null, medPrice], 'Medicine_ID');
    add('LAB_TEST_CATALOG', 'Test_Catalog_ID,Test_Name,Category,Standard_Cost', [id('LAB'), `Synthetic Screening Panel ${i}`, 'Demo Screening', labCost], 'Test_Catalog_ID');
    add('PATIENT', 'Patient_ID,Policy_No,First_Name,Last_Name,Street,City,State,Zip_Code,DOB,Gender,Emergency_Contact', [id('PAT'), id('POL'), firstNames[i - 1], lastNames[i - 1], `${i} Sample Street`, 'Chennai', 'TN', '600001', raw(`DATE '${1980 + i}-04-15'`), i % 2 ? 'Female' : 'Male', phone], 'Patient_ID');
    add('DOCTOR', 'Doctor_ID,Dept_ID,First_Name,Last_Name,Specialization,Email,Primary_Phone', [id('DOC'), id('DEP'), firstNames[(i + 4) % 17], lastNames[(i + 6) % 17], departments[i - 1], `doctor.${suffix.toLowerCase()}@example.invalid`, `900001${String(i).padStart(4, '0')}`], 'Doctor_ID');
    add('PATIENT_PHONE', 'Patient_ID,Phone_Number', [id('PAT'), phone], 'Patient_ID,Phone_Number');
    add('DOCTOR_QUALIFICATION', 'Doctor_ID,Qualification', [id('DOC'), 'MBBS (Synthetic teaching record)'], 'Doctor_ID,Qualification');
    add('MEDICAL_LOG', 'Patient_ID,Log_Seq_No,Log_Date,Diagnosis,Attachment_Path', [id('PAT'), 1, date, diagnoses[(i - 1) % diagnoses.length], null], 'Patient_ID,Log_Seq_No');
    add('LOG_ALLERGIES', 'Patient_ID,Log_Seq_No,Allergy_Name', [id('PAT'), 1, allergies[(i - 1) % allergies.length]], 'Patient_ID,Log_Seq_No,Allergy_Name');
    add('APPOINTMENT', 'Appointment_ID,Patient_ID,Doctor_ID,Appointment_Date,Appointment_Time,Status,Consultation_Mode,Meeting_Link', [id('APT'), id('PAT'), id('DOC'), date, '10:00 AM', 'Completed', 'Virtual', `https://example.invalid/teaching/room/${suffix}`], 'Appointment_ID');
    // The live appointment trigger already creates SES-Sxx. Reuse that key.
    add('TELEMEDICINE_SESSION', 'Appointment_ID,Session_ID,Start_Time,End_Time,Network_Quality_Log,Chat_Transcript_URL', [id('APT'), id('SES'), raw(`${date.sql} + 10/24`), raw(`${date.sql} + 10/24 + 20/1440`), 'Good', null], 'Appointment_ID,Session_ID');
    statements.get('TELEMEDICINE_SESSION').push(`UPDATE TELEMEDICINE_SESSION SET Start_Time = ${date.sql} + 10/24, End_Time = ${date.sql} + 10/24 + 20/1440, Network_Quality_Log = 'Good'\nWHERE Appointment_ID = '${id('APT')}' AND Session_ID = '${id('SES')}' AND Network_Quality_Log = 'Session created automatically';`);
    add('PRESCRIPTION', 'Appointment_ID,Prescription_No,Pharmacy_ID,Issue_Date,Notes', [id('APT'), id('RX'), id('PHARM'), date, 'Synthetic academic example; not clinical advice'], 'Appointment_ID,Prescription_No');
    add('PRESCRIPTION_ITEM', 'Appointment_ID,Prescription_No,Item_Seq_No,Medicine_ID,Dosage,Duration_Days,Quantity', [id('APT'), id('RX'), 1, id('MED'), 'Demo dose once daily', 5, 5], 'Appointment_ID,Prescription_No,Item_Seq_No');
    add('LAB_ORDER', 'Order_ID,Appointment_ID,Test_Catalog_ID,Order_Date,Priority', [id('ORD'), id('APT'), id('LAB'), date, i % 4 === 0 ? 'Urgent' : 'Routine'], 'Order_ID');
    add('TEST_RESULT', 'Order_ID,Result_Seq_No,Result_Value,Report_Date,Technician_Remarks,Document_URL,File_Format', [id('ORD'), 1, `Synthetic panel ${i}: within demo reference range`, date, 'Synthetic academic data', null, null], 'Order_ID,Result_Seq_No');
    add('BILLING_INVOICE', 'Appointment_ID,Invoice_No,Billing_Date,Total_Amount,Payment_Status', [id('APT'), id('INV'), date, 5 * medPrice + labCost, i % 3 ? 'Paid' : 'Pending'], 'Appointment_ID,Invoice_No');
}
const countQuery = tables.map((table, index) => `${index ? 'UNION ALL ' : ''}SELECT '${table}' AS Table_Name, COUNT(*) AS Total FROM ${table}`).join('\n') + '\nORDER BY Table_Name;';
const validation = `DECLARE\n    v_count NUMBER;\nBEGIN\n${tables.map(table => `    SELECT COUNT(*) INTO v_count FROM ${table};\n    IF v_count < 25 THEN\n        RAISE_APPLICATION_ERROR(-20025, '${table} has fewer than 25 records');\n    END IF;`).join('\n')}\nEND;\n/`;
const body = tables.map(table => `-- ${table}: 17 additional synthetic records\n${statements.get(table).join('\n\n')}`).join('\n\n');
const seed = `-- Academic expansion: preserve existing rows, add 17 linked synthetic examples per table.\n-- Reserved IDs contain -S01 through -S17; repeat execution does not duplicate rows.\n-- No DDL, sequence changes, deletes or commits occur before count validation.\n\n${body}\n\n${validation}\n\nCOMMIT;\n\n${countQuery}\n`;
fs.writeFileSync(path.join(root, 'database/academic_seed.sql'), seed);
const schemaPath = path.join(root, 'database/telemedicine_ehr.sql');
let schema = fs.readFileSync(schemaPath, 'utf8');
const begin = '-- BEGIN GENERATED ACADEMIC SEED';
const end = '-- END GENERATED ACADEMIC SEED';
const block = `${begin}\n${body}\n\n${validation}\n${end}\n\n`;
if (schema.includes(begin)) {
    schema = schema.slice(0, schema.indexOf(begin)) + block + schema.slice(schema.indexOf(end) + end.length).replace(/^\s*\n/, '').replace(/^\s*\n/, '');
} else {
    schema = schema.replace('\nCOMMIT;', `\n${block}COMMIT;`);
}
const verificationStart = schema.indexOf('-- 7. VERIFICATION & RECORD COUNT CHECKS');
const queryStart = schema.indexOf('SELECT ', verificationStart);
if (verificationStart < 0 || queryStart < 0) throw new Error('Missing schema verification section');
schema = schema.slice(0, queryStart) + countQuery + '\n';
fs.writeFileSync(schemaPath, schema);
console.log('Generated academic_seed.sql and refreshed the full setup seed (18 tables).');
