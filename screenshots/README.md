# Application and database screenshots

Figures 1–19 were captured on **1 November 2026 (Asia/Kolkata)** using the local React/Express application and configured Oracle/Cassandra databases. Figure 20 is a separately dated hosted refresh result. Data is synthetic.

Figures 13–14 show the application warning and actual rejection. Figures 15–18 are browser captures of formatted **actual verification transcripts**; they are labelled accordingly and are not SQL-terminal screenshots. Underlying results and reproducible checks are in [tests/](../tests/README.md). No credentials are included.

| Figure | Screenshot | Description |
| --- | --- | --- |
| 1 | [01-overview.jpg](01-overview.jpg) | Application overview displaying 38 patient records, 38 prescriptions, 10 scheduled appointments and an outstanding invoice balance of ₹14,381.50. Oracle and Cassandra connection indicators are visible. |
| 2 | [02-patient-directory.jpg](02-patient-directory.jpg) | Patient directory showing patient identifiers, contact information and insurance details retrieved through the application. |
| 3 | [03-patient-search-result.jpg](03-patient-search-result.jpg) | Successful patient search: entering PAT-01 narrows the directory to Raman Nathan's record. |
| 4 | [04-search-no-matching-record.jpg](04-search-no-matching-record.jpg) | Empty-result handling: an unmatched search displays “No records found” instead of an application error. |
| 5 | [05-medical-history-and-allergies.jpg](05-medical-history-and-allergies.jpg) | Patient-specific medical history showing dated diagnoses and distinguishing the Penicillin medicine-class allergy from the separately recorded Peanuts allergy. |
| 6 | [06-cassandra-patient-timeline.jpg](06-cassandra-patient-timeline.jpg) | Cassandra timeline for PAT-01 in September 2026, displaying five imported events: a laboratory result, appointment, invoice, laboratory order and prescription. |
| 7 | [07-laboratory-results.jpg](07-laboratory-results.jpg) | Laboratory module displaying test orders, reporting status, result values, remarks and document references. |
| 8 | [08-appointment-statuses.jpg](08-appointment-statuses.jpg) | Appointment module displaying consultation totals, virtual/in-person classification and appointment-status controls. |
| 9 | [09-prescription-items-and-costs.jpg](09-prescription-items-and-costs.jpg) | Prescription registry displaying medicines, dosage, duration, quantities and calculated item costs. |
| 10 | [10-billing-summary-and-invoices.jpg](10-billing-summary-and-invoices.jpg) | Billing module showing collected and outstanding totals, invoice status and comparison with current calculated charges. |
| 11 | [11-invoice-variance-payment-blocked.jpg](11-invoice-variance-payment-blocked.jpg) | Invoice reconciliation protection: INV-02 has an invoice value of ₹4,530.00 and a current charge total of ₹4,684.00; the ₹154.00 variance disables “Mark paid”. |
| 12 | [12-invoice-charge-breakdown.jpg](12-invoice-charge-breakdown.jpg) | Expanded invoice breakdown explaining the current total: Paracetamol ₹30.00, Atorvastatin ₹154.00 and MRI Brain Scan ₹4,500.00, totalling ₹4,684.00. |
| 13 | [13-allergy-conflict-warning.jpg](13-allergy-conflict-warning.jpg) | Prescription form showing that Ibuprofen's NSAID class matches a recorded allergy for the patient associated with APT-24. The warning is visible before submission. |
| 14 | [14-allergy-trigger-rejection.jpg](14-allergy-trigger-rejection.jpg) | Actual application response after submitting the conflicting demonstration prescription: “The selected medicine conflicts with a recorded allergy”. The prescription is rejected. |
| 15 | [15-allergy-trigger-and-rollback-proof.jpg](15-allergy-trigger-and-rollback-proof.jpg) | Actual Oracle verification transcript showing the enabled, valid allergy trigger, ORA-20002 rejection, HTTP 409, rollback of the header and earlier safe item, and zero retained browser-test prescriptions. |
| 16 | [16-automatic-session-trigger-proof.jpg](16-automatic-session-trigger-proof.jpg) | Actual Oracle verification transcript showing the enabled, valid automatic-session trigger and successful session creation/readback during a rolled-back virtual appointment test. |
| 17 | [17-cassandra-schema-and-cql-results.jpg](17-cassandra-schema-and-cql-results.jpg) | Actual Cassandra metadata and CQL results showing the patient/month composite partition key, timestamp/event-ID clustering columns and five returned clinical events. |
| 18 | [18-cassandra-paging-and-validation.jpg](18-cassandra-paging-and-validation.jpg) | Actual API verification results: a two-event page limit returns five distinct events over three pages; an invalid month returns HTTP 400; an empty partition returns HTTP 200 with no events. |
| 19 | [19-automatic-session-in-application.jpg](19-automatic-session-in-application.jpg) | Expanded telemedicine session record in the application showing session SES-24 and the automatically generated “Session created automatically” note. |
| 20 | [20-oracle-cassandra-refresh-2026-10-11.png](20-oracle-cassandra-refresh-2026-10-11.png) | Historical hosted refresh result captured 11 October 2026: 55 records, 18 patient/month groups, zero failures. This is a dated earlier snapshot, not the 1 November run. |
