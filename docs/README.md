# System and database design

- [Architecture](architecture.md): application/database connections, transactions, timeline refresh and deployment.
- [Relational schema](relational-schema.md): all 18 Oracle relations, primary/foreign keys, constraints and routines.
- [Normalization](normalization.md): initial relation, functional dependencies and decomposition through 3NF.
- [Complete ER source](er-diagram.mmd): implemented columns and key annotations.

## ER diagram

This relationship overview follows the implemented SQL schema. A circle at a parent end indicates a nullable reference in the child; crow's feet indicate multiple child rows. Solid lines identify relationships whose FK columns form part of the child's PK; dashed lines represent other references. Notation follows the [Mermaid ER syntax](https://mermaid.js.org/syntax/entityRelationshipDiagram.html). The complete column/key definitions are in the schema reference above.

```mermaid
erDiagram
    INSURANCE_PROVIDER |o..o{ PATIENT : "Policy_No"
    DEPARTMENT ||..o{ DOCTOR : "Dept_ID"
    PATIENT ||--o{ PATIENT_PHONE : "Patient_ID"
    DOCTOR ||--o{ DOCTOR_QUALIFICATION : "Doctor_ID"
    PATIENT ||--o{ MEDICAL_LOG : "Patient_ID"
    MEDICAL_LOG ||--o{ LOG_ALLERGIES : "Patient_ID, Log_Seq_No"
    PATIENT ||..o{ APPOINTMENT : "Patient_ID"
    DOCTOR ||..o{ APPOINTMENT : "Doctor_ID"
    APPOINTMENT ||--o{ TELEMEDICINE_SESSION : "Appointment_ID"
    APPOINTMENT ||--o{ PRESCRIPTION : "Appointment_ID"
    PHARMACY |o..o{ PRESCRIPTION : "Pharmacy_ID"
    PRESCRIPTION ||--o{ PRESCRIPTION_ITEM : "Appointment_ID, Prescription_No"
    MEDICINE ||..o{ PRESCRIPTION_ITEM : "Medicine_ID"
    APPOINTMENT ||..o{ LAB_ORDER : "Appointment_ID"
    LAB_TEST_CATALOG ||..o{ LAB_ORDER : "Test_Catalog_ID"
    LAB_ORDER ||--o{ TEST_RESULT : "Order_ID"
    APPOINTMENT ||--o{ BILLING_INVOICE : "Appointment_ID"
```

Cassandra's separate patient/month read model and deliberate denormalization are explained in the architecture and normalization documents. Application/database evidence is indexed in [screenshots/](../screenshots/README.md), with expected/actual checks in [tests/](../tests/README.md).
