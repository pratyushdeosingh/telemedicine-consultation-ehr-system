# Pratyush: deployed-website recording runbook

Source-checked preparation for the final team video. The actions below are instructions for rehearsal, not a claim that production data or database objects have been verified today. This runbook supersedes the earlier suggestion that the allergy warning prevents form submission.

## Recording goal

Show five connected workflows in about 2:15: patient/history, virtual appointment with automatic session creation, prescription rejection and successful save, laboratory order/result, and calculated billing. Registration and history entry can be prepared before recording; briefly show their saved result. This leaves time for meaningful database behavior rather than extensive typing.

Team target: Sarbajeet 1:10, Pratyush 2:15, Dhuna 1:10, end card 0:05 = 4:40. Keep all faces visible in their own segments. Sarbajeet should show the database/query evidence; Dhuna can show test/rollback evidence and explain Cassandra.

## 1. Before rehearsing

1. Open https://telemedicine-consultation-ehr-syste.vercel.app/ and sign in before recording. Verify actual records load and Oracle is available. Check Cassandra if the team plans to show it.
2. Set up browser capture, microphone and a webcam overlay. Keep the camera off form buttons/results. Make and review a short trial recording.
3. Use one synthetic patient. Suggested first/last name: `Demo` / `NovemberA`; DOB `2000-01-01`; city `Chennai`; gender `Other`; leave optional contact/address/insurance fields empty unless useful. This is fictional demonstration data.
4. Under Patients, click Register patient, enter the required fields and save. Search `NovemberA` and note the generated patient ID. Clicking the patient's name opens their Medical history.
5. Add a medical history entry for that patient: entry date `2026-11-01` if recording on that date (otherwise the actual recording date); diagnosis `Synthetic database demonstration`; Known medicine allergy classes `PENICILLIN`, if offered by the current catalog. Save. Verify the recorded class is visible.
6. Confirm the current catalog offers Amoxicillin with the Penicillin class and Paracetamol with no matching class for this patient. These correspond to MED-01 and MED-02 in the checked-in seed; verify the deployed data rather than assuming IDs/prices are unchanged. The latter is a demonstration of class matching, not a medical safety recommendation.
7. Prepare a short note sheet: patient ID, chosen doctor, date, new appointment ID once generated, prescription number, selected medicine, selected lab test, order ID once generated. Use one appointment consistently.
8. Rehearsal creates real synthetic demo records on the hosted application. For the final take, use a fresh appointment and an unused prescription number rather than repeating already successful inserts. Keep the invoice Pending until all charges are added.

If PENICILLIN or the medicine is missing, select an actual matching medicine/class pair from the current catalog and record that class on the synthetic patient's history. Do not relabel a mismatch as successful trigger evidence.

## 2. Five-feature rehearsal: exact actions

### Feature 1: linked patient history

Open Patients, search NovemberA and show the saved ID. Click the name to open Medical history. Show the dated entry and Known medicine classes containing PENICILLIN. This is the prerequisite for the later trigger demonstration.

Say: "This synthetic patient's history includes a recorded Penicillin allergy. The same patient identity links their consultation, prescription, lab records and invoice."

Registration does not need to be typed live in the final take. Show the saved record honestly as pre-entered demonstration data.

### Feature 2: virtual appointment and automatic-session trigger

1. Open Appointments -> Book appointment.
2. Select the synthetic patient and a real listed doctor. Briefly note that the selected doctor's department and qualifications are displayed.
3. Set date to recording date, time `10:30 AM`, status Scheduled, mode Virtual; leave the optional meeting link empty.
4. Click Book appointment. Note the generated appointment ID from the success message.
5. Find that appointment and expand Telemedicine session records. Expect one automatically created placeholder session with network text `Session created automatically`; start/end times are not yet recorded.

Say: "Booking a virtual appointment fires our AFTER INSERT trigger, which automatically creates the related session record in the same transaction. We did not enter a separate session."

Source: database/telemedicine_session_trigger.sql and the matching trigger in database/telemedicine_ehr.sql. This application stores session metadata; it does not host a video call.

### Feature 3: allergy trigger, rollback and successful prescription

1. Open Prescriptions -> Create prescription. Select the NEW appointment, not an old paid/refunded appointment.
2. Enter an unused prescription number such as `RX-VID-A1`; use the recording date. Pharmacy is optional.
3. Select the verified Penicillin-class medicine (seed example: Amoxicillin). Dosage: `Synthetic demo only`; duration: `1`; quantity: `1`. These values are academic test inputs, not prescribing guidance.
4. Pause on the advance warning: `Warning: this medicine matches a recorded allergy. Choose a different medicine.`
5. Click Create prescription. In the checked source, allergy conflict does NOT disable this button. The request reaches the backend; Oracle's BEFORE INSERT trigger raises error -20002, and the backend rolls back and returns HTTP 409 with an allergy-conflict message.
6. Show the returned rejection. Do not describe only the advance warning as proof the database trigger ran.
7. Keep the same prescription number; replace the medicine with the verified nonmatching catalog option (seed example: Paracetamol). Save and show the successful prescription card. Reusing the number after rejection is useful supporting evidence that a failed save did not retain the header; database counts provide stronger proof.

