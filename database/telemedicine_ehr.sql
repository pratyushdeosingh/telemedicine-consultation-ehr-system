-- ========================================================
-- 1. DROP TABLES & SEQUENCES (CLEANUP BEFORE CREATION)
-- ========================================================
DROP TABLE BILLING_INVOICE CASCADE CONSTRAINTS;
DROP TABLE TEST_RESULT CASCADE CONSTRAINTS;
DROP TABLE LAB_ORDER CASCADE CONSTRAINTS;
DROP TABLE PRESCRIPTION_ITEM CASCADE CONSTRAINTS;
DROP TABLE PRESCRIPTION CASCADE CONSTRAINTS;
DROP TABLE TELEMEDICINE_SESSION CASCADE CONSTRAINTS;
DROP TABLE APPOINTMENT CASCADE CONSTRAINTS;
DROP TABLE LOG_ALLERGIES CASCADE CONSTRAINTS;
DROP TABLE MEDICAL_LOG CASCADE CONSTRAINTS;
DROP TABLE DOCTOR_QUALIFICATION CASCADE CONSTRAINTS;
DROP TABLE PATIENT_PHONE CASCADE CONSTRAINTS;
DROP TABLE DOCTOR CASCADE CONSTRAINTS;
DROP TABLE PATIENT CASCADE CONSTRAINTS;
DROP TABLE LAB_TEST_CATALOG CASCADE CONSTRAINTS;
DROP TABLE MEDICINE CASCADE CONSTRAINTS;
DROP TABLE PHARMACY CASCADE CONSTRAINTS;
DROP TABLE DEPARTMENT CASCADE CONSTRAINTS;
DROP TABLE INSURANCE_PROVIDER CASCADE CONSTRAINTS;

BEGIN
   EXECUTE IMMEDIATE 'DROP SEQUENCE seq_patient_id';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/
BEGIN
   EXECUTE IMMEDIATE 'DROP SEQUENCE seq_appointment_id';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/
BEGIN
   EXECUTE IMMEDIATE 'DROP SEQUENCE seq_invoice_id';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/

-- ========================================================
-- 2. CREATE TABLE DEFINITIONS (DDL WITH REALISTIC VARCHAR LIMITS)
-- ========================================================
CREATE TABLE INSURANCE_PROVIDER (
    Policy_No VARCHAR2(20),
    Provider_Name VARCHAR2(70) NOT NULL,
    Coverage_Limit NUMBER(10, 2) NOT NULL,
    CONSTRAINT pk_insurance_provider PRIMARY KEY (Policy_No)
);

CREATE TABLE DEPARTMENT (
    Dept_ID VARCHAR2(10),
    Dept_Name VARCHAR2(50) NOT NULL,
    Location_Block VARCHAR2(20) NOT NULL,
    CONSTRAINT pk_department PRIMARY KEY (Dept_ID)
);

CREATE TABLE PHARMACY (
    Pharmacy_ID VARCHAR2(10),
    Pharmacy_Name VARCHAR2(70) NOT NULL,
    Location VARCHAR2(100) NOT NULL,
    Contact_Number VARCHAR2(15) NOT NULL,
    CONSTRAINT pk_pharmacy PRIMARY KEY (Pharmacy_ID)
);

CREATE TABLE MEDICINE (
    Medicine_ID VARCHAR2(10),
    Medicine_Name VARCHAR2(70) NOT NULL,
    Manufacturer VARCHAR2(70) NOT NULL,
    Dosage_Form VARCHAR2(30) NOT NULL,
    Allergen_Class VARCHAR2(50),
    Unit_Price NUMBER(8, 2) NOT NULL,
    CONSTRAINT pk_medicine PRIMARY KEY (Medicine_ID)
);

CREATE TABLE LAB_TEST_CATALOG (
    Test_Catalog_ID VARCHAR2(10),
    Test_Name VARCHAR2(70) NOT NULL,
    Category VARCHAR2(30) NOT NULL,
    Standard_Cost NUMBER(8, 2) NOT NULL,
    CONSTRAINT pk_lab_test_catalog PRIMARY KEY (Test_Catalog_ID)
);

CREATE TABLE PATIENT (
    Patient_ID VARCHAR2(12),
    Policy_No VARCHAR2(20),
    First_Name VARCHAR2(35) NOT NULL,
    Last_Name VARCHAR2(35) NOT NULL,
    Street VARCHAR2(80),
    City VARCHAR2(35),
    State VARCHAR2(35),
    Zip_Code VARCHAR2(10),
    DOB DATE NOT NULL,
    Gender VARCHAR2(10),
    Emergency_Contact VARCHAR2(15),
    CONSTRAINT pk_patient PRIMARY KEY (Patient_ID),
    CONSTRAINT fk_patient_insurance FOREIGN KEY (Policy_No) REFERENCES INSURANCE_PROVIDER(Policy_No) ON DELETE SET NULL
);

CREATE TABLE DOCTOR (
    Doctor_ID VARCHAR2(10),
    Dept_ID VARCHAR2(10) NOT NULL,
    First_Name VARCHAR2(35) NOT NULL,
    Last_Name VARCHAR2(35) NOT NULL,
    Specialization VARCHAR2(60) NOT NULL,
    Email VARCHAR2(80) UNIQUE NOT NULL,
    Primary_Phone VARCHAR2(15) NOT NULL,
    CONSTRAINT pk_doctor PRIMARY KEY (Doctor_ID),
    CONSTRAINT fk_doctor_dept FOREIGN KEY (Dept_ID) REFERENCES DEPARTMENT(Dept_ID)
);

