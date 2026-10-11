# D.A. 2 workflow completion

## Implemented

- Medical history page with patient filtering, dated diagnosis entries, attachment references, and allergies linked to each entry. Known medicine classes use a multi-select control populated from the medicine catalog; other allergies have a separate text field. Click a patient's name in the directory to open their history.
- Laboratory page with orders and all reported results, priority, catalog cost, result dates, remarks, and document references. Create orders and record additional result entries.
- Billing actions: generate one invoice per appointment, view current medicine/lab charges, recalculate a pending invoice, mark it paid, and mark a paid invoice refunded.
- Prescription form shows recorded patient allergies and a warning when a medicine's allergen class matches. Oracle still enforces the rejection even if a client bypasses the warning.
- Mobile navigation includes the new pages. Preview data remains read-only.

No new tables, schema reset, migrations, or Cassandra changes are needed for these features. Existing records are retained. Documents are references only; uploading/storing files is outside this change.

## Simple database explanations

| Operation | SQL idea | Explanation |
| --- | --- | --- |
| Read medical history | `SELECT` and `JOIN` | Join `MEDICAL_LOG` to `PATIENT` to display the patient's name with a diagnosis. |
| Read allergies | `SELECT ... ORDER BY` | Read `LOG_ALLERGIES`; associate each allergy with its patient and history entry using both key columns. |
| Add history | `INSERT`, `MAX`, `NVL` | Find the next log number for the patient; insert the history and its allergies in one transaction. `NVL` supplies zero when there is no previous entry. |
| Read lab data | Joins | Connect an order to its appointment, patient, and catalog test. Connect results through the order ID. |
| Add result | `INSERT`, `MAX`, `NVL` | Generate the next result number within one order and retain prior results. |
| Read itemized billing | `UNION ALL` | Combine medicine charge rows and laboratory charge rows without removing duplicates. Each ordered test is a charge. |
| Calculate invoice | Existing PL/SQL function | `CALCULATE_INVOICE_TOTAL` sums medicine quantity times unit price, plus ordered lab test costs. |
| Update billing | `UPDATE ... WHERE` | Address an invoice using both its appointment ID and invoice number, the composite primary key. |
| Prevent conflicting medicines | Existing trigger | On a prescription item insert, compare the patient's recorded allergies with the medicine class and raise Oracle error `-20002` on a match. |

`SELECT ... FOR UPDATE` locks a parent patient/order/appointment row while its related write is performed. This prevents two requests from allocating the same child sequence number or generating two invoices simultaneously through the application. Locks are released on commit or rollback. This connects to the syllabus's concurrency-control and transaction topics.

Successful writes commit. A failure rolls back the whole request, including a prescription header and any medicine items already inserted. SQL values use bind parameters instead of text concatenation.

## Business rules and limits

- A patient can have many history entries. Allergies from every entry remain part of the trigger check; this version does not provide allergy removal or a resolved-allergy status.
- Allergy matching ignores letter case and surrounding whitespace, but does not infer synonyms or medical cross-reactivity. Known medicine classes are selectable in the history form and validated against the catalog by the API. Unknown classes are rejected; a catalog class entered in the other-allergies field must be moved to the known-class selection. Existing allergy records are classified for display by their current catalog match; no schema changes are required. Missing allergy/class data is not proof of safety.
- The trigger does not retrospectively remove prescriptions inserted before it was installed. Existing records are preserved; review any historical conflict separately.
- One invoice per appointment is enforced by the new API under an appointment lock. Existing schema keys are unchanged; direct SQL can still insert multiple invoice numbers for one appointment.
- Pending totals change only through explicit recalculation. Adding charges after invoice generation can produce a variance; payment is rejected until recalculation.
- Paid/refunded invoice amounts are locked by these APIs. New prescriptions and lab orders for those appointments are rejected; lab results can still be reported because they add no charge.
- Payment/refund actions record status only. There is no payment gateway, partial-payment ledger, discount, consultation fee, or insurance-claim calculation.
- Breakdown uses current catalog prices, as does the existing function. The schema has no historical unit-price snapshots.

## API additions

| Method | Endpoint | Purpose |
| --- | --- | --- |
| GET | `/api/allergies` | Recorded allergies by patient and medical-log entry |
| POST | `/api/medical-logs` | Diagnosis/history plus allergies in one transaction |
| GET | `/api/lab-catalog` | Selectable tests and costs |
| POST | `/api/lab-orders` | Order a catalog test for an appointment |
| POST | `/api/test-results` | Record a result against an order |
| GET | `/api/billing/:appointment_id/items` | Current charge breakdown |
| POST | `/api/billing` | Generate a calculated pending invoice |
| PUT | `/api/billing/:appointment_id/:invoice_no` | Body action: `recalculate`, `pay`, or `refund` |

Appointment reads now include `patient_id` so allergy selection uses stable identity, not patient names. Existing medical-log reads return diagnoses; allergies are obtained separately from `/api/allergies`.

## Verification

Run from `backend`: `npm test`, then `npm run db:verify-workflows` with a working Oracle configuration. The second command uses real Oracle and HTTP routes, suppresses route commits, rolls each failed request back to a savepoint, and finally rolls back every synthetic change. Run this standalone script with no concurrent requests; it starts its own temporary server. It needs an enabled, valid trigger and a synthetic patient/medicine allergy pair.

The verification covers history/allergy insertion, known-class validation, other-allergy recording, case/duplicate normalization, invalid dates, appointment patient identity, a rejected multi-item prescription and complete rollback, an accepted prescription, lab order/result creation, duplicate invoices, computed totals, stale-payment rejection, recalculation, payment/refund transitions, settled-charge protection, and final cleanup.

Observed verification: all workflow checks passed against the configured Oracle database. The allergy trigger was `ENABLED` and `VALID`; a conflict produced HTTP 409 and zero prescription headers/items. All test writes were rolled back. Frontend production build and source lint passed; existing authentication tests passed with local network access.

## Demonstration sequence

1. Open a patient's medical history and explain the keys connecting allergies to log entries.
2. For a synthetic patient, record history and select an allergy using the known medicine classes control. Optionally record another allergy in the separate field; explain that it is outside automatic matching.
3. Book an appointment without a settled invoice. Select the conflicting medicine and show the warning; submitting it should fail without retaining a prescription.
4. Create a non-conflicting prescription, order a lab test, and record its result.
5. Generate an invoice and show its current charge breakdown.
6. Add another lab order, observe the variance, recalculate, then mark the invoice paid.
7. Explain why further charges are blocked and why reporting a result is still allowed.

## Release

Release these changes by committing and pushing to the GitHub production branch after verification. They do not require database setup or new environment variables. Validate the production deployment and direct navigation to `/medical-history` and `/laboratory` after the Vercel build. Never run `db:setup` to release these changes.

This guide covers the Oracle D.A. 2 workflows. The Cassandra extension has separate D.A. 3 setup, comparison, query, and demonstration guides.
