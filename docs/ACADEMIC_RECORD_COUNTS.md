# Academic record expansion

Verified 15 October 2026 (Asia/Calcutta) against the configured Oracle database.

17 linked synthetic teaching examples were added to every table. Existing records were retained.

| Table | Records |
| --- | ---: |
| APPOINTMENT | 38 |
| BILLING_INVOICE | 37 |
| DEPARTMENT | 25 |
| DOCTOR | 25 |
| DOCTOR_QUALIFICATION | 25 |
| INSURANCE_PROVIDER | 25 |
| LAB_ORDER | 37 |
| LAB_TEST_CATALOG | 25 |
| LOG_ALLERGIES | 59 |
| MEDICAL_LOG | 37 |
| MEDICINE | 26 |
| PATIENT | 37 |
| PATIENT_PHONE | 25 |
| PHARMACY | 25 |
| PRESCRIPTION | 37 |
| PRESCRIPTION_ITEM | 38 |
| TELEMEDICINE_SESSION | 28 |
| TEST_RESULT | 27 |

All 18 tables meet the minimum of 25 records. All constraints were enabled and validated. All 17 new invoice totals matched Calculate_Invoice_Total; no synthetic prescription/allergy conflicts were found. The appointment trigger produced exactly one session per new virtual appointment. Repeating all 306 seed MERGE statements changed no counts; that verification transaction was rolled back.

The full setup SQL includes the expansion. Deterministic generation and static fresh-setup counts (25 per table, 26 medicines and prescription items) were checked; the live database was not recreated.

Cassandra timeline refresh completed on 15 October 2026 after explicit user authorization: 213 Oracle source events were written across 49 patient/month partitions, with zero failures. Oracle was read-only during the refresh.

`npm run timeline:verify` passed against the connected databases: all 213 source event summaries/dates matched, repeat imports created no duplicates, and real timeline API checks passed for pagination, date ordering, month validation, empty partitions, and health.
