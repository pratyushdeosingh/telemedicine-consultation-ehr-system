# Functional dependencies and normalization

This analysis covers the implemented [Oracle relations](relational-schema.md). Dependencies follow the declared identifiers and business assumptions. Names, phone numbers and postal codes are not assumed to identify people or locations uniquely.

## Initial relation

A combined consultation record would contain:

```text
CareRecord(Appointment_ID, appointment fields,
  Patient_ID, patient fields, {Phone_Number}, Policy_No, Provider_Name, Coverage_Limit,
  Doctor_ID, doctor fields, Dept_ID, Dept_Name, Location_Block, {Qualification},
  Prescription_No, Issue_Date, Notes, Pharmacy_ID, pharmacy fields,
  {Item_Seq_No, Medicine_ID, medicine fields, Dosage, Duration_Days, Quantity},
  {Order_ID, Test_Catalog_ID, test fields, Order_Date, Priority,
    {Result_Seq_No, Result_Value, Report_Date, result fields}},
  {Invoice_No, Billing_Date, Total_Amount, Payment_Status})
```

Braces denote repeating groups. A single relation repeats patient/catalog details and introduces insertion, update and deletion anomalies. Clinical history similarly contains repeated dated entries and allergies.

## Functional dependencies

| Determinant | Dependent attributes |
| --- | --- |
| Patient_ID | Policy_No, First_Name, Last_Name, Street, City, State, Zip_Code, DOB, Gender, Emergency_Contact |
| Policy_No | Provider_Name, Coverage_Limit |
| Doctor_ID | Dept_ID, First_Name, Last_Name, Specialization, Email, Primary_Phone |
| Email (DOCTOR) | Doctor_ID and remaining doctor attributes; Email is UNIQUE NOT NULL |
| Dept_ID | Dept_Name, Location_Block |
| Pharmacy_ID | Pharmacy_Name, Location, Contact_Number |
| Medicine_ID | Medicine_Name, Manufacturer, Dosage_Form, Allergen_Class, Unit_Price |
| Test_Catalog_ID | Test_Name, Category, Standard_Cost |
| Appointment_ID | Patient_ID, Doctor_ID, Appointment_Date, Appointment_Time, Status, Consultation_Mode, Meeting_Link |
| (Patient_ID, Log_Seq_No) | Log_Date, Diagnosis, Attachment_Path |
| (Appointment_ID, Session_ID) | Start_Time, End_Time, Network_Quality_Log, Chat_Transcript_URL |
| (Appointment_ID, Prescription_No) | Pharmacy_ID, Issue_Date, Notes |
| (Appointment_ID, Prescription_No, Item_Seq_No) | Medicine_ID, Dosage, Duration_Days, Quantity |
| Order_ID | Appointment_ID, Test_Catalog_ID, Order_Date, Priority |
| (Order_ID, Result_Seq_No) | Result_Value, Report_Date, Technician_Remarks, Document_URL, File_Format |
| (Appointment_ID, Invoice_No) | Billing_Date, Total_Amount, Payment_Status |

PATIENT_PHONE, DOCTOR_QUALIFICATION and LOG_ALLERGIES are keyed associations whose full primary keys identify occurrences without further descriptive attributes. Prescription/invoice numbers are not declared globally unique.

## 1NF: remove repeating groups

Store atomic values and separate occurrences. Extract `PATIENT_PHONE(Patient_ID, Phone_Number)` and `DOCTOR_QUALIFICATION(Doctor_ID, Qualification)`. Separate history entries/allergies, sessions, prescriptions/items, orders/results and invoices instead of storing lists in a consultation row.

## 2NF: remove partial dependencies

For a flattened prescription row keyed by `(Appointment_ID, Prescription_No, Item_Seq_No)`, issue date/notes depend only on `(Appointment_ID, Prescription_No)` and consultation details on `Appointment_ID`. Decompose into APPOINTMENT, PRESCRIPTION and PRESCRIPTION_ITEM, so non-key attributes depend on complete keys.

For history/allergy rows keyed by `(Patient_ID, Log_Seq_No, Allergy_Name)`, diagnosis/date depend on `(Patient_ID, Log_Seq_No)` and patient details on `Patient_ID`. Separate PATIENT, MEDICAL_LOG and LOG_ALLERGIES. Order details depend on `Order_ID`, whereas result details depend on `(Order_ID, Result_Seq_No)`; separate LAB_ORDER and TEST_RESULT.

## 3NF: remove transitive dependencies

`Patient_ID → Policy_No → (Provider_Name, Coverage_Limit)` becomes PATIENT plus INSURANCE_PROVIDER. `Doctor_ID → Dept_ID → (Dept_Name, Location_Block)` becomes DOCTOR plus DEPARTMENT. Medicine descriptions/prices depend on Medicine_ID, so they belong to MEDICINE. Test names/categories/costs depend on Test_Catalog_ID, so they belong to LAB_TEST_CATALOG. Pharmacy details belong to PHARMACY rather than PRESCRIPTION.

Under the listed dependencies, the 18 resulting Oracle relations avoid these partial/transitive dependencies. Decompositions retain identifiers as foreign keys; joins through referenced primary keys reconstruct associated information without multiple parent matches. See [relational-schema.md](relational-schema.md) for the resulting relations, PKs, FKs and alternate doctor-email key.

## Stored totals and deliberate denormalization

BILLING_INVOICE stores an amount/state at creation or recalculation; the current catalog-derived charge total may later differ. The application exposes the variance and requires reconciliation before payment. The stored total is not treated as a permanently equal copy of the current computed value.

Cassandra deliberately copies patient names/summaries into `clinical_events_by_patient_month` to answer a patient/month query without joins. It is a separate read model, with explicit refresh/staleness limits described in [architecture.md](architecture.md).