CREATE TABLE PATIENT_PHONE (
    Patient_ID VARCHAR2(12),
    Phone_Number VARCHAR2(15),
    CONSTRAINT pk_patient_phone PRIMARY KEY (Patient_ID, Phone_Number),
    CONSTRAINT fk_patient_phone FOREIGN KEY (Patient_ID) REFERENCES PATIENT(Patient_ID) ON DELETE CASCADE
);

CREATE TABLE DOCTOR_QUALIFICATION (
    Doctor_ID VARCHAR2(10),
    Qualification VARCHAR2(50),
    CONSTRAINT pk_doctor_qualification PRIMARY KEY (Doctor_ID, Qualification),
    CONSTRAINT fk_doctor_qual FOREIGN KEY (Doctor_ID) REFERENCES DOCTOR(Doctor_ID) ON DELETE CASCADE
);

CREATE TABLE MEDICAL_LOG (
    Patient_ID VARCHAR2(12),
    Log_Seq_No NUMBER(5),
    Log_Date DATE NOT NULL,
    Diagnosis VARCHAR2(150) NOT NULL,
    Attachment_Path VARCHAR2(2048),
    CONSTRAINT pk_medical_log PRIMARY KEY (Patient_ID, Log_Seq_No),
    CONSTRAINT fk_medlog_patient FOREIGN KEY (Patient_ID) REFERENCES PATIENT(Patient_ID) ON DELETE CASCADE
);

CREATE TABLE LOG_ALLERGIES (
    Patient_ID VARCHAR2(12),
    Log_Seq_No NUMBER(5),
    Allergy_Name VARCHAR2(50),
    CONSTRAINT pk_log_allergies PRIMARY KEY (Patient_ID, Log_Seq_No, Allergy_Name),
    CONSTRAINT fk_allergies_medlog FOREIGN KEY (Patient_ID, Log_Seq_No) REFERENCES MEDICAL_LOG(Patient_ID, Log_Seq_No) ON DELETE CASCADE
);

CREATE TABLE APPOINTMENT (
    Appointment_ID VARCHAR2(12),
    Patient_ID VARCHAR2(12) NOT NULL,
    Doctor_ID VARCHAR2(10) NOT NULL,
    Appointment_Date DATE NOT NULL,
    Appointment_Time VARCHAR2(10) NOT NULL,
    Status VARCHAR2(15) CHECK (Status IN ('Scheduled', 'Completed', 'Cancelled', 'In-Progress')),
    Consultation_Mode VARCHAR2(15) CHECK (Consultation_Mode IN ('In-Person', 'Virtual')),
    Meeting_Link VARCHAR2(2048),
    CONSTRAINT pk_appointment PRIMARY KEY (Appointment_ID),
    CONSTRAINT fk_apt_patient FOREIGN KEY (Patient_ID) REFERENCES PATIENT(Patient_ID),
    CONSTRAINT fk_apt_doctor FOREIGN KEY (Doctor_ID) REFERENCES DOCTOR(Doctor_ID)
);

CREATE TABLE TELEMEDICINE_SESSION (
    Appointment_ID VARCHAR2(12),
    Session_ID VARCHAR2(12),
    Start_Time TIMESTAMP,
    End_Time TIMESTAMP,
    Network_Quality_Log VARCHAR2(30),
    Chat_Transcript_URL VARCHAR2(2048),
    CONSTRAINT pk_telemedicine_session PRIMARY KEY (Appointment_ID, Session_ID),
    CONSTRAINT fk_telemed_apt FOREIGN KEY (Appointment_ID) REFERENCES APPOINTMENT(Appointment_ID) ON DELETE CASCADE
);

CREATE TABLE PRESCRIPTION (
    Appointment_ID VARCHAR2(12),
    Prescription_No VARCHAR2(15),
    Pharmacy_ID VARCHAR2(10),
    Issue_Date DATE NOT NULL,
    Notes VARCHAR2(200),
    CONSTRAINT pk_prescription PRIMARY KEY (Appointment_ID, Prescription_No),
    CONSTRAINT fk_rx_apt FOREIGN KEY (Appointment_ID) REFERENCES APPOINTMENT(Appointment_ID) ON DELETE CASCADE,
    CONSTRAINT fk_rx_pharmacy FOREIGN KEY (Pharmacy_ID) REFERENCES PHARMACY(Pharmacy_ID) ON DELETE SET NULL
);

CREATE TABLE PRESCRIPTION_ITEM (
    Appointment_ID VARCHAR2(12),
    Prescription_No VARCHAR2(15),
    Item_Seq_No NUMBER(5),
    Medicine_ID VARCHAR2(10) NOT NULL,
    Dosage VARCHAR2(30) NOT NULL,
    Duration_Days NUMBER(3) NOT NULL,
    Quantity NUMBER(5) NOT NULL,
    CONSTRAINT pk_prescription_item PRIMARY KEY (Appointment_ID, Prescription_No, Item_Seq_No),
    CONSTRAINT fk_rxitem_prescription FOREIGN KEY (Appointment_ID, Prescription_No) REFERENCES PRESCRIPTION(Appointment_ID, Prescription_No) ON DELETE CASCADE,
    CONSTRAINT fk_rxitem_medicine FOREIGN KEY (Medicine_ID) REFERENCES MEDICINE(Medicine_ID)
);

CREATE TABLE LAB_ORDER (
    Order_ID VARCHAR2(12),
    Appointment_ID VARCHAR2(12) NOT NULL,
    Test_Catalog_ID VARCHAR2(10) NOT NULL,
    Order_Date DATE NOT NULL,
    Priority VARCHAR2(10) CHECK (Priority IN ('Routine', 'Urgent', 'Stat')),
    CONSTRAINT pk_lab_order PRIMARY KEY (Order_ID),
    CONSTRAINT fk_laborder_apt FOREIGN KEY (Appointment_ID) REFERENCES APPOINTMENT(Appointment_ID),
    CONSTRAINT fk_laborder_catalog FOREIGN KEY (Test_Catalog_ID) REFERENCES LAB_TEST_CATALOG(Test_Catalog_ID)
);

