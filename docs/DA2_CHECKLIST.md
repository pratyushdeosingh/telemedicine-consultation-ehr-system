# DA2 completion and demonstration checklist

Deadline: 18 September 2026

## Database implementation

- [x] Convert the approved DA1 design into an Oracle relational schema.
- [x] Create all 18 project tables.
- [x] Define primary, foreign, unique, not-null and check constraints.
- [x] Add indexes for important foreign-key access paths.
- [x] Insert linked sample records into all 18 tables.
- [x] Create sequences for generated patient, appointment and invoice identifiers.
- [x] Create `Calculate_Invoice_Total` function.
- [x] Create `Register_New_Patient` procedure.
- [x] Create `Update_Appointment_Status` procedure.
- [x] Create `Prevent_Allergic_Prescription` trigger.
- [x] Integrate teammate's `TRG_CREATE_TELEMEDICINE_SESSION` trigger into the reproducible schema.
- [x] Install and demonstrate `TRG_CREATE_TELEMEDICINE_SESSION` in the live Always Free database using a synthetic appointment and rollback.
- [x] Reconcile every seeded billing total with the calculation function.

## SQL evidence

- [x] Keep the reproducible DDL/DML/PLSQL script in `database/telemedicine_ehr.sql`.
- [x] Keep labelled SQL demonstrations in `database/queries.sql`.
- [x] Include selection, ordering, joins, outer joins, grouping, `HAVING`, aggregate functions and subqueries.
- [x] Include meaningful healthcare reports for prescriptions, labs, medical history and billing.
- [x] Include a row-count query covering all 18 tables.
- [x] Include a zero-row allergy-conflict audit.
- [x] Keep a repeatable trigger proof in `database/trigger_demo.sql`.
- [x] Run every script against the final Oracle schema.
- [ ] Capture dated SQL Developer result grids for the report.

## Application demonstration

- [x] Express connects to Oracle and exposes read endpoints.
- [x] The website reads real patients, appointments, prescriptions and billing records.
- [x] The website can register a patient, book an appointment, update status and create a prescription.
- [x] Backend transactions commit successful writes and roll back failures.
- [x] Test a successful write and verify that it persists in Oracle.
- [x] Test a conflicting prescription through the API and verify HTTP 409 plus rollback.
- [ ] Repeat the successful and rejected writes while capturing demonstration screenshots.
- [ ] Capture `/api/test-db`, one joined endpoint response, and corresponding website data.

## Report evidence to prepare by the team

- [ ] Cover page with course, project, register numbers and contribution split.
- [ ] Problem statement and scope.
- [ ] DA1 ER diagram and relational-schema mapping.
- [ ] Data dictionary for all 18 tables.
- [ ] Constraint and normalization explanation.
- [ ] DDL and sample-data excerpts.
- [ ] Query purpose, SQL and result screenshot for the strongest queries.
- [ ] PL/SQL function, procedures and trigger with execution evidence.
- [ ] Frontend/backend/database architecture and screenshots.
- [ ] Testing table with expected result, actual result and pass/fail.
- [ ] Conclusion, limitations and references.
- [ ] Produce the required handwritten version from the agreed final content.

## Final rehearsal

- [ ] Start Oracle, then Express, then Vite in live-data mode.
- [ ] Confirm the website says `Oracle connected`, not `Preview data`.
- [ ] Ensure each teammate can explain their contribution and one end-to-end flow.
- [ ] Keep a local backup of the repository, SQL scripts, report images and screenshots.
- [ ] Do not expose `.env` or real credentials in screenshots, commits or submissions.
