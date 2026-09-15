-- ========================================================
-- TELEMEDICINE EHR: DA2 SQL QUERY PORTFOLIO
-- Run after telemedicine_ehr.sql. Each query demonstrates a syllabus concept.
-- ========================================================

-- Q1. Selection and ordering: scheduled or in-progress appointments.
SELECT Appointment_ID, Patient_ID, Doctor_ID, Appointment_Date,
       Appointment_Time, Consultation_Mode, Status
FROM APPOINTMENT
WHERE Status IN ('Scheduled', 'In-Progress')
ORDER BY Appointment_Date, Appointment_Time;

-- Q2. Multi-table join: appointment schedule with patient, doctor and department.
SELECT a.Appointment_ID,
       p.First_Name || ' ' || p.Last_Name AS Patient_Name,
       d.First_Name || ' ' || d.Last_Name AS Doctor_Name,
       dept.Dept_Name,
       a.Appointment_Date,
       a.Consultation_Mode,
       a.Status
FROM APPOINTMENT a
JOIN PATIENT p ON p.Patient_ID = a.Patient_ID
JOIN DOCTOR d ON d.Doctor_ID = a.Doctor_ID
JOIN DEPARTMENT dept ON dept.Dept_ID = d.Dept_ID
ORDER BY a.Appointment_Date, a.Appointment_ID;

-- Q3. Left joins: patients and their insurance, including uninsured patients.
SELECT p.Patient_ID,
       p.First_Name || ' ' || p.Last_Name AS Patient_Name,
       NVL(ip.Provider_Name, 'Uninsured') AS Insurance_Provider,
       ip.Coverage_Limit
FROM PATIENT p
LEFT JOIN INSURANCE_PROVIDER ip ON ip.Policy_No = p.Policy_No
ORDER BY p.Patient_ID;

-- Q4. Aggregation, GROUP BY and HAVING: doctors handling multiple appointments.
SELECT d.Doctor_ID,
       d.First_Name || ' ' || d.Last_Name AS Doctor_Name,
       COUNT(a.Appointment_ID) AS Appointment_Count
FROM DOCTOR d
LEFT JOIN APPOINTMENT a ON a.Doctor_ID = d.Doctor_ID
GROUP BY d.Doctor_ID, d.First_Name, d.Last_Name
HAVING COUNT(a.Appointment_ID) >= 1
ORDER BY Appointment_Count DESC, d.Doctor_ID;

-- Q5. Scalar and correlated subqueries: insured patients with above-average
-- coverage who also have an appointment.
SELECT p.Patient_ID,
       p.First_Name || ' ' || p.Last_Name AS Patient_Name,
       ip.Provider_Name,
       ip.Coverage_Limit
FROM PATIENT p
JOIN INSURANCE_PROVIDER ip ON ip.Policy_No = p.Policy_No
WHERE ip.Coverage_Limit > (
          SELECT AVG(Coverage_Limit)
          FROM INSURANCE_PROVIDER
      )
  AND EXISTS (
          SELECT 1
          FROM APPOINTMENT a
          WHERE a.Patient_ID = p.Patient_ID
      )
ORDER BY ip.Coverage_Limit DESC;

-- Q6. Composite-key tables and arithmetic: prescription medicine cost.
SELECT pr.Appointment_ID,
       pr.Prescription_No,
       m.Medicine_Name,
       pi.Dosage,
       pi.Duration_Days,
       pi.Quantity,
       m.Unit_Price,
       pi.Quantity * m.Unit_Price AS Item_Total,
       ph.Pharmacy_Name
FROM PRESCRIPTION pr
JOIN PRESCRIPTION_ITEM pi
  ON pi.Appointment_ID = pr.Appointment_ID
 AND pi.Prescription_No = pr.Prescription_No
JOIN MEDICINE m ON m.Medicine_ID = pi.Medicine_ID
LEFT JOIN PHARMACY ph ON ph.Pharmacy_ID = pr.Pharmacy_ID
ORDER BY pr.Appointment_ID, pr.Prescription_No, pi.Item_Seq_No;

-- Q7. Medical-history report using the multivalued allergy relation.
SELECT p.Patient_ID,
       p.First_Name || ' ' || p.Last_Name AS Patient_Name,
       ml.Log_Seq_No,
       ml.Log_Date,
       ml.Diagnosis,
       NVL(LISTAGG(la.Allergy_Name, ', ')
           WITHIN GROUP (ORDER BY la.Allergy_Name), 'None recorded') AS Allergies
FROM PATIENT p
JOIN MEDICAL_LOG ml ON ml.Patient_ID = p.Patient_ID
LEFT JOIN LOG_ALLERGIES la
  ON la.Patient_ID = ml.Patient_ID
 AND la.Log_Seq_No = ml.Log_Seq_No
GROUP BY p.Patient_ID, p.First_Name, p.Last_Name,
         ml.Log_Seq_No, ml.Log_Date, ml.Diagnosis
ORDER BY p.Patient_ID, ml.Log_Seq_No;

-- Q8. Laboratory report across catalog, order and result tables.
SELECT lo.Order_ID,
       a.Patient_ID,
       ltc.Test_Name,
       ltc.Category,
       lo.Priority,
       tr.Result_Seq_No,
       tr.Result_Value,
       tr.Report_Date,
       tr.Technician_Remarks