CREATE TABLE TEST_RESULT (
    Order_ID VARCHAR2(12),
    Result_Seq_No NUMBER(5),
    Result_Value VARCHAR2(100) NOT NULL,
    Report_Date DATE NOT NULL,
    Technician_Remarks VARCHAR2(200),
    Document_URL VARCHAR2(2048),
    File_Format VARCHAR2(10),
    CONSTRAINT pk_test_result PRIMARY KEY (Order_ID, Result_Seq_No),
    CONSTRAINT fk_result_laborder FOREIGN KEY (Order_ID) REFERENCES LAB_ORDER(Order_ID) ON DELETE CASCADE
);

CREATE TABLE BILLING_INVOICE (
    Appointment_ID VARCHAR2(12),
    Invoice_No VARCHAR2(15),
    Billing_Date DATE NOT NULL,
    Total_Amount NUMBER(10, 2) DEFAULT 0.00,
    Payment_Status VARCHAR2(15) CHECK (Payment_Status IN ('Pending', 'Paid', 'Refunded')),
    CONSTRAINT pk_billing_invoice PRIMARY KEY (Appointment_ID, Invoice_No),
    CONSTRAINT fk_bill_apt FOREIGN KEY (Appointment_ID) REFERENCES APPOINTMENT(Appointment_ID) ON DELETE CASCADE
);

-- ========================================================
-- 3. INDEXES ON FOREIGN KEYS
-- ========================================================
CREATE INDEX idx_patient_policy ON PATIENT(Policy_No);
CREATE INDEX idx_doctor_dept ON DOCTOR(Dept_ID);
CREATE INDEX idx_apt_patient ON APPOINTMENT(Patient_ID);
CREATE INDEX idx_apt_doctor ON APPOINTMENT(Doctor_ID);
CREATE INDEX idx_rx_pharmacy ON PRESCRIPTION(Pharmacy_ID);
CREATE INDEX idx_laborder_catalog ON LAB_ORDER(Test_Catalog_ID);

-- ========================================================
-- 4. INSERT DATA (DML)
-- ========================================================
INSERT INTO INSURANCE_PROVIDER VALUES ('POL-1001', 'CareHealth Insurance', 500000.00);
INSERT INTO INSURANCE_PROVIDER VALUES ('POL-1002', 'Star Health Security', 300000.00);
INSERT INTO INSURANCE_PROVIDER VALUES ('POL-1003', 'HDFC ERGO Health', 750000.00);
INSERT INTO INSURANCE_PROVIDER VALUES ('POL-1004', 'Niva Bupa Health', 400000.00);
INSERT INTO INSURANCE_PROVIDER VALUES ('POL-1005', 'ICICI Lombard Care', 600000.00);
INSERT INTO INSURANCE_PROVIDER VALUES ('POL-1006', 'Bajaj Allianz Medical', 500000.00);
INSERT INTO INSURANCE_PROVIDER VALUES ('POL-1007', 'Aditya Birla Health', 1000000.00);
INSERT INTO INSURANCE_PROVIDER VALUES ('POL-1008', 'SBI General Care', 350000.00);

INSERT INTO DEPARTMENT VALUES ('DEP-01', 'Cardiology', 'Block-A');
INSERT INTO DEPARTMENT VALUES ('DEP-02', 'Neurology', 'Block-B');
INSERT INTO DEPARTMENT VALUES ('DEP-03', 'Orthopedics', 'Block-C');
INSERT INTO DEPARTMENT VALUES ('DEP-04', 'General Medicine', 'Block-A');
INSERT INTO DEPARTMENT VALUES ('DEP-05', 'Dermatology', 'Block-D');
INSERT INTO DEPARTMENT VALUES ('DEP-06', 'Pediatrics', 'Block-E');
INSERT INTO DEPARTMENT VALUES ('DEP-07', 'Gastroenterology', 'Block-B');
INSERT INTO DEPARTMENT VALUES ('DEP-08', 'Pulmonology', 'Block-C');

INSERT INTO PHARMACY VALUES ('PHARM-01', 'Apollo Pharmacy', 'Chennai Central', '9876543210');
INSERT INTO PHARMACY VALUES ('PHARM-02', 'MedPlus Chemist', 'Velachery Main Rd', '9876543211');
INSERT INTO PHARMACY VALUES ('PHARM-03', 'Fortis Meds Store', 'Adyar Signal', '9876543212');
INSERT INTO PHARMACY VALUES ('PHARM-04', 'Wellness Forever', 'T-Nagar Market', '9876543213');
INSERT INTO PHARMACY VALUES ('PHARM-05', 'Netmeds Offline', 'OMR Kandanchavadi', '9876543214');
INSERT INTO PHARMACY VALUES ('PHARM-06', 'Frank Ross Pharmacy', 'Mylapore', '9876543215');
INSERT INTO PHARMACY VALUES ('PHARM-07', 'Sanjivani Medicos', 'Tambaram West', '9876543216');
INSERT INTO PHARMACY VALUES ('PHARM-08', 'HealthKart Pharmacy', 'Anna Nagar', '9876543217');