Say: "The form warns about the recorded allergy. Submitting still reaches Oracle, where our trigger rejects the conflicting medicine. The backend rolls back the prescription. A medicine without this recorded class conflict can then be saved."

Source: frontend/src/pages/PrescriptionsPage.jsx, backend/server.js prescription POST handler, and Prevent_Allergic_Prescription in database/telemedicine_ehr.sql. The trigger matches recorded medicine classes, ignoring case/outer whitespace; it does not infer ingredients, synonyms, or cross-reactivity.

If the button is disabled, check that allergy/invoice data loaded and the appointment has no Paid/Refunded invoice. If submission succeeds unexpectedly, stop and investigate the actual patient's allergy, medicine class and deployed trigger; do not present it as a passed test.

### Feature 4: lab order and retained result

1. Open Laboratory. Under Order a lab test, select the same appointment and a catalog test. Use recording date and Routine priority; click Create lab order.
2. Note the generated order ID. Under Record a test result, select that order, use report date equal to or later than the order date, result `Synthetic demonstration result`, remarks `Academic test data`; leave optional document fields empty.
3. Click Save test result. Search the appointment/order/patient to show the order and Reported status with its saved result.

Say: "The lab order links a catalog test to this appointment. Recording its result changes its displayed state to Reported while preserving the order-to-result relationship."

For a shorter final take, create the order on camera, cut a typing pause, then show the actual saved result. A document reference is not an uploaded/hosted report file.

### Feature 5: calculated invoice and status rules

1. Open Billing -> Generate an invoice. Select the same appointment without an invoice and use recording date. Click Generate invoice.
2. Find the new Pending invoice and click View charges. Show medicine quantity x catalog price and lab charges. The stored total should equal the displayed current calculated total.
3. Optional rehearsal extension: while the invoice is Pending, add another lab order for the same appointment. Return to Billing (reload if needed). Show the variance and disabled Mark paid. Click Recalculate; show matching totals and Mark paid available again.
4. Only after all desired charges are entered, optionally click Mark paid. The status records payment; no money is transferred. Paid/refunded appointments reject further prescription/lab charges. Do not settle the appointment before the prescription/lab demonstrations.

Say: "Oracle's invoice function calculates the total from medicine quantities and lab orders. We can inspect the individual charges. If charges change while payment is pending, the invoice must be recalculated before it can be marked paid."

Use the initial invoice/breakdown in the main take. Recalculation and payment are bonus clips; keep them only if timing permits or let Dhuna use them as validation evidence.

## 3. Final take: 2:15 cue sheet

| Time | Screen/action | Narration cue |
| --- | --- | --- |
| 0:00-0:15 | Saved synthetic patient and recorded allergy | Patient identity connects the workflow; allergy is recorded beforehand. |
| 0:15-0:40 | Book Virtual appointment; expand generated session | AFTER INSERT trigger creates related session automatically. |
| 0:40-1:20 | Submit conflicting prescription, show rejection, change medicine and save | Advance warning, database rejection, rollback, successful alternative. |
| 1:20-1:45 | Lab order and saved result | Appointment -> order -> result; show Reported. |
| 1:45-2:10 | Generate invoice and View charges | Calculated total from medicine and lab charges. |
| 2:10-2:15 | Leave useful result visible; hand off | "Dhuna will now explain our design decisions, tests and outcomes." |

Record each workflow as a separate clip if necessary, with camera and narration. Cut typing/navigation pauses, preserve actual operation/results and keep the same patient/appointment identity. If speech/clicks cannot fit at readable speed, prepare more form fields in advance or shorten commentary. Do not try to fit all optional demonstrations into this cut.

### Spoken script

"I'll demonstrate the connected workflow using a synthetic patient whose history records a Penicillin allergy.

First, I book a virtual appointment with a doctor. The patient and doctor are connected through this appointment. Expanding its session records shows a session created automatically by our AFTER INSERT trigger. No separate session entry was needed.

Next, I attempt a prescription for a medicine in the recorded allergy class. The interface displays an early warning. On submission, Oracle's BEFORE INSERT trigger rejects the conflicting item, and the backend rolls back the prescription transaction. This error is returned from the server. I now select a medicine without this recorded class conflict, and the prescription saves successfully.