FROM LAB_ORDER lo
JOIN APPOINTMENT a ON a.Appointment_ID = lo.Appointment_ID
JOIN LAB_TEST_CATALOG ltc
  ON ltc.Test_Catalog_ID = lo.Test_Catalog_ID
LEFT JOIN TEST_RESULT tr ON tr.Order_ID = lo.Order_ID
ORDER BY lo.Order_Date, lo.Order_ID, tr.Result_Seq_No;

-- Q9. Date/timestamp calculation: completed telemedicine-session durations.
SELECT ts.Appointment_ID,
       ts.Session_ID,
       ts.Network_Quality_Log,
       ROUND((CAST(ts.End_Time AS DATE) - CAST(ts.Start_Time AS DATE)) * 1440, 2)
           AS Duration_Minutes,
       ts.Chat_Transcript_URL
FROM TELEMEDICINE_SESSION ts
WHERE ts.End_Time IS NOT NULL
ORDER BY ts.Start_Time;

-- Q10. PL/SQL function use and reconciliation against stored invoices.
SELECT bi.Invoice_No,
       bi.Appointment_ID,
       bi.Total_Amount AS Stored_Total,
       Calculate_Invoice_Total(bi.Appointment_ID) AS Calculated_Total,
       bi.Total_Amount - Calculate_Invoice_Total(bi.Appointment_ID) AS Variance,
       bi.Payment_Status
FROM BILLING_INVOICE bi
ORDER BY bi.Invoice_No;

-- Q11. Set operation: contact directory from patient phones and doctors.
SELECT 'Patient' AS Contact_Type,
       p.Patient_ID AS Person_ID,
       p.First_Name || ' ' || p.Last_Name AS Person_Name,
       pp.Phone_Number
FROM PATIENT p
JOIN PATIENT_PHONE pp ON pp.Patient_ID = p.Patient_ID
UNION ALL
SELECT 'Doctor',
       d.Doctor_ID,
       d.First_Name || ' ' || d.Last_Name,
       d.Primary_Phone
FROM DOCTOR d
ORDER BY Contact_Type, Person_ID;

-- Q12. Relational division style query: doctors with multiple qualifications.
SELECT d.Doctor_ID,
       d.First_Name || ' ' || d.Last_Name AS Doctor_Name,
       LISTAGG(dq.Qualification, ', ')
           WITHIN GROUP (ORDER BY dq.Qualification) AS Qualifications
FROM DOCTOR d
JOIN DOCTOR_QUALIFICATION dq ON dq.Doctor_ID = d.Doctor_ID
GROUP BY d.Doctor_ID, d.First_Name, d.Last_Name
HAVING COUNT(*) > 1
ORDER BY d.Doctor_ID;

-- Q13. Allergy-safety audit: must return zero rows for valid stored data.
SELECT a.Appointment_ID,
       a.Patient_ID,
       m.Medicine_Name,
       m.Allergen_Class,
       la.Allergy_Name
FROM PRESCRIPTION_ITEM pi
JOIN APPOINTMENT a ON a.Appointment_ID = pi.Appointment_ID
JOIN MEDICINE m ON m.Medicine_ID = pi.Medicine_ID
JOIN LOG_ALLERGIES la
  ON la.Patient_ID = a.Patient_ID
 AND UPPER(TRIM(la.Allergy_Name)) = UPPER(TRIM(m.Allergen_Class));

-- Q14. Completeness audit covering every one of the 18 project tables.
SELECT 'INSURANCE_PROVIDER' AS Table_Name, COUNT(*) AS Row_Count FROM INSURANCE_PROVIDER
UNION ALL SELECT 'DEPARTMENT', COUNT(*) FROM DEPARTMENT
UNION ALL SELECT 'PHARMACY', COUNT(*) FROM PHARMACY
UNION ALL SELECT 'MEDICINE', COUNT(*) FROM MEDICINE
UNION ALL SELECT 'LAB_TEST_CATALOG', COUNT(*) FROM LAB_TEST_CATALOG
UNION ALL SELECT 'PATIENT', COUNT(*) FROM PATIENT
UNION ALL SELECT 'DOCTOR', COUNT(*) FROM DOCTOR
UNION ALL SELECT 'PATIENT_PHONE', COUNT(*) FROM PATIENT_PHONE
UNION ALL SELECT 'DOCTOR_QUALIFICATION', COUNT(*) FROM DOCTOR_QUALIFICATION
UNION ALL SELECT 'MEDICAL_LOG', COUNT(*) FROM MEDICAL_LOG
UNION ALL SELECT 'LOG_ALLERGIES', COUNT(*) FROM LOG_ALLERGIES
UNION ALL SELECT 'APPOINTMENT', COUNT(*) FROM APPOINTMENT
UNION ALL SELECT 'TELEMEDICINE_SESSION', COUNT(*) FROM TELEMEDICINE_SESSION
UNION ALL SELECT 'PRESCRIPTION', COUNT(*) FROM PRESCRIPTION
UNION ALL SELECT 'PRESCRIPTION_ITEM', COUNT(*) FROM PRESCRIPTION_ITEM
UNION ALL SELECT 'LAB_ORDER', COUNT(*) FROM LAB_ORDER
UNION ALL SELECT 'TEST_RESULT', COUNT(*) FROM TEST_RESULT
UNION ALL SELECT 'BILLING_INVOICE', COUNT(*) FROM BILLING_INVOICE
ORDER BY Table_Name;