INSERT INTO MEDICINE VALUES ('MED-01', 'Amoxicillin', 'Cipla', 'Capsule 500mg', 'Penicillin', 15.50);
INSERT INTO MEDICINE VALUES ('MED-02', 'Paracetamol', 'Sun Pharma', 'Tablet 650mg', NULL, 5.00);
INSERT INTO MEDICINE VALUES ('MED-03', 'Atorvastatin', 'Dr. Reddys Lab', 'Tablet 10mg', NULL, 22.00);
INSERT INTO MEDICINE VALUES ('MED-04', 'Metformin', 'Zydus Healthcare', 'Tablet 500mg', NULL, 12.00);
INSERT INTO MEDICINE VALUES ('MED-05', 'Cetirizine', 'Mankind Pharma', 'Tablet 10mg', NULL, 6.50);
INSERT INTO MEDICINE VALUES ('MED-06', 'Azithromycin', 'Lupin Pharma', 'Tablet 500mg', NULL, 35.00);
INSERT INTO MEDICINE VALUES ('MED-07', 'Pantoprazole', 'Alkem Labs', 'Tablet 40mg', NULL, 18.00);
INSERT INTO MEDICINE VALUES ('MED-08', 'Ibuprofen', 'Abbott India', 'Tablet 400mg', 'NSAID', 8.50);
INSERT INTO MEDICINE VALUES ('MED-09', 'Salbutamol Inhaler', 'Cipla', 'Metered Dose Inhaler', NULL, 400.00);

INSERT INTO LAB_TEST_CATALOG VALUES ('LAB-01', 'Lipid Profile', 'Blood Test', 850.00);
INSERT INTO LAB_TEST_CATALOG VALUES ('LAB-02', 'Complete Blood Count', 'Hematology', 450.00);
INSERT INTO LAB_TEST_CATALOG VALUES ('LAB-03', 'MRI Brain Scan', 'Radiology', 4500.00);
INSERT INTO LAB_TEST_CATALOG VALUES ('LAB-04', 'HbA1c Diabetes Profile', 'Biochemistry', 600.00);
INSERT INTO LAB_TEST_CATALOG VALUES ('LAB-05', 'Thyroid Profile (T3 T4 TSH)', 'Endocrinology', 750.00);
INSERT INTO LAB_TEST_CATALOG VALUES ('LAB-06', 'Liver Function Test', 'Biochemistry', 900.00);
INSERT INTO LAB_TEST_CATALOG VALUES ('LAB-07', 'X-Ray Chest PA View', 'Radiology', 500.00);
INSERT INTO LAB_TEST_CATALOG VALUES ('LAB-08', 'Kidney Function Test', 'Biochemistry', 950.00);

INSERT INTO PATIENT VALUES ('PAT-01', 'POL-1001', 'Raman', 'Nathan', '123 OMR Road', 'Chennai', 'TN', '600001', TO_DATE('1990-05-14', 'YYYY-MM-DD'), 'Male', '9840112233');
INSERT INTO PATIENT VALUES ('PAT-02', 'POL-1002', 'Kavitha', 'Subramanian', '45 Park Street', 'Chennai', 'TN', '600020', TO_DATE('1985-11-20', 'YYYY-MM-DD'), 'Female', '9840223344');
INSERT INTO PATIENT VALUES ('PAT-03', 'POL-1003', 'Arun', 'Prakash', '89 Mount Road', 'Chennai', 'TN', '600002', TO_DATE('1995-02-10', 'YYYY-MM-DD'), 'Male', '9840334455');
INSERT INTO PATIENT VALUES ('PAT-04', NULL, 'Deepa', 'Balaji', '12 Lake Lane', 'Madurai', 'TN', '625001', TO_DATE('1998-08-25', 'YYYY-MM-DD'), 'Female', '9840445566');
INSERT INTO PATIENT VALUES ('PAT-05', 'POL-1004', 'Karthik', 'Raja', '77 GST Road', 'Tambaram', 'TN', '600045', TO_DATE('1978-12-05', 'YYYY-MM-DD'), 'Male', '9840556677');
INSERT INTO PATIENT VALUES ('PAT-06', 'POL-1005', 'Sangeetha', 'Mani', '14 North Street', 'Coimbatore', 'TN', '641001', TO_DATE('2000-03-30', 'YYYY-MM-DD'), 'Female', '9840667788');
INSERT INTO PATIENT VALUES ('PAT-07', NULL, 'Venkatesh', 'Ramanujam', '90 South Avenue', 'Trichy', 'TN', '620001', TO_DATE('1965-07-18', 'YYYY-MM-DD'), 'Male', '9840778899');
INSERT INTO PATIENT VALUES ('PAT-08', 'POL-1006', 'Ananya', 'Vasudevan', '33 Beach Road', 'Chennai', 'TN', '600041', TO_DATE('2002-09-12', 'YYYY-MM-DD'), 'Female', '9840889900');

INSERT INTO DOCTOR VALUES ('DOC-01', 'DEP-01', 'Sundaram', 'Krishnan', 'Cardiologist', 'sundaram.k@hospital.com', '9444011111');
INSERT INTO DOCTOR VALUES ('DOC-02', 'DEP-02', 'Meenakshi', 'Sundaram', 'Neurologist', 'meenakshi.s@hospital.com', '9444022222');
INSERT INTO DOCTOR VALUES ('DOC-03', 'DEP-03', 'Vikram', 'Ramanathan', 'Orthopedic Surgeon', 'vikram.r@hospital.com', '9444033333');
INSERT INTO DOCTOR VALUES ('DOC-04', 'DEP-04', 'Rajesh', 'Venkataraman', 'General Physician', 'rajesh.v@hospital.com', '9444044444');
INSERT INTO DOCTOR VALUES ('DOC-05', 'DEP-05', 'Priya', 'Dharshini', 'Dermatologist', 'priya.d@hospital.com', '9444055555');
INSERT INTO DOCTOR VALUES ('DOC-06', 'DEP-06', 'Anand', 'Gopalan', 'Pediatrician', 'anand.g@hospital.com', '9444066666');
INSERT INTO DOCTOR VALUES ('DOC-07', 'DEP-07', 'Kalyan', 'Sundaram', 'Gastroenterologist', 'kalyan.s@hospital.com', '9444077777');
INSERT INTO DOCTOR VALUES ('DOC-08', 'DEP-08', 'Shalini', 'Narayanan', 'Pulmonologist', 'shalini.n@hospital.com', '9444088888');