For the same appointment, I order a laboratory test and record its result. The saved order now displays the result and a Reported status. The order and result are retained as related records.

Finally, I generate the invoice. The database function calculates the amount from medicine quantities and laboratory charges. View charges shows the individual items behind that total. Pending invoices can be recalculated if charges change, while settled appointments reject further charges.

These workflows show connected database operations, automatic triggers, validation and calculated results. Dhuna will now explain the design choices, testing and outcomes."

Read the script only alongside the matching actual outputs. The final sentence about recalculation/settled charges is an explanation; omit it if those behaviors are not covered elsewhere in the team's evidence.

## 4. SQL evidence for Sarbajeet or Dhuna

Use an already configured SQL client and a project schema connection. Run the following read-only checks after replacing the example IDs with the IDs observed during rehearsal. Do not show credentials, wallet files or connection secrets. Do not run schema creation or trigger replacement for the video.

Session trigger evidence (same newly created appointment):

```sql
SELECT Appointment_ID, Patient_ID, Consultation_Mode, Status
FROM APPOINTMENT WHERE Appointment_ID = 'REPLACE_APT';

SELECT Appointment_ID, Session_ID, Network_Quality_Log
FROM TELEMEDICINE_SESSION WHERE Appointment_ID = 'REPLACE_APT';
```

Allergy rollback evidence: run these AFTER the rejected attempt and BEFORE retrying the successful medicine. Both counts should be zero. Capture this point separately during rehearsal if necessary.

```sql
SELECT COUNT(*) AS Header_Count FROM PRESCRIPTION
WHERE Appointment_ID = 'REPLACE_APT' AND Prescription_No = 'RX-VID-A1';

SELECT COUNT(*) AS Item_Count FROM PRESCRIPTION_ITEM
WHERE Appointment_ID = 'REPLACE_APT' AND Prescription_No = 'RX-VID-A1';
```

After successful prescription and billing, show the nonzero saved records/total:

```sql
SELECT Appointment_ID, Prescription_No, Medicine_ID, Quantity
FROM PRESCRIPTION_ITEM WHERE Appointment_ID = 'REPLACE_APT';

SELECT Appointment_ID, Invoice_No, Total_Amount, Payment_Status,
       Calculate_Invoice_Total(Appointment_ID) AS Current_Calculated_Total
FROM BILLING_INVOICE WHERE Appointment_ID = 'REPLACE_APT';
```

Optional database object status:

```sql
SELECT t.Trigger_Name, t.Status AS Enabled_Status, o.Status AS Object_Status
FROM USER_TRIGGERS t JOIN USER_OBJECTS o
  ON o.Object_Name = t.Trigger_Name AND o.Object_Type = 'TRIGGER'
WHERE t.Trigger_Name IN
  ('PREVENT_ALLERGIC_PRESCRIPTION', 'TRG_CREATE_TELEMEDICINE_SESSION');
```

Existing backend integration command `npm run db:verify-workflows` verifies real trigger rejection, full rollback including an earlier accepted item, session creation and billing rules using rolled-back test transactions. It requires configured Oracle access and a suitable test environment; do not claim results until actually run. Automated `npm test` alone does not prove live database behavior.

## 5. Optional Cassandra clip

Let Dhuna include this if time permits: open Cassandra Timeline, select the demo patient and the month of the entered events, click Refresh from Oracle and wait for completion. Show a newly imported event and its details. Explain that this copies new/updated events manually, not automatic synchronization. A green connection indicator alone does not establish fresh data. Refresh affects all patients; do not assume it is scoped to the selected patient.

Alternative: use a populated seed patient/month, clearly identified as a separate example. November defaults can appear empty for records entered in August/September. Keep any refresh wait out of the tight main narration.

## 6. Recording and handoff checklist

- [ ] Rehearse all five workflows on the deployed app; note actual IDs and outputs.
- [ ] Capture both trigger results and rejection/rollback evidence.
- [ ] Confirm the final take uses a fresh appointment/unused prescription number.
- [ ] Sign in before capture; webcam visible; text readable; microphone tested.
- [ ] Capture successful saved results, not only forms or optimistic descriptions.
- [ ] Keep raw clips outside Git; retain them for editing.
- [ ] Trim Pratyush segment to 2:15 and send clips plus ID/evidence notes for integration.
- [ ] Combine Sarbajeet -> Pratyush -> Dhuna; final video <=5:00 with every member shown.
- [ ] Check exported speech, readable SQL results and continuity of patient/appointment IDs.
- [ ] Upload Unlisted/Public; verify signed-out access; place final URL in README and submission Word document.
