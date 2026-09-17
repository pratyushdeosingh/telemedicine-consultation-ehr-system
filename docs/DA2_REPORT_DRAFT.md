# Telemedicine Consultation and EHR System — DA2 report draft

Use this as the agreed technical content for the required handwritten report. Add the institution cover page, student names, register numbers, faculty details and the approved DA1 ER diagram before writing the final copy.

## 1. Problem statement

Telemedicine produces connected data about patients, doctors, appointments, online sessions, medical history, prescriptions, laboratory tests and billing. Maintaining these records separately causes duplication and makes it difficult to trace a complete care journey. This project implements a normalized Oracle database and a demonstration web application that stores and retrieves the related records consistently.

## 2. Objectives

- Model the telemedicine care workflow using a relational database.
- enforce entity, referential and domain integrity with Oracle constraints;
- store realistic linked sample data;
- demonstrate SQL selection, joins, grouping, subqueries, set operations and reports;
- implement reusable PL/SQL business logic;
- prevent prescriptions that conflict with a recorded patient allergy; and
- demonstrate database reads and writes through an Express and React application.

## 3. Three-layer architecture

```text
React/Vite dashboard → Express REST API → Oracle database
```

The browser calls REST endpoints. Express validates the request, executes parameterized SQL or PL/SQL through `node-oracledb`, commits successful transactions and rolls back failed transactions. Oracle is the authoritative store. The React dashboard presents the returned JSON and provides forms for selected write operations.

## 4. Relational schema and data dictionary

| Table | Purpose | Primary key | Important relationship |
| --- | --- | --- | --- |
| `INSURANCE_PROVIDER` | Insurance policy and coverage master | `Policy_No` | Referenced by `PATIENT` |
| `DEPARTMENT` | Hospital department master | `Dept_ID` | Referenced by `DOCTOR` |
| `PHARMACY` | Dispensing-pharmacy master | `Pharmacy_ID` | Referenced by `PRESCRIPTION` |
| `MEDICINE` | Medicine, price and allergen-class master | `Medicine_ID` | Referenced by `PRESCRIPTION_ITEM` |
| `LAB_TEST_CATALOG` | Available tests and standard cost | `Test_Catalog_ID` | Referenced by `LAB_ORDER` |
| `PATIENT` | Patient identity, address and insurance | `Patient_ID` | Parent of phones, logs and appointments |
| `DOCTOR` | Doctor contact and specialization | `Doctor_ID` | Belongs to `DEPARTMENT` |
| `PATIENT_PHONE` | Multivalued patient phone numbers | `Patient_ID, Phone_Number` | Child of `PATIENT` |
| `DOCTOR_QUALIFICATION` | Multivalued doctor qualifications | `Doctor_ID, Qualification` | Child of `DOCTOR` |
| `MEDICAL_LOG` | Sequenced patient diagnoses | `Patient_ID, Log_Seq_No` | Child of `PATIENT` |
| `LOG_ALLERGIES` | Allergies attached to medical logs | `Patient_ID, Log_Seq_No, Allergy_Name` | Child of `MEDICAL_LOG` |
| `APPOINTMENT` | Patient-doctor consultation booking | `Appointment_ID` | Links `PATIENT` and `DOCTOR` |
| `TELEMEDICINE_SESSION` | Virtual-session timing and evidence | `Appointment_ID, Session_ID` | Child of `APPOINTMENT` |
| `PRESCRIPTION` | Prescription header | `Appointment_ID, Prescription_No` | Child of appointment; references pharmacy |
| `PRESCRIPTION_ITEM` | Medicine lines in a prescription | `Appointment_ID, Prescription_No, Item_Seq_No` | Child of prescription; references medicine |
| `LAB_ORDER` | Test ordered during an appointment | `Order_ID` | References appointment and test catalog |
| `TEST_RESULT` | One or more results for a lab order | `Order_ID, Result_Seq_No` | Child of `LAB_ORDER` |
| `BILLING_INVOICE` | Appointment invoice and payment state | `Appointment_ID, Invoice_No` | Child of `APPOINTMENT` |

## 5. Integrity constraints

- Primary keys uniquely identify every master and transaction record.
- Foreign keys prevent orphan appointments, prescriptions, lab results and invoices.
- `ON DELETE CASCADE` is used for composition-style child records such as patient phones and prescription items.
- `ON DELETE SET NULL` retains a patient or prescription if an optional insurance provider or pharmacy is removed.
- `NOT NULL` protects mandatory names, dates and medical values.
- `UNIQUE` prevents two doctors from sharing the same email address.
- `CHECK` constraints restrict appointment status, consultation mode, lab priority and payment status to approved values.
- Foreign-key indexes improve common relationship lookups.