INSERT INTO PATIENT_PHONE VALUES ('PAT-01', '9840112233');
INSERT INTO PATIENT_PHONE VALUES ('PAT-01', '04424350011');
INSERT INTO PATIENT_PHONE VALUES ('PAT-02', '9840223344');
INSERT INTO PATIENT_PHONE VALUES ('PAT-03', '9840334455');
INSERT INTO PATIENT_PHONE VALUES ('PAT-04', '9840445566');
INSERT INTO PATIENT_PHONE VALUES ('PAT-05', '9840556677');
INSERT INTO PATIENT_PHONE VALUES ('PAT-06', '9840667788');
INSERT INTO PATIENT_PHONE VALUES ('PAT-07', '9840778899');

INSERT INTO DOCTOR_QUALIFICATION VALUES ('DOC-01', 'MBBS');
INSERT INTO DOCTOR_QUALIFICATION VALUES ('DOC-01', 'MD Cardiology');
INSERT INTO DOCTOR_QUALIFICATION VALUES ('DOC-02', 'MBBS');
INSERT INTO DOCTOR_QUALIFICATION VALUES ('DOC-02', 'DM Neurology');
INSERT INTO DOCTOR_QUALIFICATION VALUES ('DOC-03', 'MS Orthopedics');
INSERT INTO DOCTOR_QUALIFICATION VALUES ('DOC-04', 'MBBS');
INSERT INTO DOCTOR_QUALIFICATION VALUES ('DOC-05', 'MD Dermatology');
INSERT INTO DOCTOR_QUALIFICATION VALUES ('DOC-06', 'MD Pediatrics');

INSERT INTO MEDICAL_LOG VALUES ('PAT-01', 1, TO_DATE('2026-08-01', 'YYYY-MM-DD'), 'Essential Hypertension', '/logs/pat1_log1.pdf');
INSERT INTO MEDICAL_LOG VALUES ('PAT-01', 2, TO_DATE('2026-08-20', 'YYYY-MM-DD'), 'Hyperlipidemia Check', '/logs/pat1_log2.pdf');
INSERT INTO MEDICAL_LOG VALUES ('PAT-02', 1, TO_DATE('2026-08-15', 'YYYY-MM-DD'), 'Chronic Migraine', '/logs/pat2_log1.pdf');
INSERT INTO MEDICAL_LOG VALUES ('PAT-03', 1, TO_DATE('2026-08-18', 'YYYY-MM-DD'), 'Right Knee Ligament Tear', '/logs/pat3_log1.pdf');
INSERT INTO MEDICAL_LOG VALUES ('PAT-04', 1, TO_DATE('2026-08-22', 'YYYY-MM-DD'), 'Acute Viral Fever', '/logs/pat4_log1.pdf');
INSERT INTO MEDICAL_LOG VALUES ('PAT-05', 1, TO_DATE('2026-08-25', 'YYYY-MM-DD'), 'Type-2 Diabetes Mellitus', '/logs/pat5_log1.pdf');
INSERT INTO MEDICAL_LOG VALUES ('PAT-06', 1, TO_DATE('2026-08-28', 'YYYY-MM-DD'), 'Allergic Dermatitis', '/logs/pat6_log1.pdf');
INSERT INTO MEDICAL_LOG VALUES ('PAT-07', 1, TO_DATE('2026-09-01', 'YYYY-MM-DD'), 'Acid Reflux Disease', '/logs/pat7_log1.pdf');

INSERT INTO LOG_ALLERGIES VALUES ('PAT-01', 1, 'Penicillin');
INSERT INTO LOG_ALLERGIES VALUES ('PAT-01', 2, 'Peanuts');
INSERT INTO LOG_ALLERGIES VALUES ('PAT-02', 1, 'Dust Mites');
INSERT INTO LOG_ALLERGIES VALUES ('PAT-04', 1, 'Sulfa Drugs');
INSERT INTO LOG_ALLERGIES VALUES ('PAT-05', 1, 'Lactose');
INSERT INTO LOG_ALLERGIES VALUES ('PAT-06', 1, 'Latex');
INSERT INTO LOG_ALLERGIES VALUES ('PAT-06', 1, 'Pollen');
INSERT INTO LOG_ALLERGIES VALUES ('PAT-07', 1, 'Shellfish');

INSERT INTO APPOINTMENT VALUES ('APT-01', 'PAT-01', 'DOC-01', TO_DATE('2026-09-10', 'YYYY-MM-DD'), '10:00 AM', 'Completed', 'Virtual', 'https://telemed.hospital.com/room/apt01');
INSERT INTO APPOINTMENT VALUES ('APT-02', 'PAT-02', 'DOC-02', TO_DATE('2026-09-12', 'YYYY-MM-DD'), '11:30 AM', 'Scheduled', 'Virtual', 'https://telemed.hospital.com/room/apt02');
INSERT INTO APPOINTMENT VALUES ('APT-03', 'PAT-03', 'DOC-03', TO_DATE('2026-09-15', 'YYYY-MM-DD'), '02:00 PM', 'Scheduled', 'In-Person', NULL);
INSERT INTO APPOINTMENT VALUES ('APT-04', 'PAT-04', 'DOC-04', TO_DATE('2026-09-10', 'YYYY-MM-DD'), '09:00 AM', 'Completed', 'In-Person', NULL);
INSERT INTO APPOINTMENT VALUES ('APT-05', 'PAT-05', 'DOC-04', TO_DATE('2026-09-11', 'YYYY-MM-DD'), '04:00 PM', 'Scheduled', 'Virtual', 'https://telemed.hospital.com/room/apt05');
INSERT INTO APPOINTMENT VALUES ('APT-06', 'PAT-06', 'DOC-05', TO_DATE('2026-09-13', 'YYYY-MM-DD'), '03:00 PM', 'Scheduled', 'Virtual', 'https://telemed.hospital.com/room/apt06');
INSERT INTO APPOINTMENT VALUES ('APT-07', 'PAT-07', 'DOC-07', TO_DATE('2026-09-14', 'YYYY-MM-DD'), '10:30 AM', 'Scheduled', 'In-Person', NULL);
INSERT INTO APPOINTMENT VALUES ('APT-08', 'PAT-08', 'DOC-08', TO_DATE('2026-09-16', 'YYYY-MM-DD'), '11:00 AM', 'Scheduled', 'Virtual', 'https://telemed.hospital.com/room/apt08');

