# Relational schema

Derived from the 18 `CREATE TABLE` definitions in [telemedicine_ehr.sql](../database/telemedicine_ehr.sql). PK = primary key; FK = foreign key.

## INSURANCE_PROVIDER

`INSURANCE_PROVIDER(Policy_No, Provider_Name, Coverage_Limit)`

**Primary key:** `Policy_No`.

## DEPARTMENT

`DEPARTMENT(Dept_ID, Dept_Name, Location_Block)`

**Primary key:** `Dept_ID`.

## PHARMACY

`PHARMACY(Pharmacy_ID, Pharmacy_Name, Location, Contact_Number)`

**Primary key:** `Pharmacy_ID`.

## MEDICINE

`MEDICINE(Medicine_ID, Medicine_Name, Manufacturer, Dosage_Form, Allergen_Class, Unit_Price)`

**Primary key:** `Medicine_ID`.

## LAB_TEST_CATALOG

`LAB_TEST_CATALOG(Test_Catalog_ID, Test_Name, Category, Standard_Cost)`

**Primary key:** `Test_Catalog_ID`.

## PATIENT

`PATIENT(Patient_ID, Policy_No, First_Name, Last_Name, Street, City, State, Zip_Code, DOB, Gender, Emergency_Contact)`

**Primary key:** `Patient_ID`.

- FK `(Policy_No)` → `INSURANCE_PROVIDER(Policy_No)`; ON DELETE SET NULL.

## DOCTOR

`DOCTOR(Doctor_ID, Dept_ID, First_Name, Last_Name, Specialization, Email, Primary_Phone)`

**Primary key:** `Doctor_ID`.

- FK `(Dept_ID)` → `DEPARTMENT(Dept_ID)`.

## PATIENT_PHONE

`PATIENT_PHONE(Patient_ID, Phone_Number)`

**Primary key:** `Patient_ID, Phone_Number`.

- FK `(Patient_ID)` → `PATIENT(Patient_ID)`; ON DELETE CASCADE.

## DOCTOR_QUALIFICATION

`DOCTOR_QUALIFICATION(Doctor_ID, Qualification)`

**Primary key:** `Doctor_ID, Qualification`.

- FK `(Doctor_ID)` → `DOCTOR(Doctor_ID)`; ON DELETE CASCADE.

## MEDICAL_LOG

`MEDICAL_LOG(Patient_ID, Log_Seq_No, Log_Date, Diagnosis, Attachment_Path)`

**Primary key:** `Patient_ID, Log_Seq_No`.

- FK `(Patient_ID)` → `PATIENT(Patient_ID)`; ON DELETE CASCADE.

## LOG_ALLERGIES

`LOG_ALLERGIES(Patient_ID, Log_Seq_No, Allergy_Name)`

**Primary key:** `Patient_ID, Log_Seq_No, Allergy_Name`.

- FK `(Patient_ID, Log_Seq_No)` → `MEDICAL_LOG(Patient_ID, Log_Seq_No)`; ON DELETE CASCADE.

## APPOINTMENT

`APPOINTMENT(Appointment_ID, Patient_ID, Doctor_ID, Appointment_Date, Appointment_Time, Status, Consultation_Mode, Meeting_Link)`

**Primary key:** `Appointment_ID`.

- FK `(Patient_ID)` → `PATIENT(Patient_ID)`.
- FK `(Doctor_ID)` → `DOCTOR(Doctor_ID)`.

## TELEMEDICINE_SESSION

`TELEMEDICINE_SESSION(Appointment_ID, Session_ID, Start_Time, End_Time, Network_Quality_Log, Chat_Transcript_URL)`

**Primary key:** `Appointment_ID, Session_ID`.

- FK `(Appointment_ID)` → `APPOINTMENT(Appointment_ID)`; ON DELETE CASCADE.

## PRESCRIPTION

`PRESCRIPTION(Appointment_ID, Prescription_No, Pharmacy_ID, Issue_Date, Notes)`

**Primary key:** `Appointment_ID, Prescription_No`.

- FK `(Appointment_ID)` → `APPOINTMENT(Appointment_ID)`; ON DELETE CASCADE.
- FK `(Pharmacy_ID)` → `PHARMACY(Pharmacy_ID)`; ON DELETE SET NULL.

## PRESCRIPTION_ITEM

`PRESCRIPTION_ITEM(Appointment_ID, Prescription_No, Item_Seq_No, Medicine_ID, Dosage, Duration_Days, Quantity)`

**Primary key:** `Appointment_ID, Prescription_No, Item_Seq_No`.

- FK `(Appointment_ID, Prescription_No)` → `PRESCRIPTION(Appointment_ID, Prescription_No)`; ON DELETE CASCADE.
- FK `(Medicine_ID)` → `MEDICINE(Medicine_ID)`.

## LAB_ORDER

`LAB_ORDER(Order_ID, Appointment_ID, Test_Catalog_ID, Order_Date, Priority)`

**Primary key:** `Order_ID`.

- FK `(Appointment_ID)` → `APPOINTMENT(Appointment_ID)`.
- FK `(Test_Catalog_ID)` → `LAB_TEST_CATALOG(Test_Catalog_ID)`.

## TEST_RESULT

`TEST_RESULT(Order_ID, Result_Seq_No, Result_Value, Report_Date, Technician_Remarks, Document_URL, File_Format)`

**Primary key:** `Order_ID, Result_Seq_No`.

- FK `(Order_ID)` → `LAB_ORDER(Order_ID)`; ON DELETE CASCADE.

## BILLING_INVOICE

`BILLING_INVOICE(Appointment_ID, Invoice_No, Billing_Date, Total_Amount, Payment_Status)`

**Primary key:** `Appointment_ID, Invoice_No`.

- FK `(Appointment_ID)` → `APPOINTMENT(Appointment_ID)`; ON DELETE CASCADE.

## Constraints and routines

- `DOCTOR.Email` is `UNIQUE NOT NULL`, so it is an alternate candidate key. Other names, phone numbers and invoice numbers are not globally unique unless their declared key requires it.
- Check constraints restrict appointment status, consultation mode, laboratory priority and invoice payment status.
- Mandatory fields use `NOT NULL`. Cascading deletes and nullable references follow the FK rules above.
- Six explicit indexes cover selected foreign keys; primary-key and unique constraints also have supporting Oracle indexes.
- `REGISTER_NEW_PATIENT` and `UPDATE_APPOINTMENT_STATUS` are PL/SQL procedures; `CALCULATE_INVOICE_TOTAL` is a function.
- `PREVENT_ALLERGIC_PRESCRIPTION` rejects medicine-class conflicts. `TRG_CREATE_TELEMEDICINE_SESSION` creates a session after a virtual appointment insert.
- One API-generated invoice per appointment is enforced by the API workflow; the table primary key itself is the composite `(Appointment_ID, Invoice_No)`.

See [normalization.md](normalization.md) for functional dependencies and decomposition, and [architecture.md](architecture.md) for the separate Cassandra model.