## 6. Normalization

The schema follows third normal form. Repeating phone numbers and qualifications are moved into separate relations, satisfying first normal form. Attributes in composite-key tables depend on the complete key, satisfying second normal form. Department, pharmacy, medicine, test and insurance facts are stored once in master relations rather than transitively inside transaction tables, satisfying third normal form. This reduces update anomalies while preserving the complete care workflow through foreign keys.

## 7. Sample data

All 18 tables contain linked synthetic records. The sample covers insured and uninsured patients, eight medical departments, virtual and in-person consultations, multiple medicines in one prescription, different laboratory priorities, repeated telemedicine sessions and paid or pending invoices. No real patient data is used.

## 8. SQL demonstrations

`database/queries.sql` contains 14 labelled demonstrations:

1. status filtering and ordering;
2. patient–doctor–department appointment join;
3. outer join for insured and uninsured patients;
4. doctor workload using grouping and `HAVING`;
5. scalar and correlated subqueries;
6. prescription cost arithmetic across composite-key tables;
7. medical history and allergy aggregation with `LISTAGG`;
8. joined laboratory order and result report;
9. timestamp-based session duration calculation;
10. invoice reconciliation using a PL/SQL function;
11. patient and doctor contact set operation;
12. doctor qualification aggregation;
13. zero-row allergy-conflict audit; and
14. row counts for every project table.

The final report should include the SQL and result grid for the strongest examples rather than screenshots of every line.

## 9. PL/SQL programs

### `Calculate_Invoice_Total`

This function receives an appointment ID, totals medicine quantity multiplied by unit price, adds the catalog cost of ordered laboratory tests and returns the calculated invoice total. The reconciliation query confirms that every seeded invoice has zero variance.

### `Register_New_Patient`

This procedure obtains the next sequence value, formats a patient identifier and inserts the patient details supplied by the API. It centralizes identifier generation in the database.

### `Update_Appointment_Status`

This procedure updates an appointment and raises a controlled application error when the appointment does not exist.

### `Prevent_Allergic_Prescription`

This row-level trigger runs before a medicine is inserted or changed in a prescription item. It resolves the appointment's patient, reads the medicine allergen class and checks the patient's recorded allergies. A match raises Oracle error `-20002`, preventing the unsafe row. The Express transaction then rolls back the prescription header as well.

### `TRG_CREATE_TELEMEDICINE_SESSION`

This teammate-contributed row-level trigger runs after a new `Virtual` appointment is inserted. It creates a placeholder telemedicine session with a generated session ID in the same transaction. A failed appointment transaction also rolls back the session. The separate `database/telemedicine_session_trigger.sql` file installs it on an existing schema without rebuilding tables; live validation evidence must be captured before claiming it passed.

## 10. Testing summary

| Test | Expected result | Actual result |
| --- | --- | --- |
| Create all schema objects | 18 project tables and valid PL/SQL | Pass |
| Run query portfolio | Every statement executes | 14/14 pass |
| Count sample records | Every project table is non-empty | 18/18 pass |
| Reconcile invoices | Calculated minus stored total is zero | 8/8 pass |
| Insert Amoxicillin for Penicillin-allergic patient | Trigger rejects the row | Pass, Oracle `-20002` |
| Call conflict through REST API | Controlled response and rollback | Pass, HTTP 409; zero rows persisted |
| Backend JavaScript checks | No syntax errors | Pass |
| Frontend lint and production build | No lint/build errors | Pass |

## 11. Application demonstration sequence

1. Show the ER diagram and the 18 Oracle tables.
2. Show constraints and valid PL/SQL objects in SQL Developer.
3. Run selected queries from `queries.sql`.
4. Run `trigger_demo.sql` and show the rejection plus zero stored rows.
5. Start Express and prove `/api/test-db` succeeds.
6. Open the website in live Oracle mode.
7. Create a patient or appointment, then verify the row in Oracle.
8. Attempt the allergy-conflicting prescription and explain the database rollback.
9. Show that invoice stored and calculated totals agree.

## 12. Conclusion and limitations

The project demonstrates a normalized Oracle implementation of the DA1 telemedicine design, meaningful SQL reporting, PL/SQL business logic, database-enforced safety and full-stack integration. It is an academic prototype using synthetic data. Authentication, role-based authorization, encryption policy, audit logging and production deployment controls are intentionally identified as future hardening work and must be completed before any real healthcare use.