INSERT INTO TELEMEDICINE_SESSION VALUES ('APT-01', 'SES-01', TIMESTAMP '2026-09-10 10:00:00', TIMESTAMP '2026-09-10 10:25:00', 'Good', '/chats/ses01.txt');
INSERT INTO TELEMEDICINE_SESSION VALUES ('APT-02', 'SES-02', TIMESTAMP '2026-09-12 11:30:00', NULL, 'Pending', NULL);
INSERT INTO TELEMEDICINE_SESSION VALUES ('APT-05', 'SES-03', TIMESTAMP '2026-09-11 16:00:00', NULL, 'Pending', NULL);
INSERT INTO TELEMEDICINE_SESSION VALUES ('APT-06', 'SES-04', TIMESTAMP '2026-09-13 15:00:00', NULL, 'Pending', NULL);
INSERT INTO TELEMEDICINE_SESSION VALUES ('APT-08', 'SES-05', TIMESTAMP '2026-09-16 11:00:00', NULL, 'Pending', NULL);
INSERT INTO TELEMEDICINE_SESSION VALUES ('APT-01', 'SES-06', TIMESTAMP '2026-09-10 10:26:00', TIMESTAMP '2026-09-10 10:30:00', 'Reconnected', '/chats/ses01_re.txt');
INSERT INTO TELEMEDICINE_SESSION VALUES ('APT-02', 'SES-07', TIMESTAMP '2026-09-12 11:31:00', NULL, 'Poor Network', NULL);
INSERT INTO TELEMEDICINE_SESSION VALUES ('APT-05', 'SES-08', TIMESTAMP '2026-09-11 16:05:00', NULL, 'Pending', NULL);

INSERT INTO PRESCRIPTION VALUES ('APT-01', 'RX-01', 'PHARM-01', TO_DATE('2026-09-10', 'YYYY-MM-DD'), 'Take after meals');
INSERT INTO PRESCRIPTION VALUES ('APT-02', 'RX-02', 'PHARM-02', TO_DATE('2026-09-12', 'YYYY-MM-DD'), 'Take before bedtime');
INSERT INTO PRESCRIPTION VALUES ('APT-04', 'RX-03', 'PHARM-03', TO_DATE('2026-09-10', 'YYYY-MM-DD'), 'Complete full 5-day course');
INSERT INTO PRESCRIPTION VALUES ('APT-05', 'RX-04', 'PHARM-04', TO_DATE('2026-09-11', 'YYYY-MM-DD'), 'Monitor blood sugar daily');
INSERT INTO PRESCRIPTION VALUES ('APT-06', 'RX-05', 'PHARM-05', TO_DATE('2026-09-13', 'YYYY-MM-DD'), 'Apply ointment externally');
INSERT INTO PRESCRIPTION VALUES ('APT-07', 'RX-06', 'PHARM-06', TO_DATE('2026-09-14', 'YYYY-MM-DD'), 'Avoid oily food');
INSERT INTO PRESCRIPTION VALUES ('APT-08', 'RX-07', 'PHARM-07', TO_DATE('2026-09-16', 'YYYY-MM-DD'), 'Inhale twice daily');
INSERT INTO PRESCRIPTION VALUES ('APT-03', 'RX-08', 'PHARM-08', TO_DATE('2026-09-15', 'YYYY-MM-DD'), 'Take pain relief as needed');

INSERT INTO PRESCRIPTION_ITEM VALUES ('APT-01', 'RX-01', 1, 'MED-02', '650mg As needed', 5, 10);
INSERT INTO PRESCRIPTION_ITEM VALUES ('APT-01', 'RX-01', 2, 'MED-03', '10mg Once Daily', 30, 30);
INSERT INTO PRESCRIPTION_ITEM VALUES ('APT-02', 'RX-02', 1, 'MED-02', '650mg As needed', 3, 6);
INSERT INTO PRESCRIPTION_ITEM VALUES ('APT-04', 'RX-03', 1, 'MED-06', '500mg Once Daily', 5, 5);
INSERT INTO PRESCRIPTION_ITEM VALUES ('APT-05', 'RX-04', 1, 'MED-04', '500mg Twice Daily', 30, 60);
INSERT INTO PRESCRIPTION_ITEM VALUES ('APT-06', 'RX-05', 1, 'MED-05', '10mg Once Daily', 10, 10);
INSERT INTO PRESCRIPTION_ITEM VALUES ('APT-07', 'RX-06', 1, 'MED-07', '40mg Before Food', 15, 15);
INSERT INTO PRESCRIPTION_ITEM VALUES ('APT-03', 'RX-08', 1, 'MED-08', '400mg Post Meal', 5, 10);
INSERT INTO PRESCRIPTION_ITEM VALUES ('APT-08', 'RX-07', 1, 'MED-09', '2 Puffs Twice Daily', 30, 1);

INSERT INTO LAB_ORDER VALUES ('ORD-01', 'APT-01', 'LAB-01', TO_DATE('2026-09-10', 'YYYY-MM-DD'), 'Routine');
INSERT INTO LAB_ORDER VALUES ('ORD-02', 'APT-02', 'LAB-03', TO_DATE('2026-09-12', 'YYYY-MM-DD'), 'Urgent');
INSERT INTO LAB_ORDER VALUES ('ORD-03', 'APT-03', 'LAB-07', TO_DATE('2026-09-15', 'YYYY-MM-DD'), 'Routine');
INSERT INTO LAB_ORDER VALUES ('ORD-04', 'APT-04', 'LAB-02', TO_DATE('2026-09-10', 'YYYY-MM-DD'), 'Stat');
INSERT INTO LAB_ORDER VALUES ('ORD-05', 'APT-05', 'LAB-04', TO_DATE('2026-09-11', 'YYYY-MM-DD'), 'Routine');
INSERT INTO LAB_ORDER VALUES ('ORD-06', 'APT-06', 'LAB-05', TO_DATE('2026-09-13', 'YYYY-MM-DD'), 'Routine');
INSERT INTO LAB_ORDER VALUES ('ORD-07', 'APT-07', 'LAB-06', TO_DATE('2026-09-14', 'YYYY-MM-DD'), 'Urgent');
INSERT INTO LAB_ORDER VALUES ('ORD-08', 'APT-08', 'LAB-08', TO_DATE('2026-09-16', 'YYYY-MM-DD'), 'Routine');

INSERT INTO TEST_RESULT VALUES ('ORD-01', 1, 'Total Cholesterol: 190 mg/dL', TO_DATE('2026-09-11', 'YYYY-MM-DD'), 'Normal range', '/reports/ord01_res1.pdf', 'PDF');
INSERT INTO TEST_RESULT VALUES ('ORD-02', 1, 'Brain MRI: No acute stroke seen', TO_DATE('2026-09-13', 'YYYY-MM-DD'), 'Normal scan', '/reports/ord02_res1.pdf', 'PDF');
INSERT INTO TEST_RESULT VALUES ('ORD-03', 1, 'Right Knee Joint Clear', TO_DATE('2026-09-16', 'YYYY-MM-DD'), 'Minor sprain', '/reports/ord03_res1.pdf', 'PDF');
INSERT INTO TEST_RESULT VALUES ('ORD-04', 1, 'WBC Count: 11,500 cells/mcL', TO_DATE('2026-09-10', 'YYYY-MM-DD'), 'Slightly elevated', '/reports/ord04_res1.pdf', 'PDF');
INSERT INTO TEST_RESULT VALUES ('ORD-05', 1, 'HbA1c: 6.8%', TO_DATE('2026-09-12', 'YYYY-MM-DD'), 'Diabetic range', '/reports/ord05_res1.pdf', 'PDF');
INSERT INTO TEST_RESULT VALUES ('ORD-06', 1, 'TSH: 2.5 mIU/L', TO_DATE('2026-09-14', 'YYYY-MM-DD'), 'Normal Thyroid', '/reports/ord06_res1.pdf', 'PDF');
INSERT INTO TEST_RESULT VALUES ('ORD-07', 1, 'ALT/AST: Normal', TO_DATE('2026-09-15', 'YYYY-MM-DD'), 'Liver healthy', '/reports/ord07_res1.pdf', 'PDF');
INSERT INTO TEST_RESULT VALUES ('ORD-08', 1, 'Serum Creatinine: 0.9 mg/dL', TO_DATE('2026-09-17', 'YYYY-MM-DD'), 'Kidney healthy', '/reports/ord08_res1.pdf', 'PDF');

INSERT INTO BILLING_INVOICE VALUES ('APT-01', 'INV-01', TO_DATE('2026-09-10', 'YYYY-MM-DD'), 1560.00, 'Paid');
INSERT INTO BILLING_INVOICE VALUES ('APT-02', 'INV-02', TO_DATE('2026-09-12', 'YYYY-MM-DD'), 4530.00, 'Pending');
INSERT INTO BILLING_INVOICE VALUES ('APT-03', 'INV-03', TO_DATE('2026-09-15', 'YYYY-MM-DD'), 585.00, 'Pending');
INSERT INTO BILLING_INVOICE VALUES ('APT-04', 'INV-04', TO_DATE('2026-09-10', 'YYYY-MM-DD'), 625.00, 'Paid');
INSERT INTO BILLING_INVOICE VALUES ('APT-05', 'INV-05', TO_DATE('2026-09-11', 'YYYY-MM-DD'), 1320.00, 'Pending');
INSERT INTO BILLING_INVOICE VALUES ('APT-06', 'INV-06', TO_DATE('2026-09-13', 'YYYY-MM-DD'), 815.00, 'Paid');
INSERT INTO BILLING_INVOICE VALUES ('APT-07', 'INV-07', TO_DATE('2026-09-14', 'YYYY-MM-DD'), 1170.00, 'Pending');
INSERT INTO BILLING_INVOICE VALUES ('APT-08', 'INV-08', TO_DATE('2026-09-16', 'YYYY-MM-DD'), 1350.00, 'Pending');

COMMIT;

-- ========================================================
-- 5. AUTO-INCREMENT SEQUENCES
-- ========================================================
CREATE SEQUENCE seq_patient_id START WITH 9 INCREMENT BY 1 NOCACHE;
CREATE SEQUENCE seq_appointment_id START WITH 9 INCREMENT BY 1 NOCACHE;
CREATE SEQUENCE seq_invoice_id START WITH 9 INCREMENT BY 1 NOCACHE;

-- ========================================================
-- 6. PL/SQL BUSINESS OPERATIONS USED BY THE EXPRESS API
-- ========================================================
CREATE OR REPLACE FUNCTION Calculate_Invoice_Total (
    p_appointment_id IN VARCHAR2
) RETURN NUMBER
IS
    v_medicine_total NUMBER(10, 2) := 0;
    v_lab_total NUMBER(10, 2) := 0;
BEGIN
    SELECT NVL(SUM(pi.Quantity * m.Unit_Price), 0)
    INTO v_medicine_total
    FROM PRESCRIPTION_ITEM pi
    JOIN MEDICINE m ON m.Medicine_ID = pi.Medicine_ID
    WHERE pi.Appointment_ID = p_appointment_id;

    SELECT NVL(SUM(lt.Standard_Cost), 0)
    INTO v_lab_total
    FROM LAB_ORDER lo
    JOIN LAB_TEST_CATALOG lt ON lt.Test_Catalog_ID = lo.Test_Catalog_ID
    WHERE lo.Appointment_ID = p_appointment_id;

    RETURN v_medicine_total + v_lab_total;
END;
/

CREATE OR REPLACE PROCEDURE Register_New_Patient (
    p_first_name IN VARCHAR2,
    p_last_name IN VARCHAR2,
    p_street IN VARCHAR2,
    p_city IN VARCHAR2,
    p_state IN VARCHAR2,
    p_zip_code IN VARCHAR2,
    p_dob IN DATE,
    p_gender IN VARCHAR2,
    p_emergency_contact IN VARCHAR2,
    p_policy_no IN VARCHAR2
)
IS
    v_patient_id PATIENT.Patient_ID%TYPE;
BEGIN
    v_patient_id := 'PAT-' || LPAD(seq_patient_id.NEXTVAL, 2, '0');

    INSERT INTO PATIENT (
        Patient_ID, Policy_No, First_Name, Last_Name, Street, City,
        State, Zip_Code, DOB, Gender, Emergency_Contact
    ) VALUES (
        v_patient_id, p_policy_no, p_first_name, p_last_name, p_street, p_city,
        p_state, p_zip_code, p_dob, p_gender, p_emergency_contact
    );
END;
/

CREATE OR REPLACE PROCEDURE Update_Appointment_Status (
    p_appointment_id IN VARCHAR2,
    p_status IN VARCHAR2
)
IS
BEGIN
    UPDATE APPOINTMENT
    SET Status = p_status
    WHERE Appointment_ID = p_appointment_id;

    IF SQL%ROWCOUNT = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Appointment not found');
    END IF;
END;
/

-- Prevent a medicine from being prescribed when its allergen class appears in
-- any medical-log allergy recorded for the appointment's patient.
CREATE OR REPLACE TRIGGER Prevent_Allergic_Prescription
BEFORE INSERT OR UPDATE OF Medicine_ID ON PRESCRIPTION_ITEM
FOR EACH ROW
DECLARE
    v_patient_id PATIENT.Patient_ID%TYPE;
    v_medicine_name MEDICINE.Medicine_Name%TYPE;
    v_allergen_class MEDICINE.Allergen_Class%TYPE;
    v_conflict_count NUMBER;
BEGIN
    SELECT a.Patient_ID
    INTO v_patient_id
    FROM APPOINTMENT a
    WHERE a.Appointment_ID = :NEW.Appointment_ID;

    SELECT m.Medicine_Name, m.Allergen_Class
    INTO v_medicine_name, v_allergen_class
    FROM MEDICINE m
    WHERE m.Medicine_ID = :NEW.Medicine_ID;

    IF v_allergen_class IS NOT NULL THEN
        SELECT COUNT(*)
        INTO v_conflict_count
        FROM LOG_ALLERGIES la
        WHERE la.Patient_ID = v_patient_id
          AND UPPER(TRIM(la.Allergy_Name)) = UPPER(TRIM(v_allergen_class));

        IF v_conflict_count > 0 THEN
            RAISE_APPLICATION_ERROR(
                -20002,
                'Allergy conflict: ' || v_medicine_name ||
                ' belongs to allergen class ' || v_allergen_class ||
                ' for patient ' || v_patient_id
            );
        END IF;
    END IF;
END;
/

-- Create a session in the same transaction as a newly booked virtual appointment.
CREATE OR REPLACE TRIGGER trg_create_telemedicine_session
AFTER INSERT ON APPOINTMENT
FOR EACH ROW
WHEN (NEW.Consultation_Mode = 'Virtual')
BEGIN
    INSERT INTO TELEMEDICINE_SESSION (
        Appointment_ID, Session_ID, Start_Time, End_Time,
        Network_Quality_Log, Chat_Transcript_URL
    ) VALUES (
        :NEW.Appointment_ID,
        'SES-' || SUBSTR(:NEW.Appointment_ID, 5),
        NULL, NULL, 'Session created automatically', NULL
    );
END;
/

-- ========================================================
-- 7. VERIFICATION & RECORD COUNT CHECKS
-- ========================================================
SELECT 'PATIENT' AS Table_Name, COUNT(*) AS Total FROM PATIENT
UNION ALL SELECT 'DOCTOR', COUNT(*) FROM DOCTOR
UNION ALL SELECT 'DEPARTMENT', COUNT(*) FROM DEPARTMENT
UNION ALL SELECT 'APPOINTMENT', COUNT(*) FROM APPOINTMENT
UNION ALL SELECT 'PRESCRIPTION', COUNT(*) FROM PRESCRIPTION
UNION ALL SELECT 'LAB_ORDER', COUNT(*) FROM LAB_ORDER
UNION ALL SELECT 'BILLING_INVOICE', COUNT(*) FROM BILLING_INVOICE;
