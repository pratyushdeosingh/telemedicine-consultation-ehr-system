-- Academic expansion: preserve existing rows, add 17 linked synthetic examples per table.
-- Reserved IDs contain -S01 through -S17; repeat execution does not duplicate rows.
-- No DDL, sequence changes, deletes or commits occur before count validation.

-- INSURANCE_PROVIDER: 17 additional synthetic records
MERGE INTO INSURANCE_PROVIDER t
USING (SELECT 'POL-S01' AS Policy_No, 'Synthetic Health Plan 1' AS Provider_Name, 225000 AS Coverage_Limit FROM dual) s
ON (t.Policy_No = s.Policy_No)
WHEN NOT MATCHED THEN INSERT (Policy_No,Provider_Name,Coverage_Limit)
VALUES (s.Policy_No, s.Provider_Name, s.Coverage_Limit);

MERGE INTO INSURANCE_PROVIDER t
USING (SELECT 'POL-S02' AS Policy_No, 'Synthetic Health Plan 2' AS Provider_Name, 250000 AS Coverage_Limit FROM dual) s
ON (t.Policy_No = s.Policy_No)
WHEN NOT MATCHED THEN INSERT (Policy_No,Provider_Name,Coverage_Limit)
VALUES (s.Policy_No, s.Provider_Name, s.Coverage_Limit);

MERGE INTO INSURANCE_PROVIDER t
USING (SELECT 'POL-S03' AS Policy_No, 'Synthetic Health Plan 3' AS Provider_Name, 275000 AS Coverage_Limit FROM dual) s
ON (t.Policy_No = s.Policy_No)
WHEN NOT MATCHED THEN INSERT (Policy_No,Provider_Name,Coverage_Limit)
VALUES (s.Policy_No, s.Provider_Name, s.Coverage_Limit);

MERGE INTO INSURANCE_PROVIDER t
USING (SELECT 'POL-S04' AS Policy_No, 'Synthetic Health Plan 4' AS Provider_Name, 300000 AS Coverage_Limit FROM dual) s
ON (t.Policy_No = s.Policy_No)
WHEN NOT MATCHED THEN INSERT (Policy_No,Provider_Name,Coverage_Limit)
VALUES (s.Policy_No, s.Provider_Name, s.Coverage_Limit);

MERGE INTO INSURANCE_PROVIDER t
USING (SELECT 'POL-S05' AS Policy_No, 'Synthetic Health Plan 5' AS Provider_Name, 325000 AS Coverage_Limit FROM dual) s
ON (t.Policy_No = s.Policy_No)
WHEN NOT MATCHED THEN INSERT (Policy_No,Provider_Name,Coverage_Limit)
VALUES (s.Policy_No, s.Provider_Name, s.Coverage_Limit);

MERGE INTO INSURANCE_PROVIDER t
USING (SELECT 'POL-S06' AS Policy_No, 'Synthetic Health Plan 6' AS Provider_Name, 350000 AS Coverage_Limit FROM dual) s
ON (t.Policy_No = s.Policy_No)
WHEN NOT MATCHED THEN INSERT (Policy_No,Provider_Name,Coverage_Limit)
VALUES (s.Policy_No, s.Provider_Name, s.Coverage_Limit);

MERGE INTO INSURANCE_PROVIDER t
USING (SELECT 'POL-S07' AS Policy_No, 'Synthetic Health Plan 7' AS Provider_Name, 375000 AS Coverage_Limit FROM dual) s
ON (t.Policy_No = s.Policy_No)
WHEN NOT MATCHED THEN INSERT (Policy_No,Provider_Name,Coverage_Limit)
VALUES (s.Policy_No, s.Provider_Name, s.Coverage_Limit);

MERGE INTO INSURANCE_PROVIDER t
USING (SELECT 'POL-S08' AS Policy_No, 'Synthetic Health Plan 8' AS Provider_Name, 400000 AS Coverage_Limit FROM dual) s
ON (t.Policy_No = s.Policy_No)
WHEN NOT MATCHED THEN INSERT (Policy_No,Provider_Name,Coverage_Limit)
VALUES (s.Policy_No, s.Provider_Name, s.Coverage_Limit);

MERGE INTO INSURANCE_PROVIDER t
USING (SELECT 'POL-S09' AS Policy_No, 'Synthetic Health Plan 9' AS Provider_Name, 425000 AS Coverage_Limit FROM dual) s
ON (t.Policy_No = s.Policy_No)
WHEN NOT MATCHED THEN INSERT (Policy_No,Provider_Name,Coverage_Limit)
VALUES (s.Policy_No, s.Provider_Name, s.Coverage_Limit);

MERGE INTO INSURANCE_PROVIDER t
USING (SELECT 'POL-S10' AS Policy_No, 'Synthetic Health Plan 10' AS Provider_Name, 450000 AS Coverage_Limit FROM dual) s
ON (t.Policy_No = s.Policy_No)
WHEN NOT MATCHED THEN INSERT (Policy_No,Provider_Name,Coverage_Limit)
VALUES (s.Policy_No, s.Provider_Name, s.Coverage_Limit);

MERGE INTO INSURANCE_PROVIDER t
USING (SELECT 'POL-S11' AS Policy_No, 'Synthetic Health Plan 11' AS Provider_Name, 475000 AS Coverage_Limit FROM dual) s
ON (t.Policy_No = s.Policy_No)
WHEN NOT MATCHED THEN INSERT (Policy_No,Provider_Name,Coverage_Limit)
VALUES (s.Policy_No, s.Provider_Name, s.Coverage_Limit);

MERGE INTO INSURANCE_PROVIDER t
USING (SELECT 'POL-S12' AS Policy_No, 'Synthetic Health Plan 12' AS Provider_Name, 500000 AS Coverage_Limit FROM dual) s
ON (t.Policy_No = s.Policy_No)
WHEN NOT MATCHED THEN INSERT (Policy_No,Provider_Name,Coverage_Limit)
VALUES (s.Policy_No, s.Provider_Name, s.Coverage_Limit);

MERGE INTO INSURANCE_PROVIDER t
USING (SELECT 'POL-S13' AS Policy_No, 'Synthetic Health Plan 13' AS Provider_Name, 525000 AS Coverage_Limit FROM dual) s
ON (t.Policy_No = s.Policy_No)
WHEN NOT MATCHED THEN INSERT (Policy_No,Provider_Name,Coverage_Limit)
VALUES (s.Policy_No, s.Provider_Name, s.Coverage_Limit);

MERGE INTO INSURANCE_PROVIDER t
USING (SELECT 'POL-S14' AS Policy_No, 'Synthetic Health Plan 14' AS Provider_Name, 550000 AS Coverage_Limit FROM dual) s
ON (t.Policy_No = s.Policy_No)
WHEN NOT MATCHED THEN INSERT (Policy_No,Provider_Name,Coverage_Limit)
VALUES (s.Policy_No, s.Provider_Name, s.Coverage_Limit);

MERGE INTO INSURANCE_PROVIDER t
USING (SELECT 'POL-S15' AS Policy_No, 'Synthetic Health Plan 15' AS Provider_Name, 575000 AS Coverage_Limit FROM dual) s
ON (t.Policy_No = s.Policy_No)
WHEN NOT MATCHED THEN INSERT (Policy_No,Provider_Name,Coverage_Limit)
VALUES (s.Policy_No, s.Provider_Name, s.Coverage_Limit);

MERGE INTO INSURANCE_PROVIDER t
USING (SELECT 'POL-S16' AS Policy_No, 'Synthetic Health Plan 16' AS Provider_Name, 600000 AS Coverage_Limit FROM dual) s
ON (t.Policy_No = s.Policy_No)
WHEN NOT MATCHED THEN INSERT (Policy_No,Provider_Name,Coverage_Limit)
VALUES (s.Policy_No, s.Provider_Name, s.Coverage_Limit);

MERGE INTO INSURANCE_PROVIDER t
USING (SELECT 'POL-S17' AS Policy_No, 'Synthetic Health Plan 17' AS Provider_Name, 625000 AS Coverage_Limit FROM dual) s
ON (t.Policy_No = s.Policy_No)
WHEN NOT MATCHED THEN INSERT (Policy_No,Provider_Name,Coverage_Limit)
VALUES (s.Policy_No, s.Provider_Name, s.Coverage_Limit);

-- DEPARTMENT: 17 additional synthetic records
MERGE INTO DEPARTMENT t
USING (SELECT 'DEP-S01' AS Dept_ID, 'Ophthalmology' AS Dept_Name, 'Block-F' AS Location_Block FROM dual) s
ON (t.Dept_ID = s.Dept_ID)
WHEN NOT MATCHED THEN INSERT (Dept_ID,Dept_Name,Location_Block)
VALUES (s.Dept_ID, s.Dept_Name, s.Location_Block);

MERGE INTO DEPARTMENT t
USING (SELECT 'DEP-S02' AS Dept_ID, 'ENT' AS Dept_Name, 'Block-F' AS Location_Block FROM dual) s
ON (t.Dept_ID = s.Dept_ID)
WHEN NOT MATCHED THEN INSERT (Dept_ID,Dept_Name,Location_Block)
VALUES (s.Dept_ID, s.Dept_Name, s.Location_Block);

MERGE INTO DEPARTMENT t
USING (SELECT 'DEP-S03' AS Dept_ID, 'Urology' AS Dept_Name, 'Block-F' AS Location_Block FROM dual) s
ON (t.Dept_ID = s.Dept_ID)
WHEN NOT MATCHED THEN INSERT (Dept_ID,Dept_Name,Location_Block)
VALUES (s.Dept_ID, s.Dept_Name, s.Location_Block);

MERGE INTO DEPARTMENT t
USING (SELECT 'DEP-S04' AS Dept_ID, 'Nephrology' AS Dept_Name, 'Block-G' AS Location_Block FROM dual) s
ON (t.Dept_ID = s.Dept_ID)
WHEN NOT MATCHED THEN INSERT (Dept_ID,Dept_Name,Location_Block)
VALUES (s.Dept_ID, s.Dept_Name, s.Location_Block);

MERGE INTO DEPARTMENT t
USING (SELECT 'DEP-S05' AS Dept_ID, 'Endocrinology' AS Dept_Name, 'Block-G' AS Location_Block FROM dual) s
ON (t.Dept_ID = s.Dept_ID)
WHEN NOT MATCHED THEN INSERT (Dept_ID,Dept_Name,Location_Block)
VALUES (s.Dept_ID, s.Dept_Name, s.Location_Block);

MERGE INTO DEPARTMENT t
USING (SELECT 'DEP-S06' AS Dept_ID, 'Rheumatology' AS Dept_Name, 'Block-G' AS Location_Block FROM dual) s
ON (t.Dept_ID = s.Dept_ID)
WHEN NOT MATCHED THEN INSERT (Dept_ID,Dept_Name,Location_Block)
VALUES (s.Dept_ID, s.Dept_Name, s.Location_Block);

MERGE INTO DEPARTMENT t
USING (SELECT 'DEP-S07' AS Dept_ID, 'Oncology' AS Dept_Name, 'Block-H' AS Location_Block FROM dual) s
ON (t.Dept_ID = s.Dept_ID)
WHEN NOT MATCHED THEN INSERT (Dept_ID,Dept_Name,Location_Block)
VALUES (s.Dept_ID, s.Dept_Name, s.Location_Block);

MERGE INTO DEPARTMENT t
USING (SELECT 'DEP-S08' AS Dept_ID, 'Psychiatry' AS Dept_Name, 'Block-H' AS Location_Block FROM dual) s
ON (t.Dept_ID = s.Dept_ID)
WHEN NOT MATCHED THEN INSERT (Dept_ID,Dept_Name,Location_Block)
VALUES (s.Dept_ID, s.Dept_Name, s.Location_Block);

MERGE INTO DEPARTMENT t
USING (SELECT 'DEP-S09' AS Dept_ID, 'Obstetrics' AS Dept_Name, 'Block-H' AS Location_Block FROM dual) s
ON (t.Dept_ID = s.Dept_ID)
WHEN NOT MATCHED THEN INSERT (Dept_ID,Dept_Name,Location_Block)
VALUES (s.Dept_ID, s.Dept_Name, s.Location_Block);

MERGE INTO DEPARTMENT t
USING (SELECT 'DEP-S10' AS Dept_ID, 'Gynecology' AS Dept_Name, 'Block-I' AS Location_Block FROM dual) s
ON (t.Dept_ID = s.Dept_ID)
WHEN NOT MATCHED THEN INSERT (Dept_ID,Dept_Name,Location_Block)
VALUES (s.Dept_ID, s.Dept_Name, s.Location_Block);

MERGE INTO DEPARTMENT t
USING (SELECT 'DEP-S11' AS Dept_ID, 'Geriatrics' AS Dept_Name, 'Block-I' AS Location_Block FROM dual) s
ON (t.Dept_ID = s.Dept_ID)
WHEN NOT MATCHED THEN INSERT (Dept_ID,Dept_Name,Location_Block)
VALUES (s.Dept_ID, s.Dept_Name, s.Location_Block);

MERGE INTO DEPARTMENT t
USING (SELECT 'DEP-S12' AS Dept_ID, 'Emergency Medicine' AS Dept_Name, 'Block-I' AS Location_Block FROM dual) s
ON (t.Dept_ID = s.Dept_ID)
WHEN NOT MATCHED THEN INSERT (Dept_ID,Dept_Name,Location_Block)
VALUES (s.Dept_ID, s.Dept_Name, s.Location_Block);

MERGE INTO DEPARTMENT t
USING (SELECT 'DEP-S13' AS Dept_ID, 'Physiotherapy' AS Dept_Name, 'Block-J' AS Location_Block FROM dual) s
ON (t.Dept_ID = s.Dept_ID)
WHEN NOT MATCHED THEN INSERT (Dept_ID,Dept_Name,Location_Block)
VALUES (s.Dept_ID, s.Dept_Name, s.Location_Block);

MERGE INTO DEPARTMENT t
USING (SELECT 'DEP-S14' AS Dept_ID, 'Dentistry' AS Dept_Name, 'Block-J' AS Location_Block FROM dual) s
ON (t.Dept_ID = s.Dept_ID)
WHEN NOT MATCHED THEN INSERT (Dept_ID,Dept_Name,Location_Block)
VALUES (s.Dept_ID, s.Dept_Name, s.Location_Block);

MERGE INTO DEPARTMENT t
USING (SELECT 'DEP-S15' AS Dept_ID, 'Nutrition' AS Dept_Name, 'Block-J' AS Location_Block FROM dual) s
ON (t.Dept_ID = s.Dept_ID)
WHEN NOT MATCHED THEN INSERT (Dept_ID,Dept_Name,Location_Block)
VALUES (s.Dept_ID, s.Dept_Name, s.Location_Block);

MERGE INTO DEPARTMENT t
USING (SELECT 'DEP-S16' AS Dept_ID, 'Infectious Diseases' AS Dept_Name, 'Block-K' AS Location_Block FROM dual) s
ON (t.Dept_ID = s.Dept_ID)
WHEN NOT MATCHED THEN INSERT (Dept_ID,Dept_Name,Location_Block)
VALUES (s.Dept_ID, s.Dept_Name, s.Location_Block);

MERGE INTO DEPARTMENT t
USING (SELECT 'DEP-S17' AS Dept_ID, 'Family Medicine' AS Dept_Name, 'Block-K' AS Location_Block FROM dual) s
ON (t.Dept_ID = s.Dept_ID)
WHEN NOT MATCHED THEN INSERT (Dept_ID,Dept_Name,Location_Block)
VALUES (s.Dept_ID, s.Dept_Name, s.Location_Block);

-- PHARMACY: 17 additional synthetic records
MERGE INTO PHARMACY t
USING (SELECT 'PHARM-S01' AS Pharmacy_ID, 'Demo Community Pharmacy 1' AS Pharmacy_Name, '1 Sample Street, Chennai' AS Location, '9000000001' AS Contact_Number FROM dual) s
ON (t.Pharmacy_ID = s.Pharmacy_ID)
WHEN NOT MATCHED THEN INSERT (Pharmacy_ID,Pharmacy_Name,Location,Contact_Number)
VALUES (s.Pharmacy_ID, s.Pharmacy_Name, s.Location, s.Contact_Number);

MERGE INTO PHARMACY t
USING (SELECT 'PHARM-S02' AS Pharmacy_ID, 'Demo Community Pharmacy 2' AS Pharmacy_Name, '2 Sample Street, Chennai' AS Location, '9000000002' AS Contact_Number FROM dual) s
ON (t.Pharmacy_ID = s.Pharmacy_ID)
WHEN NOT MATCHED THEN INSERT (Pharmacy_ID,Pharmacy_Name,Location,Contact_Number)
VALUES (s.Pharmacy_ID, s.Pharmacy_Name, s.Location, s.Contact_Number);

MERGE INTO PHARMACY t
USING (SELECT 'PHARM-S03' AS Pharmacy_ID, 'Demo Community Pharmacy 3' AS Pharmacy_Name, '3 Sample Street, Chennai' AS Location, '9000000003' AS Contact_Number FROM dual) s
ON (t.Pharmacy_ID = s.Pharmacy_ID)
WHEN NOT MATCHED THEN INSERT (Pharmacy_ID,Pharmacy_Name,Location,Contact_Number)
VALUES (s.Pharmacy_ID, s.Pharmacy_Name, s.Location, s.Contact_Number);

MERGE INTO PHARMACY t
USING (SELECT 'PHARM-S04' AS Pharmacy_ID, 'Demo Community Pharmacy 4' AS Pharmacy_Name, '4 Sample Street, Chennai' AS Location, '9000000004' AS Contact_Number FROM dual) s
ON (t.Pharmacy_ID = s.Pharmacy_ID)
WHEN NOT MATCHED THEN INSERT (Pharmacy_ID,Pharmacy_Name,Location,Contact_Number)
VALUES (s.Pharmacy_ID, s.Pharmacy_Name, s.Location, s.Contact_Number);

MERGE INTO PHARMACY t
USING (SELECT 'PHARM-S05' AS Pharmacy_ID, 'Demo Community Pharmacy 5' AS Pharmacy_Name, '5 Sample Street, Chennai' AS Location, '9000000005' AS Contact_Number FROM dual) s
ON (t.Pharmacy_ID = s.Pharmacy_ID)
WHEN NOT MATCHED THEN INSERT (Pharmacy_ID,Pharmacy_Name,Location,Contact_Number)
VALUES (s.Pharmacy_ID, s.Pharmacy_Name, s.Location, s.Contact_Number);

MERGE INTO PHARMACY t
USING (SELECT 'PHARM-S06' AS Pharmacy_ID, 'Demo Community Pharmacy 6' AS Pharmacy_Name, '6 Sample Street, Chennai' AS Location, '9000000006' AS Contact_Number FROM dual) s
ON (t.Pharmacy_ID = s.Pharmacy_ID)
WHEN NOT MATCHED THEN INSERT (Pharmacy_ID,Pharmacy_Name,Location,Contact_Number)
VALUES (s.Pharmacy_ID, s.Pharmacy_Name, s.Location, s.Contact_Number);

MERGE INTO PHARMACY t
USING (SELECT 'PHARM-S07' AS Pharmacy_ID, 'Demo Community Pharmacy 7' AS Pharmacy_Name, '7 Sample Street, Chennai' AS Location, '9000000007' AS Contact_Number FROM dual) s
ON (t.Pharmacy_ID = s.Pharmacy_ID)
WHEN NOT MATCHED THEN INSERT (Pharmacy_ID,Pharmacy_Name,Location,Contact_Number)
VALUES (s.Pharmacy_ID, s.Pharmacy_Name, s.Location, s.Contact_Number);

MERGE INTO PHARMACY t
USING (SELECT 'PHARM-S08' AS Pharmacy_ID, 'Demo Community Pharmacy 8' AS Pharmacy_Name, '8 Sample Street, Chennai' AS Location, '9000000008' AS Contact_Number FROM dual) s
ON (t.Pharmacy_ID = s.Pharmacy_ID)
WHEN NOT MATCHED THEN INSERT (Pharmacy_ID,Pharmacy_Name,Location,Contact_Number)
VALUES (s.Pharmacy_ID, s.Pharmacy_Name, s.Location, s.Contact_Number);

MERGE INTO PHARMACY t
USING (SELECT 'PHARM-S09' AS Pharmacy_ID, 'Demo Community Pharmacy 9' AS Pharmacy_Name, '9 Sample Street, Chennai' AS Location, '9000000009' AS Contact_Number FROM dual) s
ON (t.Pharmacy_ID = s.Pharmacy_ID)
WHEN NOT MATCHED THEN INSERT (Pharmacy_ID,Pharmacy_Name,Location,Contact_Number)
VALUES (s.Pharmacy_ID, s.Pharmacy_Name, s.Location, s.Contact_Number);

MERGE INTO PHARMACY t
USING (SELECT 'PHARM-S10' AS Pharmacy_ID, 'Demo Community Pharmacy 10' AS Pharmacy_Name, '10 Sample Street, Chennai' AS Location, '9000000010' AS Contact_Number FROM dual) s
ON (t.Pharmacy_ID = s.Pharmacy_ID)
WHEN NOT MATCHED THEN INSERT (Pharmacy_ID,Pharmacy_Name,Location,Contact_Number)
VALUES (s.Pharmacy_ID, s.Pharmacy_Name, s.Location, s.Contact_Number);

MERGE INTO PHARMACY t
USING (SELECT 'PHARM-S11' AS Pharmacy_ID, 'Demo Community Pharmacy 11' AS Pharmacy_Name, '11 Sample Street, Chennai' AS Location, '9000000011' AS Contact_Number FROM dual) s
ON (t.Pharmacy_ID = s.Pharmacy_ID)
WHEN NOT MATCHED THEN INSERT (Pharmacy_ID,Pharmacy_Name,Location,Contact_Number)
VALUES (s.Pharmacy_ID, s.Pharmacy_Name, s.Location, s.Contact_Number);

MERGE INTO PHARMACY t
USING (SELECT 'PHARM-S12' AS Pharmacy_ID, 'Demo Community Pharmacy 12' AS Pharmacy_Name, '12 Sample Street, Chennai' AS Location, '9000000012' AS Contact_Number FROM dual) s
ON (t.Pharmacy_ID = s.Pharmacy_ID)
WHEN NOT MATCHED THEN INSERT (Pharmacy_ID,Pharmacy_Name,Location,Contact_Number)
VALUES (s.Pharmacy_ID, s.Pharmacy_Name, s.Location, s.Contact_Number);

MERGE INTO PHARMACY t
USING (SELECT 'PHARM-S13' AS Pharmacy_ID, 'Demo Community Pharmacy 13' AS Pharmacy_Name, '13 Sample Street, Chennai' AS Location, '9000000013' AS Contact_Number FROM dual) s
ON (t.Pharmacy_ID = s.Pharmacy_ID)
WHEN NOT MATCHED THEN INSERT (Pharmacy_ID,Pharmacy_Name,Location,Contact_Number)
VALUES (s.Pharmacy_ID, s.Pharmacy_Name, s.Location, s.Contact_Number);

MERGE INTO PHARMACY t
USING (SELECT 'PHARM-S14' AS Pharmacy_ID, 'Demo Community Pharmacy 14' AS Pharmacy_Name, '14 Sample Street, Chennai' AS Location, '9000000014' AS Contact_Number FROM dual) s
ON (t.Pharmacy_ID = s.Pharmacy_ID)
WHEN NOT MATCHED THEN INSERT (Pharmacy_ID,Pharmacy_Name,Location,Contact_Number)
VALUES (s.Pharmacy_ID, s.Pharmacy_Name, s.Location, s.Contact_Number);

MERGE INTO PHARMACY t
USING (SELECT 'PHARM-S15' AS Pharmacy_ID, 'Demo Community Pharmacy 15' AS Pharmacy_Name, '15 Sample Street, Chennai' AS Location, '9000000015' AS Contact_Number FROM dual) s
ON (t.Pharmacy_ID = s.Pharmacy_ID)
WHEN NOT MATCHED THEN INSERT (Pharmacy_ID,Pharmacy_Name,Location,Contact_Number)
VALUES (s.Pharmacy_ID, s.Pharmacy_Name, s.Location, s.Contact_Number);

MERGE INTO PHARMACY t
USING (SELECT 'PHARM-S16' AS Pharmacy_ID, 'Demo Community Pharmacy 16' AS Pharmacy_Name, '16 Sample Street, Chennai' AS Location, '9000000016' AS Contact_Number FROM dual) s
ON (t.Pharmacy_ID = s.Pharmacy_ID)
WHEN NOT MATCHED THEN INSERT (Pharmacy_ID,Pharmacy_Name,Location,Contact_Number)
VALUES (s.Pharmacy_ID, s.Pharmacy_Name, s.Location, s.Contact_Number);

MERGE INTO PHARMACY t
USING (SELECT 'PHARM-S17' AS Pharmacy_ID, 'Demo Community Pharmacy 17' AS Pharmacy_Name, '17 Sample Street, Chennai' AS Location, '9000000017' AS Contact_Number FROM dual) s
ON (t.Pharmacy_ID = s.Pharmacy_ID)
WHEN NOT MATCHED THEN INSERT (Pharmacy_ID,Pharmacy_Name,Location,Contact_Number)
VALUES (s.Pharmacy_ID, s.Pharmacy_Name, s.Location, s.Contact_Number);

-- MEDICINE: 17 additional synthetic records
MERGE INTO MEDICINE t
USING (SELECT 'MED-S01' AS Medicine_ID, 'Synthetic Teaching Medicine 1' AS Medicine_Name, 'Academic Demo Labs' AS Manufacturer, 'Demo tablet' AS Dosage_Form, NULL AS Allergen_Class, 11 AS Unit_Price FROM dual) s
ON (t.Medicine_ID = s.Medicine_ID)
WHEN NOT MATCHED THEN INSERT (Medicine_ID,Medicine_Name,Manufacturer,Dosage_Form,Allergen_Class,Unit_Price)
VALUES (s.Medicine_ID, s.Medicine_Name, s.Manufacturer, s.Dosage_Form, s.Allergen_Class, s.Unit_Price);

MERGE INTO MEDICINE t
USING (SELECT 'MED-S02' AS Medicine_ID, 'Synthetic Teaching Medicine 2' AS Medicine_Name, 'Academic Demo Labs' AS Manufacturer, 'Demo tablet' AS Dosage_Form, NULL AS Allergen_Class, 12 AS Unit_Price FROM dual) s
ON (t.Medicine_ID = s.Medicine_ID)
WHEN NOT MATCHED THEN INSERT (Medicine_ID,Medicine_Name,Manufacturer,Dosage_Form,Allergen_Class,Unit_Price)
VALUES (s.Medicine_ID, s.Medicine_Name, s.Manufacturer, s.Dosage_Form, s.Allergen_Class, s.Unit_Price);

MERGE INTO MEDICINE t
USING (SELECT 'MED-S03' AS Medicine_ID, 'Synthetic Teaching Medicine 3' AS Medicine_Name, 'Academic Demo Labs' AS Manufacturer, 'Demo tablet' AS Dosage_Form, NULL AS Allergen_Class, 13 AS Unit_Price FROM dual) s
ON (t.Medicine_ID = s.Medicine_ID)
WHEN NOT MATCHED THEN INSERT (Medicine_ID,Medicine_Name,Manufacturer,Dosage_Form,Allergen_Class,Unit_Price)
VALUES (s.Medicine_ID, s.Medicine_Name, s.Manufacturer, s.Dosage_Form, s.Allergen_Class, s.Unit_Price);

MERGE INTO MEDICINE t
USING (SELECT 'MED-S04' AS Medicine_ID, 'Synthetic Teaching Medicine 4' AS Medicine_Name, 'Academic Demo Labs' AS Manufacturer, 'Demo tablet' AS Dosage_Form, NULL AS Allergen_Class, 14 AS Unit_Price FROM dual) s
ON (t.Medicine_ID = s.Medicine_ID)
WHEN NOT MATCHED THEN INSERT (Medicine_ID,Medicine_Name,Manufacturer,Dosage_Form,Allergen_Class,Unit_Price)
VALUES (s.Medicine_ID, s.Medicine_Name, s.Manufacturer, s.Dosage_Form, s.Allergen_Class, s.Unit_Price);

MERGE INTO MEDICINE t
USING (SELECT 'MED-S05' AS Medicine_ID, 'Synthetic Teaching Medicine 5' AS Medicine_Name, 'Academic Demo Labs' AS Manufacturer, 'Demo tablet' AS Dosage_Form, NULL AS Allergen_Class, 15 AS Unit_Price FROM dual) s
ON (t.Medicine_ID = s.Medicine_ID)
WHEN NOT MATCHED THEN INSERT (Medicine_ID,Medicine_Name,Manufacturer,Dosage_Form,Allergen_Class,Unit_Price)
VALUES (s.Medicine_ID, s.Medicine_Name, s.Manufacturer, s.Dosage_Form, s.Allergen_Class, s.Unit_Price);

MERGE INTO MEDICINE t
USING (SELECT 'MED-S06' AS Medicine_ID, 'Synthetic Teaching Medicine 6' AS Medicine_Name, 'Academic Demo Labs' AS Manufacturer, 'Demo tablet' AS Dosage_Form, NULL AS Allergen_Class, 16 AS Unit_Price FROM dual) s
ON (t.Medicine_ID = s.Medicine_ID)
WHEN NOT MATCHED THEN INSERT (Medicine_ID,Medicine_Name,Manufacturer,Dosage_Form,Allergen_Class,Unit_Price)
VALUES (s.Medicine_ID, s.Medicine_Name, s.Manufacturer, s.Dosage_Form, s.Allergen_Class, s.Unit_Price);

MERGE INTO MEDICINE t
USING (SELECT 'MED-S07' AS Medicine_ID, 'Synthetic Teaching Medicine 7' AS Medicine_Name, 'Academic Demo Labs' AS Manufacturer, 'Demo tablet' AS Dosage_Form, NULL AS Allergen_Class, 17 AS Unit_Price FROM dual) s
ON (t.Medicine_ID = s.Medicine_ID)
WHEN NOT MATCHED THEN INSERT (Medicine_ID,Medicine_Name,Manufacturer,Dosage_Form,Allergen_Class,Unit_Price)
VALUES (s.Medicine_ID, s.Medicine_Name, s.Manufacturer, s.Dosage_Form, s.Allergen_Class, s.Unit_Price);

MERGE INTO MEDICINE t
USING (SELECT 'MED-S08' AS Medicine_ID, 'Synthetic Teaching Medicine 8' AS Medicine_Name, 'Academic Demo Labs' AS Manufacturer, 'Demo tablet' AS Dosage_Form, NULL AS Allergen_Class, 18 AS Unit_Price FROM dual) s
ON (t.Medicine_ID = s.Medicine_ID)
WHEN NOT MATCHED THEN INSERT (Medicine_ID,Medicine_Name,Manufacturer,Dosage_Form,Allergen_Class,Unit_Price)
VALUES (s.Medicine_ID, s.Medicine_Name, s.Manufacturer, s.Dosage_Form, s.Allergen_Class, s.Unit_Price);

MERGE INTO MEDICINE t
USING (SELECT 'MED-S09' AS Medicine_ID, 'Synthetic Teaching Medicine 9' AS Medicine_Name, 'Academic Demo Labs' AS Manufacturer, 'Demo tablet' AS Dosage_Form, NULL AS Allergen_Class, 19 AS Unit_Price FROM dual) s
ON (t.Medicine_ID = s.Medicine_ID)
WHEN NOT MATCHED THEN INSERT (Medicine_ID,Medicine_Name,Manufacturer,Dosage_Form,Allergen_Class,Unit_Price)
VALUES (s.Medicine_ID, s.Medicine_Name, s.Manufacturer, s.Dosage_Form, s.Allergen_Class, s.Unit_Price);

MERGE INTO MEDICINE t
USING (SELECT 'MED-S10' AS Medicine_ID, 'Synthetic Teaching Medicine 10' AS Medicine_Name, 'Academic Demo Labs' AS Manufacturer, 'Demo tablet' AS Dosage_Form, NULL AS Allergen_Class, 20 AS Unit_Price FROM dual) s
ON (t.Medicine_ID = s.Medicine_ID)
WHEN NOT MATCHED THEN INSERT (Medicine_ID,Medicine_Name,Manufacturer,Dosage_Form,Allergen_Class,Unit_Price)
VALUES (s.Medicine_ID, s.Medicine_Name, s.Manufacturer, s.Dosage_Form, s.Allergen_Class, s.Unit_Price);

MERGE INTO MEDICINE t
USING (SELECT 'MED-S11' AS Medicine_ID, 'Synthetic Teaching Medicine 11' AS Medicine_Name, 'Academic Demo Labs' AS Manufacturer, 'Demo tablet' AS Dosage_Form, NULL AS Allergen_Class, 21 AS Unit_Price FROM dual) s
ON (t.Medicine_ID = s.Medicine_ID)
WHEN NOT MATCHED THEN INSERT (Medicine_ID,Medicine_Name,Manufacturer,Dosage_Form,Allergen_Class,Unit_Price)
VALUES (s.Medicine_ID, s.Medicine_Name, s.Manufacturer, s.Dosage_Form, s.Allergen_Class, s.Unit_Price);

MERGE INTO MEDICINE t
USING (SELECT 'MED-S12' AS Medicine_ID, 'Synthetic Teaching Medicine 12' AS Medicine_Name, 'Academic Demo Labs' AS Manufacturer, 'Demo tablet' AS Dosage_Form, NULL AS Allergen_Class, 22 AS Unit_Price FROM dual) s
ON (t.Medicine_ID = s.Medicine_ID)
WHEN NOT MATCHED THEN INSERT (Medicine_ID,Medicine_Name,Manufacturer,Dosage_Form,Allergen_Class,Unit_Price)
VALUES (s.Medicine_ID, s.Medicine_Name, s.Manufacturer, s.Dosage_Form, s.Allergen_Class, s.Unit_Price);

MERGE INTO MEDICINE t
USING (SELECT 'MED-S13' AS Medicine_ID, 'Synthetic Teaching Medicine 13' AS Medicine_Name, 'Academic Demo Labs' AS Manufacturer, 'Demo tablet' AS Dosage_Form, NULL AS Allergen_Class, 23 AS Unit_Price FROM dual) s
ON (t.Medicine_ID = s.Medicine_ID)
WHEN NOT MATCHED THEN INSERT (Medicine_ID,Medicine_Name,Manufacturer,Dosage_Form,Allergen_Class,Unit_Price)
VALUES (s.Medicine_ID, s.Medicine_Name, s.Manufacturer, s.Dosage_Form, s.Allergen_Class, s.Unit_Price);

MERGE INTO MEDICINE t
USING (SELECT 'MED-S14' AS Medicine_ID, 'Synthetic Teaching Medicine 14' AS Medicine_Name, 'Academic Demo Labs' AS Manufacturer, 'Demo tablet' AS Dosage_Form, NULL AS Allergen_Class, 24 AS Unit_Price FROM dual) s
ON (t.Medicine_ID = s.Medicine_ID)
WHEN NOT MATCHED THEN INSERT (Medicine_ID,Medicine_Name,Manufacturer,Dosage_Form,Allergen_Class,Unit_Price)
VALUES (s.Medicine_ID, s.Medicine_Name, s.Manufacturer, s.Dosage_Form, s.Allergen_Class, s.Unit_Price);

MERGE INTO MEDICINE t
USING (SELECT 'MED-S15' AS Medicine_ID, 'Synthetic Teaching Medicine 15' AS Medicine_Name, 'Academic Demo Labs' AS Manufacturer, 'Demo tablet' AS Dosage_Form, NULL AS Allergen_Class, 25 AS Unit_Price FROM dual) s
ON (t.Medicine_ID = s.Medicine_ID)
WHEN NOT MATCHED THEN INSERT (Medicine_ID,Medicine_Name,Manufacturer,Dosage_Form,Allergen_Class,Unit_Price)
VALUES (s.Medicine_ID, s.Medicine_Name, s.Manufacturer, s.Dosage_Form, s.Allergen_Class, s.Unit_Price);

MERGE INTO MEDICINE t
USING (SELECT 'MED-S16' AS Medicine_ID, 'Synthetic Teaching Medicine 16' AS Medicine_Name, 'Academic Demo Labs' AS Manufacturer, 'Demo tablet' AS Dosage_Form, NULL AS Allergen_Class, 26 AS Unit_Price FROM dual) s
ON (t.Medicine_ID = s.Medicine_ID)
WHEN NOT MATCHED THEN INSERT (Medicine_ID,Medicine_Name,Manufacturer,Dosage_Form,Allergen_Class,Unit_Price)
VALUES (s.Medicine_ID, s.Medicine_Name, s.Manufacturer, s.Dosage_Form, s.Allergen_Class, s.Unit_Price);

MERGE INTO MEDICINE t
USING (SELECT 'MED-S17' AS Medicine_ID, 'Synthetic Teaching Medicine 17' AS Medicine_Name, 'Academic Demo Labs' AS Manufacturer, 'Demo tablet' AS Dosage_Form, NULL AS Allergen_Class, 27 AS Unit_Price FROM dual) s
ON (t.Medicine_ID = s.Medicine_ID)
WHEN NOT MATCHED THEN INSERT (Medicine_ID,Medicine_Name,Manufacturer,Dosage_Form,Allergen_Class,Unit_Price)
VALUES (s.Medicine_ID, s.Medicine_Name, s.Manufacturer, s.Dosage_Form, s.Allergen_Class, s.Unit_Price);

-- LAB_TEST_CATALOG: 17 additional synthetic records
MERGE INTO LAB_TEST_CATALOG t
USING (SELECT 'LAB-S01' AS Test_Catalog_ID, 'Synthetic Screening Panel 1' AS Test_Name, 'Demo Screening' AS Category, 225 AS Standard_Cost FROM dual) s
ON (t.Test_Catalog_ID = s.Test_Catalog_ID)
WHEN NOT MATCHED THEN INSERT (Test_Catalog_ID,Test_Name,Category,Standard_Cost)
VALUES (s.Test_Catalog_ID, s.Test_Name, s.Category, s.Standard_Cost);

MERGE INTO LAB_TEST_CATALOG t
USING (SELECT 'LAB-S02' AS Test_Catalog_ID, 'Synthetic Screening Panel 2' AS Test_Name, 'Demo Screening' AS Category, 250 AS Standard_Cost FROM dual) s
ON (t.Test_Catalog_ID = s.Test_Catalog_ID)
WHEN NOT MATCHED THEN INSERT (Test_Catalog_ID,Test_Name,Category,Standard_Cost)
VALUES (s.Test_Catalog_ID, s.Test_Name, s.Category, s.Standard_Cost);

MERGE INTO LAB_TEST_CATALOG t
USING (SELECT 'LAB-S03' AS Test_Catalog_ID, 'Synthetic Screening Panel 3' AS Test_Name, 'Demo Screening' AS Category, 275 AS Standard_Cost FROM dual) s
ON (t.Test_Catalog_ID = s.Test_Catalog_ID)
WHEN NOT MATCHED THEN INSERT (Test_Catalog_ID,Test_Name,Category,Standard_Cost)
VALUES (s.Test_Catalog_ID, s.Test_Name, s.Category, s.Standard_Cost);

MERGE INTO LAB_TEST_CATALOG t
USING (SELECT 'LAB-S04' AS Test_Catalog_ID, 'Synthetic Screening Panel 4' AS Test_Name, 'Demo Screening' AS Category, 300 AS Standard_Cost FROM dual) s
ON (t.Test_Catalog_ID = s.Test_Catalog_ID)
WHEN NOT MATCHED THEN INSERT (Test_Catalog_ID,Test_Name,Category,Standard_Cost)
VALUES (s.Test_Catalog_ID, s.Test_Name, s.Category, s.Standard_Cost);

MERGE INTO LAB_TEST_CATALOG t
USING (SELECT 'LAB-S05' AS Test_Catalog_ID, 'Synthetic Screening Panel 5' AS Test_Name, 'Demo Screening' AS Category, 325 AS Standard_Cost FROM dual) s
ON (t.Test_Catalog_ID = s.Test_Catalog_ID)
WHEN NOT MATCHED THEN INSERT (Test_Catalog_ID,Test_Name,Category,Standard_Cost)
VALUES (s.Test_Catalog_ID, s.Test_Name, s.Category, s.Standard_Cost);

MERGE INTO LAB_TEST_CATALOG t
USING (SELECT 'LAB-S06' AS Test_Catalog_ID, 'Synthetic Screening Panel 6' AS Test_Name, 'Demo Screening' AS Category, 350 AS Standard_Cost FROM dual) s
ON (t.Test_Catalog_ID = s.Test_Catalog_ID)
WHEN NOT MATCHED THEN INSERT (Test_Catalog_ID,Test_Name,Category,Standard_Cost)
VALUES (s.Test_Catalog_ID, s.Test_Name, s.Category, s.Standard_Cost);

MERGE INTO LAB_TEST_CATALOG t
USING (SELECT 'LAB-S07' AS Test_Catalog_ID, 'Synthetic Screening Panel 7' AS Test_Name, 'Demo Screening' AS Category, 375 AS Standard_Cost FROM dual) s
ON (t.Test_Catalog_ID = s.Test_Catalog_ID)
WHEN NOT MATCHED THEN INSERT (Test_Catalog_ID,Test_Name,Category,Standard_Cost)
VALUES (s.Test_Catalog_ID, s.Test_Name, s.Category, s.Standard_Cost);

MERGE INTO LAB_TEST_CATALOG t
USING (SELECT 'LAB-S08' AS Test_Catalog_ID, 'Synthetic Screening Panel 8' AS Test_Name, 'Demo Screening' AS Category, 400 AS Standard_Cost FROM dual) s
ON (t.Test_Catalog_ID = s.Test_Catalog_ID)
WHEN NOT MATCHED THEN INSERT (Test_Catalog_ID,Test_Name,Category,Standard_Cost)
VALUES (s.Test_Catalog_ID, s.Test_Name, s.Category, s.Standard_Cost);

MERGE INTO LAB_TEST_CATALOG t
USING (SELECT 'LAB-S09' AS Test_Catalog_ID, 'Synthetic Screening Panel 9' AS Test_Name, 'Demo Screening' AS Category, 425 AS Standard_Cost FROM dual) s
ON (t.Test_Catalog_ID = s.Test_Catalog_ID)
WHEN NOT MATCHED THEN INSERT (Test_Catalog_ID,Test_Name,Category,Standard_Cost)
VALUES (s.Test_Catalog_ID, s.Test_Name, s.Category, s.Standard_Cost);

MERGE INTO LAB_TEST_CATALOG t
USING (SELECT 'LAB-S10' AS Test_Catalog_ID, 'Synthetic Screening Panel 10' AS Test_Name, 'Demo Screening' AS Category, 450 AS Standard_Cost FROM dual) s
ON (t.Test_Catalog_ID = s.Test_Catalog_ID)
WHEN NOT MATCHED THEN INSERT (Test_Catalog_ID,Test_Name,Category,Standard_Cost)
VALUES (s.Test_Catalog_ID, s.Test_Name, s.Category, s.Standard_Cost);

MERGE INTO LAB_TEST_CATALOG t
USING (SELECT 'LAB-S11' AS Test_Catalog_ID, 'Synthetic Screening Panel 11' AS Test_Name, 'Demo Screening' AS Category, 475 AS Standard_Cost FROM dual) s
ON (t.Test_Catalog_ID = s.Test_Catalog_ID)
WHEN NOT MATCHED THEN INSERT (Test_Catalog_ID,Test_Name,Category,Standard_Cost)
VALUES (s.Test_Catalog_ID, s.Test_Name, s.Category, s.Standard_Cost);

MERGE INTO LAB_TEST_CATALOG t
USING (SELECT 'LAB-S12' AS Test_Catalog_ID, 'Synthetic Screening Panel 12' AS Test_Name, 'Demo Screening' AS Category, 500 AS Standard_Cost FROM dual) s
ON (t.Test_Catalog_ID = s.Test_Catalog_ID)
WHEN NOT MATCHED THEN INSERT (Test_Catalog_ID,Test_Name,Category,Standard_Cost)
VALUES (s.Test_Catalog_ID, s.Test_Name, s.Category, s.Standard_Cost);

MERGE INTO LAB_TEST_CATALOG t
USING (SELECT 'LAB-S13' AS Test_Catalog_ID, 'Synthetic Screening Panel 13' AS Test_Name, 'Demo Screening' AS Category, 525 AS Standard_Cost FROM dual) s
ON (t.Test_Catalog_ID = s.Test_Catalog_ID)
WHEN NOT MATCHED THEN INSERT (Test_Catalog_ID,Test_Name,Category,Standard_Cost)
VALUES (s.Test_Catalog_ID, s.Test_Name, s.Category, s.Standard_Cost);

MERGE INTO LAB_TEST_CATALOG t
USING (SELECT 'LAB-S14' AS Test_Catalog_ID, 'Synthetic Screening Panel 14' AS Test_Name, 'Demo Screening' AS Category, 550 AS Standard_Cost FROM dual) s
ON (t.Test_Catalog_ID = s.Test_Catalog_ID)
WHEN NOT MATCHED THEN INSERT (Test_Catalog_ID,Test_Name,Category,Standard_Cost)
VALUES (s.Test_Catalog_ID, s.Test_Name, s.Category, s.Standard_Cost);

MERGE INTO LAB_TEST_CATALOG t
USING (SELECT 'LAB-S15' AS Test_Catalog_ID, 'Synthetic Screening Panel 15' AS Test_Name, 'Demo Screening' AS Category, 575 AS Standard_Cost FROM dual) s
ON (t.Test_Catalog_ID = s.Test_Catalog_ID)
WHEN NOT MATCHED THEN INSERT (Test_Catalog_ID,Test_Name,Category,Standard_Cost)
VALUES (s.Test_Catalog_ID, s.Test_Name, s.Category, s.Standard_Cost);

MERGE INTO LAB_TEST_CATALOG t
USING (SELECT 'LAB-S16' AS Test_Catalog_ID, 'Synthetic Screening Panel 16' AS Test_Name, 'Demo Screening' AS Category, 600 AS Standard_Cost FROM dual) s
ON (t.Test_Catalog_ID = s.Test_Catalog_ID)
WHEN NOT MATCHED THEN INSERT (Test_Catalog_ID,Test_Name,Category,Standard_Cost)
VALUES (s.Test_Catalog_ID, s.Test_Name, s.Category, s.Standard_Cost);

MERGE INTO LAB_TEST_CATALOG t
USING (SELECT 'LAB-S17' AS Test_Catalog_ID, 'Synthetic Screening Panel 17' AS Test_Name, 'Demo Screening' AS Category, 625 AS Standard_Cost FROM dual) s
ON (t.Test_Catalog_ID = s.Test_Catalog_ID)
WHEN NOT MATCHED THEN INSERT (Test_Catalog_ID,Test_Name,Category,Standard_Cost)
VALUES (s.Test_Catalog_ID, s.Test_Name, s.Category, s.Standard_Cost);

-- PATIENT: 17 additional synthetic records
MERGE INTO PATIENT t
USING (SELECT 'PAT-S01' AS Patient_ID, 'POL-S01' AS Policy_No, 'Aadhya' AS First_Name, 'Iyer' AS Last_Name, '1 Sample Street' AS Street, 'Chennai' AS City, 'TN' AS State, '600001' AS Zip_Code, DATE '1981-04-15' AS DOB, 'Female' AS Gender, '9000000001' AS Emergency_Contact FROM dual) s
ON (t.Patient_ID = s.Patient_ID)
WHEN NOT MATCHED THEN INSERT (Patient_ID,Policy_No,First_Name,Last_Name,Street,City,State,Zip_Code,DOB,Gender,Emergency_Contact)
VALUES (s.Patient_ID, s.Policy_No, s.First_Name, s.Last_Name, s.Street, s.City, s.State, s.Zip_Code, s.DOB, s.Gender, s.Emergency_Contact);

MERGE INTO PATIENT t
USING (SELECT 'PAT-S02' AS Patient_ID, 'POL-S02' AS Policy_No, 'Aditya' AS First_Name, 'Kumar' AS Last_Name, '2 Sample Street' AS Street, 'Chennai' AS City, 'TN' AS State, '600001' AS Zip_Code, DATE '1982-04-15' AS DOB, 'Male' AS Gender, '9000000002' AS Emergency_Contact FROM dual) s
ON (t.Patient_ID = s.Patient_ID)
WHEN NOT MATCHED THEN INSERT (Patient_ID,Policy_No,First_Name,Last_Name,Street,City,State,Zip_Code,DOB,Gender,Emergency_Contact)
VALUES (s.Patient_ID, s.Policy_No, s.First_Name, s.Last_Name, s.Street, s.City, s.State, s.Zip_Code, s.DOB, s.Gender, s.Emergency_Contact);

MERGE INTO PATIENT t
USING (SELECT 'PAT-S03' AS Patient_ID, 'POL-S03' AS Policy_No, 'Bhavana' AS First_Name, 'Menon' AS Last_Name, '3 Sample Street' AS Street, 'Chennai' AS City, 'TN' AS State, '600001' AS Zip_Code, DATE '1983-04-15' AS DOB, 'Female' AS Gender, '9000000003' AS Emergency_Contact FROM dual) s
ON (t.Patient_ID = s.Patient_ID)
WHEN NOT MATCHED THEN INSERT (Patient_ID,Policy_No,First_Name,Last_Name,Street,City,State,Zip_Code,DOB,Gender,Emergency_Contact)
VALUES (s.Patient_ID, s.Policy_No, s.First_Name, s.Last_Name, s.Street, s.City, s.State, s.Zip_Code, s.DOB, s.Gender, s.Emergency_Contact);

MERGE INTO PATIENT t
USING (SELECT 'PAT-S04' AS Patient_ID, 'POL-S04' AS Policy_No, 'Dinesh' AS First_Name, 'Rao' AS Last_Name, '4 Sample Street' AS Street, 'Chennai' AS City, 'TN' AS State, '600001' AS Zip_Code, DATE '1984-04-15' AS DOB, 'Male' AS Gender, '9000000004' AS Emergency_Contact FROM dual) s
ON (t.Patient_ID = s.Patient_ID)
WHEN NOT MATCHED THEN INSERT (Patient_ID,Policy_No,First_Name,Last_Name,Street,City,State,Zip_Code,DOB,Gender,Emergency_Contact)
VALUES (s.Patient_ID, s.Policy_No, s.First_Name, s.Last_Name, s.Street, s.City, s.State, s.Zip_Code, s.DOB, s.Gender, s.Emergency_Contact);

MERGE INTO PATIENT t
USING (SELECT 'PAT-S05' AS Patient_ID, 'POL-S05' AS Policy_No, 'Divya' AS First_Name, 'Nair' AS Last_Name, '5 Sample Street' AS Street, 'Chennai' AS City, 'TN' AS State, '600001' AS Zip_Code, DATE '1985-04-15' AS DOB, 'Female' AS Gender, '9000000005' AS Emergency_Contact FROM dual) s
ON (t.Patient_ID = s.Patient_ID)
WHEN NOT MATCHED THEN INSERT (Patient_ID,Policy_No,First_Name,Last_Name,Street,City,State,Zip_Code,DOB,Gender,Emergency_Contact)
VALUES (s.Patient_ID, s.Policy_No, s.First_Name, s.Last_Name, s.Street, s.City, s.State, s.Zip_Code, s.DOB, s.Gender, s.Emergency_Contact);

MERGE INTO PATIENT t
USING (SELECT 'PAT-S06' AS Patient_ID, 'POL-S06' AS Policy_No, 'Gautham' AS First_Name, 'Shankar' AS Last_Name, '6 Sample Street' AS Street, 'Chennai' AS City, 'TN' AS State, '600001' AS Zip_Code, DATE '1986-04-15' AS DOB, 'Male' AS Gender, '9000000006' AS Emergency_Contact FROM dual) s
ON (t.Patient_ID = s.Patient_ID)
WHEN NOT MATCHED THEN INSERT (Patient_ID,Policy_No,First_Name,Last_Name,Street,City,State,Zip_Code,DOB,Gender,Emergency_Contact)
VALUES (s.Patient_ID, s.Policy_No, s.First_Name, s.Last_Name, s.Street, s.City, s.State, s.Zip_Code, s.DOB, s.Gender, s.Emergency_Contact);

MERGE INTO PATIENT t
USING (SELECT 'PAT-S07' AS Patient_ID, 'POL-S07' AS Policy_No, 'Harini' AS First_Name, 'Pillai' AS Last_Name, '7 Sample Street' AS Street, 'Chennai' AS City, 'TN' AS State, '600001' AS Zip_Code, DATE '1987-04-15' AS DOB, 'Female' AS Gender, '9000000007' AS Emergency_Contact FROM dual) s
ON (t.Patient_ID = s.Patient_ID)
WHEN NOT MATCHED THEN INSERT (Patient_ID,Policy_No,First_Name,Last_Name,Street,City,State,Zip_Code,DOB,Gender,Emergency_Contact)
VALUES (s.Patient_ID, s.Policy_No, s.First_Name, s.Last_Name, s.Street, s.City, s.State, s.Zip_Code, s.DOB, s.Gender, s.Emergency_Contact);

MERGE INTO PATIENT t
USING (SELECT 'PAT-S08' AS Patient_ID, 'POL-S08' AS Policy_No, 'Ishaan' AS First_Name, 'Reddy' AS Last_Name, '8 Sample Street' AS Street, 'Chennai' AS City, 'TN' AS State, '600001' AS Zip_Code, DATE '1988-04-15' AS DOB, 'Male' AS Gender, '9000000008' AS Emergency_Contact FROM dual) s
ON (t.Patient_ID = s.Patient_ID)
WHEN NOT MATCHED THEN INSERT (Patient_ID,Policy_No,First_Name,Last_Name,Street,City,State,Zip_Code,DOB,Gender,Emergency_Contact)
VALUES (s.Patient_ID, s.Policy_No, s.First_Name, s.Last_Name, s.Street, s.City, s.State, s.Zip_Code, s.DOB, s.Gender, s.Emergency_Contact);

MERGE INTO PATIENT t
USING (SELECT 'PAT-S09' AS Patient_ID, 'POL-S09' AS Policy_No, 'Janani' AS First_Name, 'Mani' AS Last_Name, '9 Sample Street' AS Street, 'Chennai' AS City, 'TN' AS State, '600001' AS Zip_Code, DATE '1989-04-15' AS DOB, 'Female' AS Gender, '9000000009' AS Emergency_Contact FROM dual) s
ON (t.Patient_ID = s.Patient_ID)
WHEN NOT MATCHED THEN INSERT (Patient_ID,Policy_No,First_Name,Last_Name,Street,City,State,Zip_Code,DOB,Gender,Emergency_Contact)
VALUES (s.Patient_ID, s.Policy_No, s.First_Name, s.Last_Name, s.Street, s.City, s.State, s.Zip_Code, s.DOB, s.Gender, s.Emergency_Contact);

MERGE INTO PATIENT t
USING (SELECT 'PAT-S10' AS Patient_ID, 'POL-S10' AS Policy_No, 'Kavin' AS First_Name, 'Raj' AS Last_Name, '10 Sample Street' AS Street, 'Chennai' AS City, 'TN' AS State, '600001' AS Zip_Code, DATE '1990-04-15' AS DOB, 'Male' AS Gender, '9000000010' AS Emergency_Contact FROM dual) s
ON (t.Patient_ID = s.Patient_ID)
WHEN NOT MATCHED THEN INSERT (Patient_ID,Policy_No,First_Name,Last_Name,Street,City,State,Zip_Code,DOB,Gender,Emergency_Contact)
VALUES (s.Patient_ID, s.Policy_No, s.First_Name, s.Last_Name, s.Street, s.City, s.State, s.Zip_Code, s.DOB, s.Gender, s.Emergency_Contact);

MERGE INTO PATIENT t
USING (SELECT 'PAT-S11' AS Patient_ID, 'POL-S11' AS Policy_No, 'Lavanya' AS First_Name, 'Das' AS Last_Name, '11 Sample Street' AS Street, 'Chennai' AS City, 'TN' AS State, '600001' AS Zip_Code, DATE '1991-04-15' AS DOB, 'Female' AS Gender, '9000000011' AS Emergency_Contact FROM dual) s
ON (t.Patient_ID = s.Patient_ID)
WHEN NOT MATCHED THEN INSERT (Patient_ID,Policy_No,First_Name,Last_Name,Street,City,State,Zip_Code,DOB,Gender,Emergency_Contact)
VALUES (s.Patient_ID, s.Policy_No, s.First_Name, s.Last_Name, s.Street, s.City, s.State, s.Zip_Code, s.DOB, s.Gender, s.Emergency_Contact);

MERGE INTO PATIENT t
USING (SELECT 'PAT-S12' AS Patient_ID, 'POL-S12' AS Policy_No, 'Mohan' AS First_Name, 'Babu' AS Last_Name, '12 Sample Street' AS Street, 'Chennai' AS City, 'TN' AS State, '600001' AS Zip_Code, DATE '1992-04-15' AS DOB, 'Male' AS Gender, '9000000012' AS Emergency_Contact FROM dual) s
ON (t.Patient_ID = s.Patient_ID)
WHEN NOT MATCHED THEN INSERT (Patient_ID,Policy_No,First_Name,Last_Name,Street,City,State,Zip_Code,DOB,Gender,Emergency_Contact)
VALUES (s.Patient_ID, s.Policy_No, s.First_Name, s.Last_Name, s.Street, s.City, s.State, s.Zip_Code, s.DOB, s.Gender, s.Emergency_Contact);

MERGE INTO PATIENT t
USING (SELECT 'PAT-S13' AS Patient_ID, 'POL-S13' AS Policy_No, 'Nithya' AS First_Name, 'Krishnan' AS Last_Name, '13 Sample Street' AS Street, 'Chennai' AS City, 'TN' AS State, '600001' AS Zip_Code, DATE '1993-04-15' AS DOB, 'Female' AS Gender, '9000000013' AS Emergency_Contact FROM dual) s
ON (t.Patient_ID = s.Patient_ID)
WHEN NOT MATCHED THEN INSERT (Patient_ID,Policy_No,First_Name,Last_Name,Street,City,State,Zip_Code,DOB,Gender,Emergency_Contact)
VALUES (s.Patient_ID, s.Policy_No, s.First_Name, s.Last_Name, s.Street, s.City, s.State, s.Zip_Code, s.DOB, s.Gender, s.Emergency_Contact);

MERGE INTO PATIENT t
USING (SELECT 'PAT-S14' AS Patient_ID, 'POL-S14' AS Policy_No, 'Pranav' AS First_Name, 'Varma' AS Last_Name, '14 Sample Street' AS Street, 'Chennai' AS City, 'TN' AS State, '600001' AS Zip_Code, DATE '1994-04-15' AS DOB, 'Male' AS Gender, '9000000014' AS Emergency_Contact FROM dual) s
ON (t.Patient_ID = s.Patient_ID)
WHEN NOT MATCHED THEN INSERT (Patient_ID,Policy_No,First_Name,Last_Name,Street,City,State,Zip_Code,DOB,Gender,Emergency_Contact)
VALUES (s.Patient_ID, s.Policy_No, s.First_Name, s.Last_Name, s.Street, s.City, s.State, s.Zip_Code, s.DOB, s.Gender, s.Emergency_Contact);

MERGE INTO PATIENT t
USING (SELECT 'PAT-S15' AS Patient_ID, 'POL-S15' AS Policy_No, 'Revathi' AS First_Name, 'Srinivasan' AS Last_Name, '15 Sample Street' AS Street, 'Chennai' AS City, 'TN' AS State, '600001' AS Zip_Code, DATE '1995-04-15' AS DOB, 'Female' AS Gender, '9000000015' AS Emergency_Contact FROM dual) s
ON (t.Patient_ID = s.Patient_ID)
WHEN NOT MATCHED THEN INSERT (Patient_ID,Policy_No,First_Name,Last_Name,Street,City,State,Zip_Code,DOB,Gender,Emergency_Contact)
VALUES (s.Patient_ID, s.Policy_No, s.First_Name, s.Last_Name, s.Street, s.City, s.State, s.Zip_Code, s.DOB, s.Gender, s.Emergency_Contact);

MERGE INTO PATIENT t
USING (SELECT 'PAT-S16' AS Patient_ID, 'POL-S16' AS Policy_No, 'Surya' AS First_Name, 'Narayan' AS Last_Name, '16 Sample Street' AS Street, 'Chennai' AS City, 'TN' AS State, '600001' AS Zip_Code, DATE '1996-04-15' AS DOB, 'Male' AS Gender, '9000000016' AS Emergency_Contact FROM dual) s
ON (t.Patient_ID = s.Patient_ID)
WHEN NOT MATCHED THEN INSERT (Patient_ID,Policy_No,First_Name,Last_Name,Street,City,State,Zip_Code,DOB,Gender,Emergency_Contact)
VALUES (s.Patient_ID, s.Policy_No, s.First_Name, s.Last_Name, s.Street, s.City, s.State, s.Zip_Code, s.DOB, s.Gender, s.Emergency_Contact);

MERGE INTO PATIENT t
USING (SELECT 'PAT-S17' AS Patient_ID, 'POL-S17' AS Policy_No, 'Yamini' AS First_Name, 'Sekar' AS Last_Name, '17 Sample Street' AS Street, 'Chennai' AS City, 'TN' AS State, '600001' AS Zip_Code, DATE '1997-04-15' AS DOB, 'Female' AS Gender, '9000000017' AS Emergency_Contact FROM dual) s
ON (t.Patient_ID = s.Patient_ID)
WHEN NOT MATCHED THEN INSERT (Patient_ID,Policy_No,First_Name,Last_Name,Street,City,State,Zip_Code,DOB,Gender,Emergency_Contact)
VALUES (s.Patient_ID, s.Policy_No, s.First_Name, s.Last_Name, s.Street, s.City, s.State, s.Zip_Code, s.DOB, s.Gender, s.Emergency_Contact);

-- DOCTOR: 17 additional synthetic records
MERGE INTO DOCTOR t
USING (SELECT 'DOC-S01' AS Doctor_ID, 'DEP-S01' AS Dept_ID, 'Gautham' AS First_Name, 'Reddy' AS Last_Name, 'Ophthalmology' AS Specialization, 'doctor.s01@example.invalid' AS Email, '9000010001' AS Primary_Phone FROM dual) s
ON (t.Doctor_ID = s.Doctor_ID)
WHEN NOT MATCHED THEN INSERT (Doctor_ID,Dept_ID,First_Name,Last_Name,Specialization,Email,Primary_Phone)
VALUES (s.Doctor_ID, s.Dept_ID, s.First_Name, s.Last_Name, s.Specialization, s.Email, s.Primary_Phone);

MERGE INTO DOCTOR t
USING (SELECT 'DOC-S02' AS Doctor_ID, 'DEP-S02' AS Dept_ID, 'Harini' AS First_Name, 'Mani' AS Last_Name, 'ENT' AS Specialization, 'doctor.s02@example.invalid' AS Email, '9000010002' AS Primary_Phone FROM dual) s
ON (t.Doctor_ID = s.Doctor_ID)
WHEN NOT MATCHED THEN INSERT (Doctor_ID,Dept_ID,First_Name,Last_Name,Specialization,Email,Primary_Phone)
VALUES (s.Doctor_ID, s.Dept_ID, s.First_Name, s.Last_Name, s.Specialization, s.Email, s.Primary_Phone);

MERGE INTO DOCTOR t
USING (SELECT 'DOC-S03' AS Doctor_ID, 'DEP-S03' AS Dept_ID, 'Ishaan' AS First_Name, 'Raj' AS Last_Name, 'Urology' AS Specialization, 'doctor.s03@example.invalid' AS Email, '9000010003' AS Primary_Phone FROM dual) s
ON (t.Doctor_ID = s.Doctor_ID)
WHEN NOT MATCHED THEN INSERT (Doctor_ID,Dept_ID,First_Name,Last_Name,Specialization,Email,Primary_Phone)
VALUES (s.Doctor_ID, s.Dept_ID, s.First_Name, s.Last_Name, s.Specialization, s.Email, s.Primary_Phone);

MERGE INTO DOCTOR t
USING (SELECT 'DOC-S04' AS Doctor_ID, 'DEP-S04' AS Dept_ID, 'Janani' AS First_Name, 'Das' AS Last_Name, 'Nephrology' AS Specialization, 'doctor.s04@example.invalid' AS Email, '9000010004' AS Primary_Phone FROM dual) s
ON (t.Doctor_ID = s.Doctor_ID)
WHEN NOT MATCHED THEN INSERT (Doctor_ID,Dept_ID,First_Name,Last_Name,Specialization,Email,Primary_Phone)
VALUES (s.Doctor_ID, s.Dept_ID, s.First_Name, s.Last_Name, s.Specialization, s.Email, s.Primary_Phone);

MERGE INTO DOCTOR t
USING (SELECT 'DOC-S05' AS Doctor_ID, 'DEP-S05' AS Dept_ID, 'Kavin' AS First_Name, 'Babu' AS Last_Name, 'Endocrinology' AS Specialization, 'doctor.s05@example.invalid' AS Email, '9000010005' AS Primary_Phone FROM dual) s
ON (t.Doctor_ID = s.Doctor_ID)
WHEN NOT MATCHED THEN INSERT (Doctor_ID,Dept_ID,First_Name,Last_Name,Specialization,Email,Primary_Phone)
VALUES (s.Doctor_ID, s.Dept_ID, s.First_Name, s.Last_Name, s.Specialization, s.Email, s.Primary_Phone);

MERGE INTO DOCTOR t
USING (SELECT 'DOC-S06' AS Doctor_ID, 'DEP-S06' AS Dept_ID, 'Lavanya' AS First_Name, 'Krishnan' AS Last_Name, 'Rheumatology' AS Specialization, 'doctor.s06@example.invalid' AS Email, '9000010006' AS Primary_Phone FROM dual) s
ON (t.Doctor_ID = s.Doctor_ID)
WHEN NOT MATCHED THEN INSERT (Doctor_ID,Dept_ID,First_Name,Last_Name,Specialization,Email,Primary_Phone)
VALUES (s.Doctor_ID, s.Dept_ID, s.First_Name, s.Last_Name, s.Specialization, s.Email, s.Primary_Phone);

MERGE INTO DOCTOR t
USING (SELECT 'DOC-S07' AS Doctor_ID, 'DEP-S07' AS Dept_ID, 'Mohan' AS First_Name, 'Varma' AS Last_Name, 'Oncology' AS Specialization, 'doctor.s07@example.invalid' AS Email, '9000010007' AS Primary_Phone FROM dual) s
ON (t.Doctor_ID = s.Doctor_ID)
WHEN NOT MATCHED THEN INSERT (Doctor_ID,Dept_ID,First_Name,Last_Name,Specialization,Email,Primary_Phone)
VALUES (s.Doctor_ID, s.Dept_ID, s.First_Name, s.Last_Name, s.Specialization, s.Email, s.Primary_Phone);

MERGE INTO DOCTOR t
USING (SELECT 'DOC-S08' AS Doctor_ID, 'DEP-S08' AS Dept_ID, 'Nithya' AS First_Name, 'Srinivasan' AS Last_Name, 'Psychiatry' AS Specialization, 'doctor.s08@example.invalid' AS Email, '9000010008' AS Primary_Phone FROM dual) s
ON (t.Doctor_ID = s.Doctor_ID)
WHEN NOT MATCHED THEN INSERT (Doctor_ID,Dept_ID,First_Name,Last_Name,Specialization,Email,Primary_Phone)
VALUES (s.Doctor_ID, s.Dept_ID, s.First_Name, s.Last_Name, s.Specialization, s.Email, s.Primary_Phone);

MERGE INTO DOCTOR t
USING (SELECT 'DOC-S09' AS Doctor_ID, 'DEP-S09' AS Dept_ID, 'Pranav' AS First_Name, 'Narayan' AS Last_Name, 'Obstetrics' AS Specialization, 'doctor.s09@example.invalid' AS Email, '9000010009' AS Primary_Phone FROM dual) s
ON (t.Doctor_ID = s.Doctor_ID)
WHEN NOT MATCHED THEN INSERT (Doctor_ID,Dept_ID,First_Name,Last_Name,Specialization,Email,Primary_Phone)
VALUES (s.Doctor_ID, s.Dept_ID, s.First_Name, s.Last_Name, s.Specialization, s.Email, s.Primary_Phone);

MERGE INTO DOCTOR t
USING (SELECT 'DOC-S10' AS Doctor_ID, 'DEP-S10' AS Dept_ID, 'Revathi' AS First_Name, 'Sekar' AS Last_Name, 'Gynecology' AS Specialization, 'doctor.s10@example.invalid' AS Email, '9000010010' AS Primary_Phone FROM dual) s
ON (t.Doctor_ID = s.Doctor_ID)
WHEN NOT MATCHED THEN INSERT (Doctor_ID,Dept_ID,First_Name,Last_Name,Specialization,Email,Primary_Phone)
VALUES (s.Doctor_ID, s.Dept_ID, s.First_Name, s.Last_Name, s.Specialization, s.Email, s.Primary_Phone);

MERGE INTO DOCTOR t
USING (SELECT 'DOC-S11' AS Doctor_ID, 'DEP-S11' AS Dept_ID, 'Surya' AS First_Name, 'Iyer' AS Last_Name, 'Geriatrics' AS Specialization, 'doctor.s11@example.invalid' AS Email, '9000010011' AS Primary_Phone FROM dual) s
ON (t.Doctor_ID = s.Doctor_ID)
WHEN NOT MATCHED THEN INSERT (Doctor_ID,Dept_ID,First_Name,Last_Name,Specialization,Email,Primary_Phone)
VALUES (s.Doctor_ID, s.Dept_ID, s.First_Name, s.Last_Name, s.Specialization, s.Email, s.Primary_Phone);

MERGE INTO DOCTOR t
USING (SELECT 'DOC-S12' AS Doctor_ID, 'DEP-S12' AS Dept_ID, 'Yamini' AS First_Name, 'Kumar' AS Last_Name, 'Emergency Medicine' AS Specialization, 'doctor.s12@example.invalid' AS Email, '9000010012' AS Primary_Phone FROM dual) s
ON (t.Doctor_ID = s.Doctor_ID)
WHEN NOT MATCHED THEN INSERT (Doctor_ID,Dept_ID,First_Name,Last_Name,Specialization,Email,Primary_Phone)
VALUES (s.Doctor_ID, s.Dept_ID, s.First_Name, s.Last_Name, s.Specialization, s.Email, s.Primary_Phone);

MERGE INTO DOCTOR t
USING (SELECT 'DOC-S13' AS Doctor_ID, 'DEP-S13' AS Dept_ID, 'Aadhya' AS First_Name, 'Menon' AS Last_Name, 'Physiotherapy' AS Specialization, 'doctor.s13@example.invalid' AS Email, '9000010013' AS Primary_Phone FROM dual) s
ON (t.Doctor_ID = s.Doctor_ID)
WHEN NOT MATCHED THEN INSERT (Doctor_ID,Dept_ID,First_Name,Last_Name,Specialization,Email,Primary_Phone)
VALUES (s.Doctor_ID, s.Dept_ID, s.First_Name, s.Last_Name, s.Specialization, s.Email, s.Primary_Phone);

MERGE INTO DOCTOR t
USING (SELECT 'DOC-S14' AS Doctor_ID, 'DEP-S14' AS Dept_ID, 'Aditya' AS First_Name, 'Rao' AS Last_Name, 'Dentistry' AS Specialization, 'doctor.s14@example.invalid' AS Email, '9000010014' AS Primary_Phone FROM dual) s
ON (t.Doctor_ID = s.Doctor_ID)
WHEN NOT MATCHED THEN INSERT (Doctor_ID,Dept_ID,First_Name,Last_Name,Specialization,Email,Primary_Phone)
VALUES (s.Doctor_ID, s.Dept_ID, s.First_Name, s.Last_Name, s.Specialization, s.Email, s.Primary_Phone);

MERGE INTO DOCTOR t
USING (SELECT 'DOC-S15' AS Doctor_ID, 'DEP-S15' AS Dept_ID, 'Bhavana' AS First_Name, 'Nair' AS Last_Name, 'Nutrition' AS Specialization, 'doctor.s15@example.invalid' AS Email, '9000010015' AS Primary_Phone FROM dual) s
ON (t.Doctor_ID = s.Doctor_ID)
WHEN NOT MATCHED THEN INSERT (Doctor_ID,Dept_ID,First_Name,Last_Name,Specialization,Email,Primary_Phone)
VALUES (s.Doctor_ID, s.Dept_ID, s.First_Name, s.Last_Name, s.Specialization, s.Email, s.Primary_Phone);

MERGE INTO DOCTOR t
USING (SELECT 'DOC-S16' AS Doctor_ID, 'DEP-S16' AS Dept_ID, 'Dinesh' AS First_Name, 'Shankar' AS Last_Name, 'Infectious Diseases' AS Specialization, 'doctor.s16@example.invalid' AS Email, '9000010016' AS Primary_Phone FROM dual) s
ON (t.Doctor_ID = s.Doctor_ID)
WHEN NOT MATCHED THEN INSERT (Doctor_ID,Dept_ID,First_Name,Last_Name,Specialization,Email,Primary_Phone)
VALUES (s.Doctor_ID, s.Dept_ID, s.First_Name, s.Last_Name, s.Specialization, s.Email, s.Primary_Phone);

MERGE INTO DOCTOR t
USING (SELECT 'DOC-S17' AS Doctor_ID, 'DEP-S17' AS Dept_ID, 'Divya' AS First_Name, 'Pillai' AS Last_Name, 'Family Medicine' AS Specialization, 'doctor.s17@example.invalid' AS Email, '9000010017' AS Primary_Phone FROM dual) s
ON (t.Doctor_ID = s.Doctor_ID)
WHEN NOT MATCHED THEN INSERT (Doctor_ID,Dept_ID,First_Name,Last_Name,Specialization,Email,Primary_Phone)
VALUES (s.Doctor_ID, s.Dept_ID, s.First_Name, s.Last_Name, s.Specialization, s.Email, s.Primary_Phone);

-- PATIENT_PHONE: 17 additional synthetic records
MERGE INTO PATIENT_PHONE t
USING (SELECT 'PAT-S01' AS Patient_ID, '9000000001' AS Phone_Number FROM dual) s
ON (t.Patient_ID = s.Patient_ID AND t.Phone_Number = s.Phone_Number)
WHEN NOT MATCHED THEN INSERT (Patient_ID,Phone_Number)
VALUES (s.Patient_ID, s.Phone_Number);

MERGE INTO PATIENT_PHONE t
USING (SELECT 'PAT-S02' AS Patient_ID, '9000000002' AS Phone_Number FROM dual) s
ON (t.Patient_ID = s.Patient_ID AND t.Phone_Number = s.Phone_Number)
WHEN NOT MATCHED THEN INSERT (Patient_ID,Phone_Number)
VALUES (s.Patient_ID, s.Phone_Number);

MERGE INTO PATIENT_PHONE t
USING (SELECT 'PAT-S03' AS Patient_ID, '9000000003' AS Phone_Number FROM dual) s
ON (t.Patient_ID = s.Patient_ID AND t.Phone_Number = s.Phone_Number)
WHEN NOT MATCHED THEN INSERT (Patient_ID,Phone_Number)
VALUES (s.Patient_ID, s.Phone_Number);

MERGE INTO PATIENT_PHONE t
USING (SELECT 'PAT-S04' AS Patient_ID, '9000000004' AS Phone_Number FROM dual) s
ON (t.Patient_ID = s.Patient_ID AND t.Phone_Number = s.Phone_Number)
WHEN NOT MATCHED THEN INSERT (Patient_ID,Phone_Number)
VALUES (s.Patient_ID, s.Phone_Number);

MERGE INTO PATIENT_PHONE t
USING (SELECT 'PAT-S05' AS Patient_ID, '9000000005' AS Phone_Number FROM dual) s
ON (t.Patient_ID = s.Patient_ID AND t.Phone_Number = s.Phone_Number)
WHEN NOT MATCHED THEN INSERT (Patient_ID,Phone_Number)
VALUES (s.Patient_ID, s.Phone_Number);

MERGE INTO PATIENT_PHONE t
USING (SELECT 'PAT-S06' AS Patient_ID, '9000000006' AS Phone_Number FROM dual) s
ON (t.Patient_ID = s.Patient_ID AND t.Phone_Number = s.Phone_Number)
WHEN NOT MATCHED THEN INSERT (Patient_ID,Phone_Number)
VALUES (s.Patient_ID, s.Phone_Number);

MERGE INTO PATIENT_PHONE t
USING (SELECT 'PAT-S07' AS Patient_ID, '9000000007' AS Phone_Number FROM dual) s
ON (t.Patient_ID = s.Patient_ID AND t.Phone_Number = s.Phone_Number)
WHEN NOT MATCHED THEN INSERT (Patient_ID,Phone_Number)
VALUES (s.Patient_ID, s.Phone_Number);

MERGE INTO PATIENT_PHONE t
USING (SELECT 'PAT-S08' AS Patient_ID, '9000000008' AS Phone_Number FROM dual) s
ON (t.Patient_ID = s.Patient_ID AND t.Phone_Number = s.Phone_Number)
WHEN NOT MATCHED THEN INSERT (Patient_ID,Phone_Number)
VALUES (s.Patient_ID, s.Phone_Number);

MERGE INTO PATIENT_PHONE t
USING (SELECT 'PAT-S09' AS Patient_ID, '9000000009' AS Phone_Number FROM dual) s
ON (t.Patient_ID = s.Patient_ID AND t.Phone_Number = s.Phone_Number)
WHEN NOT MATCHED THEN INSERT (Patient_ID,Phone_Number)
VALUES (s.Patient_ID, s.Phone_Number);

MERGE INTO PATIENT_PHONE t
USING (SELECT 'PAT-S10' AS Patient_ID, '9000000010' AS Phone_Number FROM dual) s
ON (t.Patient_ID = s.Patient_ID AND t.Phone_Number = s.Phone_Number)
WHEN NOT MATCHED THEN INSERT (Patient_ID,Phone_Number)
VALUES (s.Patient_ID, s.Phone_Number);

MERGE INTO PATIENT_PHONE t
USING (SELECT 'PAT-S11' AS Patient_ID, '9000000011' AS Phone_Number FROM dual) s
ON (t.Patient_ID = s.Patient_ID AND t.Phone_Number = s.Phone_Number)
WHEN NOT MATCHED THEN INSERT (Patient_ID,Phone_Number)
VALUES (s.Patient_ID, s.Phone_Number);

MERGE INTO PATIENT_PHONE t
USING (SELECT 'PAT-S12' AS Patient_ID, '9000000012' AS Phone_Number FROM dual) s
ON (t.Patient_ID = s.Patient_ID AND t.Phone_Number = s.Phone_Number)
WHEN NOT MATCHED THEN INSERT (Patient_ID,Phone_Number)
VALUES (s.Patient_ID, s.Phone_Number);

MERGE INTO PATIENT_PHONE t
USING (SELECT 'PAT-S13' AS Patient_ID, '9000000013' AS Phone_Number FROM dual) s
ON (t.Patient_ID = s.Patient_ID AND t.Phone_Number = s.Phone_Number)
WHEN NOT MATCHED THEN INSERT (Patient_ID,Phone_Number)
VALUES (s.Patient_ID, s.Phone_Number);

MERGE INTO PATIENT_PHONE t
USING (SELECT 'PAT-S14' AS Patient_ID, '9000000014' AS Phone_Number FROM dual) s
ON (t.Patient_ID = s.Patient_ID AND t.Phone_Number = s.Phone_Number)
WHEN NOT MATCHED THEN INSERT (Patient_ID,Phone_Number)
VALUES (s.Patient_ID, s.Phone_Number);

MERGE INTO PATIENT_PHONE t
USING (SELECT 'PAT-S15' AS Patient_ID, '9000000015' AS Phone_Number FROM dual) s
ON (t.Patient_ID = s.Patient_ID AND t.Phone_Number = s.Phone_Number)
WHEN NOT MATCHED THEN INSERT (Patient_ID,Phone_Number)
VALUES (s.Patient_ID, s.Phone_Number);

MERGE INTO PATIENT_PHONE t
USING (SELECT 'PAT-S16' AS Patient_ID, '9000000016' AS Phone_Number FROM dual) s
ON (t.Patient_ID = s.Patient_ID AND t.Phone_Number = s.Phone_Number)
WHEN NOT MATCHED THEN INSERT (Patient_ID,Phone_Number)
VALUES (s.Patient_ID, s.Phone_Number);

MERGE INTO PATIENT_PHONE t
USING (SELECT 'PAT-S17' AS Patient_ID, '9000000017' AS Phone_Number FROM dual) s
ON (t.Patient_ID = s.Patient_ID AND t.Phone_Number = s.Phone_Number)
WHEN NOT MATCHED THEN INSERT (Patient_ID,Phone_Number)
VALUES (s.Patient_ID, s.Phone_Number);

-- DOCTOR_QUALIFICATION: 17 additional synthetic records
MERGE INTO DOCTOR_QUALIFICATION t
USING (SELECT 'DOC-S01' AS Doctor_ID, 'MBBS (Synthetic teaching record)' AS Qualification FROM dual) s
ON (t.Doctor_ID = s.Doctor_ID AND t.Qualification = s.Qualification)
WHEN NOT MATCHED THEN INSERT (Doctor_ID,Qualification)
VALUES (s.Doctor_ID, s.Qualification);

MERGE INTO DOCTOR_QUALIFICATION t
USING (SELECT 'DOC-S02' AS Doctor_ID, 'MBBS (Synthetic teaching record)' AS Qualification FROM dual) s
ON (t.Doctor_ID = s.Doctor_ID AND t.Qualification = s.Qualification)
WHEN NOT MATCHED THEN INSERT (Doctor_ID,Qualification)
VALUES (s.Doctor_ID, s.Qualification);

MERGE INTO DOCTOR_QUALIFICATION t
USING (SELECT 'DOC-S03' AS Doctor_ID, 'MBBS (Synthetic teaching record)' AS Qualification FROM dual) s
ON (t.Doctor_ID = s.Doctor_ID AND t.Qualification = s.Qualification)
WHEN NOT MATCHED THEN INSERT (Doctor_ID,Qualification)
VALUES (s.Doctor_ID, s.Qualification);

MERGE INTO DOCTOR_QUALIFICATION t
USING (SELECT 'DOC-S04' AS Doctor_ID, 'MBBS (Synthetic teaching record)' AS Qualification FROM dual) s
ON (t.Doctor_ID = s.Doctor_ID AND t.Qualification = s.Qualification)
WHEN NOT MATCHED THEN INSERT (Doctor_ID,Qualification)
VALUES (s.Doctor_ID, s.Qualification);

MERGE INTO DOCTOR_QUALIFICATION t
USING (SELECT 'DOC-S05' AS Doctor_ID, 'MBBS (Synthetic teaching record)' AS Qualification FROM dual) s
ON (t.Doctor_ID = s.Doctor_ID AND t.Qualification = s.Qualification)
WHEN NOT MATCHED THEN INSERT (Doctor_ID,Qualification)
VALUES (s.Doctor_ID, s.Qualification);

MERGE INTO DOCTOR_QUALIFICATION t
USING (SELECT 'DOC-S06' AS Doctor_ID, 'MBBS (Synthetic teaching record)' AS Qualification FROM dual) s
ON (t.Doctor_ID = s.Doctor_ID AND t.Qualification = s.Qualification)
WHEN NOT MATCHED THEN INSERT (Doctor_ID,Qualification)
VALUES (s.Doctor_ID, s.Qualification);

MERGE INTO DOCTOR_QUALIFICATION t
USING (SELECT 'DOC-S07' AS Doctor_ID, 'MBBS (Synthetic teaching record)' AS Qualification FROM dual) s
ON (t.Doctor_ID = s.Doctor_ID AND t.Qualification = s.Qualification)
WHEN NOT MATCHED THEN INSERT (Doctor_ID,Qualification)
VALUES (s.Doctor_ID, s.Qualification);

MERGE INTO DOCTOR_QUALIFICATION t
USING (SELECT 'DOC-S08' AS Doctor_ID, 'MBBS (Synthetic teaching record)' AS Qualification FROM dual) s
ON (t.Doctor_ID = s.Doctor_ID AND t.Qualification = s.Qualification)
WHEN NOT MATCHED THEN INSERT (Doctor_ID,Qualification)
VALUES (s.Doctor_ID, s.Qualification);

MERGE INTO DOCTOR_QUALIFICATION t
USING (SELECT 'DOC-S09' AS Doctor_ID, 'MBBS (Synthetic teaching record)' AS Qualification FROM dual) s
ON (t.Doctor_ID = s.Doctor_ID AND t.Qualification = s.Qualification)
WHEN NOT MATCHED THEN INSERT (Doctor_ID,Qualification)
VALUES (s.Doctor_ID, s.Qualification);

MERGE INTO DOCTOR_QUALIFICATION t
USING (SELECT 'DOC-S10' AS Doctor_ID, 'MBBS (Synthetic teaching record)' AS Qualification FROM dual) s
ON (t.Doctor_ID = s.Doctor_ID AND t.Qualification = s.Qualification)
WHEN NOT MATCHED THEN INSERT (Doctor_ID,Qualification)
VALUES (s.Doctor_ID, s.Qualification);

MERGE INTO DOCTOR_QUALIFICATION t
USING (SELECT 'DOC-S11' AS Doctor_ID, 'MBBS (Synthetic teaching record)' AS Qualification FROM dual) s
ON (t.Doctor_ID = s.Doctor_ID AND t.Qualification = s.Qualification)
WHEN NOT MATCHED THEN INSERT (Doctor_ID,Qualification)
VALUES (s.Doctor_ID, s.Qualification);

MERGE INTO DOCTOR_QUALIFICATION t
USING (SELECT 'DOC-S12' AS Doctor_ID, 'MBBS (Synthetic teaching record)' AS Qualification FROM dual) s
ON (t.Doctor_ID = s.Doctor_ID AND t.Qualification = s.Qualification)
WHEN NOT MATCHED THEN INSERT (Doctor_ID,Qualification)
VALUES (s.Doctor_ID, s.Qualification);

MERGE INTO DOCTOR_QUALIFICATION t
USING (SELECT 'DOC-S13' AS Doctor_ID, 'MBBS (Synthetic teaching record)' AS Qualification FROM dual) s
ON (t.Doctor_ID = s.Doctor_ID AND t.Qualification = s.Qualification)
WHEN NOT MATCHED THEN INSERT (Doctor_ID,Qualification)
VALUES (s.Doctor_ID, s.Qualification);

MERGE INTO DOCTOR_QUALIFICATION t
USING (SELECT 'DOC-S14' AS Doctor_ID, 'MBBS (Synthetic teaching record)' AS Qualification FROM dual) s
ON (t.Doctor_ID = s.Doctor_ID AND t.Qualification = s.Qualification)
WHEN NOT MATCHED THEN INSERT (Doctor_ID,Qualification)
VALUES (s.Doctor_ID, s.Qualification);

MERGE INTO DOCTOR_QUALIFICATION t
USING (SELECT 'DOC-S15' AS Doctor_ID, 'MBBS (Synthetic teaching record)' AS Qualification FROM dual) s
ON (t.Doctor_ID = s.Doctor_ID AND t.Qualification = s.Qualification)
WHEN NOT MATCHED THEN INSERT (Doctor_ID,Qualification)
VALUES (s.Doctor_ID, s.Qualification);

MERGE INTO DOCTOR_QUALIFICATION t
USING (SELECT 'DOC-S16' AS Doctor_ID, 'MBBS (Synthetic teaching record)' AS Qualification FROM dual) s
ON (t.Doctor_ID = s.Doctor_ID AND t.Qualification = s.Qualification)
WHEN NOT MATCHED THEN INSERT (Doctor_ID,Qualification)
VALUES (s.Doctor_ID, s.Qualification);

MERGE INTO DOCTOR_QUALIFICATION t
USING (SELECT 'DOC-S17' AS Doctor_ID, 'MBBS (Synthetic teaching record)' AS Qualification FROM dual) s
ON (t.Doctor_ID = s.Doctor_ID AND t.Qualification = s.Qualification)
WHEN NOT MATCHED THEN INSERT (Doctor_ID,Qualification)
VALUES (s.Doctor_ID, s.Qualification);

-- MEDICAL_LOG: 17 additional synthetic records
MERGE INTO MEDICAL_LOG t
USING (SELECT 'PAT-S01' AS Patient_ID, 1 AS Log_Seq_No, DATE '2026-10-02' AS Log_Date, 'Seasonal allergic rhinitis' AS Diagnosis, NULL AS Attachment_Path FROM dual) s
ON (t.Patient_ID = s.Patient_ID AND t.Log_Seq_No = s.Log_Seq_No)
WHEN NOT MATCHED THEN INSERT (Patient_ID,Log_Seq_No,Log_Date,Diagnosis,Attachment_Path)
VALUES (s.Patient_ID, s.Log_Seq_No, s.Log_Date, s.Diagnosis, s.Attachment_Path);

MERGE INTO MEDICAL_LOG t
USING (SELECT 'PAT-S02' AS Patient_ID, 1 AS Log_Seq_No, DATE '2026-10-03' AS Log_Date, 'Vitamin D deficiency follow-up' AS Diagnosis, NULL AS Attachment_Path FROM dual) s
ON (t.Patient_ID = s.Patient_ID AND t.Log_Seq_No = s.Log_Seq_No)
WHEN NOT MATCHED THEN INSERT (Patient_ID,Log_Seq_No,Log_Date,Diagnosis,Attachment_Path)
VALUES (s.Patient_ID, s.Log_Seq_No, s.Log_Date, s.Diagnosis, s.Attachment_Path);

MERGE INTO MEDICAL_LOG t
USING (SELECT 'PAT-S03' AS Patient_ID, 1 AS Log_Seq_No, DATE '2026-10-04' AS Log_Date, 'Tension headache review' AS Diagnosis, NULL AS Attachment_Path FROM dual) s
ON (t.Patient_ID = s.Patient_ID AND t.Log_Seq_No = s.Log_Seq_No)
WHEN NOT MATCHED THEN INSERT (Patient_ID,Log_Seq_No,Log_Date,Diagnosis,Attachment_Path)
VALUES (s.Patient_ID, s.Log_Seq_No, s.Log_Date, s.Diagnosis, s.Attachment_Path);

MERGE INTO MEDICAL_LOG t
USING (SELECT 'PAT-S04' AS Patient_ID, 1 AS Log_Seq_No, DATE '2026-10-05' AS Log_Date, 'Mild eczema follow-up' AS Diagnosis, NULL AS Attachment_Path FROM dual) s
ON (t.Patient_ID = s.Patient_ID AND t.Log_Seq_No = s.Log_Seq_No)
WHEN NOT MATCHED THEN INSERT (Patient_ID,Log_Seq_No,Log_Date,Diagnosis,Attachment_Path)
VALUES (s.Patient_ID, s.Log_Seq_No, s.Log_Date, s.Diagnosis, s.Attachment_Path);

MERGE INTO MEDICAL_LOG t
USING (SELECT 'PAT-S05' AS Patient_ID, 1 AS Log_Seq_No, DATE '2026-10-06' AS Log_Date, 'Routine wellness review' AS Diagnosis, NULL AS Attachment_Path FROM dual) s
ON (t.Patient_ID = s.Patient_ID AND t.Log_Seq_No = s.Log_Seq_No)
WHEN NOT MATCHED THEN INSERT (Patient_ID,Log_Seq_No,Log_Date,Diagnosis,Attachment_Path)
VALUES (s.Patient_ID, s.Log_Seq_No, s.Log_Date, s.Diagnosis, s.Attachment_Path);

MERGE INTO MEDICAL_LOG t
USING (SELECT 'PAT-S06' AS Patient_ID, 1 AS Log_Seq_No, DATE '2026-10-07' AS Log_Date, 'Seasonal allergic rhinitis' AS Diagnosis, NULL AS Attachment_Path FROM dual) s
ON (t.Patient_ID = s.Patient_ID AND t.Log_Seq_No = s.Log_Seq_No)
WHEN NOT MATCHED THEN INSERT (Patient_ID,Log_Seq_No,Log_Date,Diagnosis,Attachment_Path)
VALUES (s.Patient_ID, s.Log_Seq_No, s.Log_Date, s.Diagnosis, s.Attachment_Path);

MERGE INTO MEDICAL_LOG t
USING (SELECT 'PAT-S07' AS Patient_ID, 1 AS Log_Seq_No, DATE '2026-10-08' AS Log_Date, 'Vitamin D deficiency follow-up' AS Diagnosis, NULL AS Attachment_Path FROM dual) s
ON (t.Patient_ID = s.Patient_ID AND t.Log_Seq_No = s.Log_Seq_No)
WHEN NOT MATCHED THEN INSERT (Patient_ID,Log_Seq_No,Log_Date,Diagnosis,Attachment_Path)
VALUES (s.Patient_ID, s.Log_Seq_No, s.Log_Date, s.Diagnosis, s.Attachment_Path);

MERGE INTO MEDICAL_LOG t
USING (SELECT 'PAT-S08' AS Patient_ID, 1 AS Log_Seq_No, DATE '2026-10-09' AS Log_Date, 'Tension headache review' AS Diagnosis, NULL AS Attachment_Path FROM dual) s
ON (t.Patient_ID = s.Patient_ID AND t.Log_Seq_No = s.Log_Seq_No)
WHEN NOT MATCHED THEN INSERT (Patient_ID,Log_Seq_No,Log_Date,Diagnosis,Attachment_Path)
VALUES (s.Patient_ID, s.Log_Seq_No, s.Log_Date, s.Diagnosis, s.Attachment_Path);

MERGE INTO MEDICAL_LOG t
USING (SELECT 'PAT-S09' AS Patient_ID, 1 AS Log_Seq_No, DATE '2026-10-10' AS Log_Date, 'Mild eczema follow-up' AS Diagnosis, NULL AS Attachment_Path FROM dual) s
ON (t.Patient_ID = s.Patient_ID AND t.Log_Seq_No = s.Log_Seq_No)
WHEN NOT MATCHED THEN INSERT (Patient_ID,Log_Seq_No,Log_Date,Diagnosis,Attachment_Path)
VALUES (s.Patient_ID, s.Log_Seq_No, s.Log_Date, s.Diagnosis, s.Attachment_Path);

MERGE INTO MEDICAL_LOG t
USING (SELECT 'PAT-S10' AS Patient_ID, 1 AS Log_Seq_No, DATE '2026-10-11' AS Log_Date, 'Routine wellness review' AS Diagnosis, NULL AS Attachment_Path FROM dual) s
ON (t.Patient_ID = s.Patient_ID AND t.Log_Seq_No = s.Log_Seq_No)
WHEN NOT MATCHED THEN INSERT (Patient_ID,Log_Seq_No,Log_Date,Diagnosis,Attachment_Path)
VALUES (s.Patient_ID, s.Log_Seq_No, s.Log_Date, s.Diagnosis, s.Attachment_Path);

MERGE INTO MEDICAL_LOG t
USING (SELECT 'PAT-S11' AS Patient_ID, 1 AS Log_Seq_No, DATE '2026-10-12' AS Log_Date, 'Seasonal allergic rhinitis' AS Diagnosis, NULL AS Attachment_Path FROM dual) s
ON (t.Patient_ID = s.Patient_ID AND t.Log_Seq_No = s.Log_Seq_No)
WHEN NOT MATCHED THEN INSERT (Patient_ID,Log_Seq_No,Log_Date,Diagnosis,Attachment_Path)
VALUES (s.Patient_ID, s.Log_Seq_No, s.Log_Date, s.Diagnosis, s.Attachment_Path);

MERGE INTO MEDICAL_LOG t
USING (SELECT 'PAT-S12' AS Patient_ID, 1 AS Log_Seq_No, DATE '2026-10-01' AS Log_Date, 'Vitamin D deficiency follow-up' AS Diagnosis, NULL AS Attachment_Path FROM dual) s
ON (t.Patient_ID = s.Patient_ID AND t.Log_Seq_No = s.Log_Seq_No)
WHEN NOT MATCHED THEN INSERT (Patient_ID,Log_Seq_No,Log_Date,Diagnosis,Attachment_Path)
VALUES (s.Patient_ID, s.Log_Seq_No, s.Log_Date, s.Diagnosis, s.Attachment_Path);

MERGE INTO MEDICAL_LOG t
USING (SELECT 'PAT-S13' AS Patient_ID, 1 AS Log_Seq_No, DATE '2026-10-02' AS Log_Date, 'Tension headache review' AS Diagnosis, NULL AS Attachment_Path FROM dual) s
ON (t.Patient_ID = s.Patient_ID AND t.Log_Seq_No = s.Log_Seq_No)
WHEN NOT MATCHED THEN INSERT (Patient_ID,Log_Seq_No,Log_Date,Diagnosis,Attachment_Path)
VALUES (s.Patient_ID, s.Log_Seq_No, s.Log_Date, s.Diagnosis, s.Attachment_Path);

MERGE INTO MEDICAL_LOG t
USING (SELECT 'PAT-S14' AS Patient_ID, 1 AS Log_Seq_No, DATE '2026-10-03' AS Log_Date, 'Mild eczema follow-up' AS Diagnosis, NULL AS Attachment_Path FROM dual) s
ON (t.Patient_ID = s.Patient_ID AND t.Log_Seq_No = s.Log_Seq_No)
WHEN NOT MATCHED THEN INSERT (Patient_ID,Log_Seq_No,Log_Date,Diagnosis,Attachment_Path)
VALUES (s.Patient_ID, s.Log_Seq_No, s.Log_Date, s.Diagnosis, s.Attachment_Path);

MERGE INTO MEDICAL_LOG t
USING (SELECT 'PAT-S15' AS Patient_ID, 1 AS Log_Seq_No, DATE '2026-10-04' AS Log_Date, 'Routine wellness review' AS Diagnosis, NULL AS Attachment_Path FROM dual) s
ON (t.Patient_ID = s.Patient_ID AND t.Log_Seq_No = s.Log_Seq_No)
WHEN NOT MATCHED THEN INSERT (Patient_ID,Log_Seq_No,Log_Date,Diagnosis,Attachment_Path)
VALUES (s.Patient_ID, s.Log_Seq_No, s.Log_Date, s.Diagnosis, s.Attachment_Path);

MERGE INTO MEDICAL_LOG t
USING (SELECT 'PAT-S16' AS Patient_ID, 1 AS Log_Seq_No, DATE '2026-10-05' AS Log_Date, 'Seasonal allergic rhinitis' AS Diagnosis, NULL AS Attachment_Path FROM dual) s
ON (t.Patient_ID = s.Patient_ID AND t.Log_Seq_No = s.Log_Seq_No)
WHEN NOT MATCHED THEN INSERT (Patient_ID,Log_Seq_No,Log_Date,Diagnosis,Attachment_Path)
VALUES (s.Patient_ID, s.Log_Seq_No, s.Log_Date, s.Diagnosis, s.Attachment_Path);

MERGE INTO MEDICAL_LOG t
USING (SELECT 'PAT-S17' AS Patient_ID, 1 AS Log_Seq_No, DATE '2026-10-06' AS Log_Date, 'Vitamin D deficiency follow-up' AS Diagnosis, NULL AS Attachment_Path FROM dual) s
ON (t.Patient_ID = s.Patient_ID AND t.Log_Seq_No = s.Log_Seq_No)
WHEN NOT MATCHED THEN INSERT (Patient_ID,Log_Seq_No,Log_Date,Diagnosis,Attachment_Path)
VALUES (s.Patient_ID, s.Log_Seq_No, s.Log_Date, s.Diagnosis, s.Attachment_Path);

-- LOG_ALLERGIES: 17 additional synthetic records
MERGE INTO LOG_ALLERGIES t
USING (SELECT 'PAT-S01' AS Patient_ID, 1 AS Log_Seq_No, 'Dust Mites' AS Allergy_Name FROM dual) s
ON (t.Patient_ID = s.Patient_ID AND t.Log_Seq_No = s.Log_Seq_No AND t.Allergy_Name = s.Allergy_Name)
WHEN NOT MATCHED THEN INSERT (Patient_ID,Log_Seq_No,Allergy_Name)
VALUES (s.Patient_ID, s.Log_Seq_No, s.Allergy_Name);

MERGE INTO LOG_ALLERGIES t
USING (SELECT 'PAT-S02' AS Patient_ID, 1 AS Log_Seq_No, 'Pollen' AS Allergy_Name FROM dual) s
ON (t.Patient_ID = s.Patient_ID AND t.Log_Seq_No = s.Log_Seq_No AND t.Allergy_Name = s.Allergy_Name)
WHEN NOT MATCHED THEN INSERT (Patient_ID,Log_Seq_No,Allergy_Name)
VALUES (s.Patient_ID, s.Log_Seq_No, s.Allergy_Name);

MERGE INTO LOG_ALLERGIES t
USING (SELECT 'PAT-S03' AS Patient_ID, 1 AS Log_Seq_No, 'Latex' AS Allergy_Name FROM dual) s
ON (t.Patient_ID = s.Patient_ID AND t.Log_Seq_No = s.Log_Seq_No AND t.Allergy_Name = s.Allergy_Name)
WHEN NOT MATCHED THEN INSERT (Patient_ID,Log_Seq_No,Allergy_Name)
VALUES (s.Patient_ID, s.Log_Seq_No, s.Allergy_Name);

MERGE INTO LOG_ALLERGIES t
USING (SELECT 'PAT-S04' AS Patient_ID, 1 AS Log_Seq_No, 'Peanuts' AS Allergy_Name FROM dual) s
ON (t.Patient_ID = s.Patient_ID AND t.Log_Seq_No = s.Log_Seq_No AND t.Allergy_Name = s.Allergy_Name)
WHEN NOT MATCHED THEN INSERT (Patient_ID,Log_Seq_No,Allergy_Name)
VALUES (s.Patient_ID, s.Log_Seq_No, s.Allergy_Name);

MERGE INTO LOG_ALLERGIES t
USING (SELECT 'PAT-S05' AS Patient_ID, 1 AS Log_Seq_No, 'Shellfish' AS Allergy_Name FROM dual) s
ON (t.Patient_ID = s.Patient_ID AND t.Log_Seq_No = s.Log_Seq_No AND t.Allergy_Name = s.Allergy_Name)
WHEN NOT MATCHED THEN INSERT (Patient_ID,Log_Seq_No,Allergy_Name)
VALUES (s.Patient_ID, s.Log_Seq_No, s.Allergy_Name);

MERGE INTO LOG_ALLERGIES t
USING (SELECT 'PAT-S06' AS Patient_ID, 1 AS Log_Seq_No, 'Dust Mites' AS Allergy_Name FROM dual) s
ON (t.Patient_ID = s.Patient_ID AND t.Log_Seq_No = s.Log_Seq_No AND t.Allergy_Name = s.Allergy_Name)
WHEN NOT MATCHED THEN INSERT (Patient_ID,Log_Seq_No,Allergy_Name)
VALUES (s.Patient_ID, s.Log_Seq_No, s.Allergy_Name);

MERGE INTO LOG_ALLERGIES t
USING (SELECT 'PAT-S07' AS Patient_ID, 1 AS Log_Seq_No, 'Pollen' AS Allergy_Name FROM dual) s
ON (t.Patient_ID = s.Patient_ID AND t.Log_Seq_No = s.Log_Seq_No AND t.Allergy_Name = s.Allergy_Name)
WHEN NOT MATCHED THEN INSERT (Patient_ID,Log_Seq_No,Allergy_Name)
VALUES (s.Patient_ID, s.Log_Seq_No, s.Allergy_Name);

MERGE INTO LOG_ALLERGIES t
USING (SELECT 'PAT-S08' AS Patient_ID, 1 AS Log_Seq_No, 'Latex' AS Allergy_Name FROM dual) s
ON (t.Patient_ID = s.Patient_ID AND t.Log_Seq_No = s.Log_Seq_No AND t.Allergy_Name = s.Allergy_Name)
WHEN NOT MATCHED THEN INSERT (Patient_ID,Log_Seq_No,Allergy_Name)
VALUES (s.Patient_ID, s.Log_Seq_No, s.Allergy_Name);

MERGE INTO LOG_ALLERGIES t
USING (SELECT 'PAT-S09' AS Patient_ID, 1 AS Log_Seq_No, 'Peanuts' AS Allergy_Name FROM dual) s
ON (t.Patient_ID = s.Patient_ID AND t.Log_Seq_No = s.Log_Seq_No AND t.Allergy_Name = s.Allergy_Name)
WHEN NOT MATCHED THEN INSERT (Patient_ID,Log_Seq_No,Allergy_Name)
VALUES (s.Patient_ID, s.Log_Seq_No, s.Allergy_Name);

MERGE INTO LOG_ALLERGIES t
USING (SELECT 'PAT-S10' AS Patient_ID, 1 AS Log_Seq_No, 'Shellfish' AS Allergy_Name FROM dual) s
ON (t.Patient_ID = s.Patient_ID AND t.Log_Seq_No = s.Log_Seq_No AND t.Allergy_Name = s.Allergy_Name)
WHEN NOT MATCHED THEN INSERT (Patient_ID,Log_Seq_No,Allergy_Name)
VALUES (s.Patient_ID, s.Log_Seq_No, s.Allergy_Name);

MERGE INTO LOG_ALLERGIES t
USING (SELECT 'PAT-S11' AS Patient_ID, 1 AS Log_Seq_No, 'Dust Mites' AS Allergy_Name FROM dual) s
ON (t.Patient_ID = s.Patient_ID AND t.Log_Seq_No = s.Log_Seq_No AND t.Allergy_Name = s.Allergy_Name)
WHEN NOT MATCHED THEN INSERT (Patient_ID,Log_Seq_No,Allergy_Name)
VALUES (s.Patient_ID, s.Log_Seq_No, s.Allergy_Name);

MERGE INTO LOG_ALLERGIES t
USING (SELECT 'PAT-S12' AS Patient_ID, 1 AS Log_Seq_No, 'Pollen' AS Allergy_Name FROM dual) s
ON (t.Patient_ID = s.Patient_ID AND t.Log_Seq_No = s.Log_Seq_No AND t.Allergy_Name = s.Allergy_Name)
WHEN NOT MATCHED THEN INSERT (Patient_ID,Log_Seq_No,Allergy_Name)
VALUES (s.Patient_ID, s.Log_Seq_No, s.Allergy_Name);

MERGE INTO LOG_ALLERGIES t
USING (SELECT 'PAT-S13' AS Patient_ID, 1 AS Log_Seq_No, 'Latex' AS Allergy_Name FROM dual) s
ON (t.Patient_ID = s.Patient_ID AND t.Log_Seq_No = s.Log_Seq_No AND t.Allergy_Name = s.Allergy_Name)
WHEN NOT MATCHED THEN INSERT (Patient_ID,Log_Seq_No,Allergy_Name)
VALUES (s.Patient_ID, s.Log_Seq_No, s.Allergy_Name);

MERGE INTO LOG_ALLERGIES t
USING (SELECT 'PAT-S14' AS Patient_ID, 1 AS Log_Seq_No, 'Peanuts' AS Allergy_Name FROM dual) s
ON (t.Patient_ID = s.Patient_ID AND t.Log_Seq_No = s.Log_Seq_No AND t.Allergy_Name = s.Allergy_Name)
WHEN NOT MATCHED THEN INSERT (Patient_ID,Log_Seq_No,Allergy_Name)
VALUES (s.Patient_ID, s.Log_Seq_No, s.Allergy_Name);

MERGE INTO LOG_ALLERGIES t
USING (SELECT 'PAT-S15' AS Patient_ID, 1 AS Log_Seq_No, 'Shellfish' AS Allergy_Name FROM dual) s
ON (t.Patient_ID = s.Patient_ID AND t.Log_Seq_No = s.Log_Seq_No AND t.Allergy_Name = s.Allergy_Name)
WHEN NOT MATCHED THEN INSERT (Patient_ID,Log_Seq_No,Allergy_Name)
VALUES (s.Patient_ID, s.Log_Seq_No, s.Allergy_Name);

MERGE INTO LOG_ALLERGIES t
USING (SELECT 'PAT-S16' AS Patient_ID, 1 AS Log_Seq_No, 'Dust Mites' AS Allergy_Name FROM dual) s
ON (t.Patient_ID = s.Patient_ID AND t.Log_Seq_No = s.Log_Seq_No AND t.Allergy_Name = s.Allergy_Name)
WHEN NOT MATCHED THEN INSERT (Patient_ID,Log_Seq_No,Allergy_Name)
VALUES (s.Patient_ID, s.Log_Seq_No, s.Allergy_Name);

MERGE INTO LOG_ALLERGIES t
USING (SELECT 'PAT-S17' AS Patient_ID, 1 AS Log_Seq_No, 'Pollen' AS Allergy_Name FROM dual) s
ON (t.Patient_ID = s.Patient_ID AND t.Log_Seq_No = s.Log_Seq_No AND t.Allergy_Name = s.Allergy_Name)
WHEN NOT MATCHED THEN INSERT (Patient_ID,Log_Seq_No,Allergy_Name)
VALUES (s.Patient_ID, s.Log_Seq_No, s.Allergy_Name);

-- APPOINTMENT: 17 additional synthetic records
MERGE INTO APPOINTMENT t
USING (SELECT 'APT-S01' AS Appointment_ID, 'PAT-S01' AS Patient_ID, 'DOC-S01' AS Doctor_ID, DATE '2026-10-02' AS Appointment_Date, '10:00 AM' AS Appointment_Time, 'Completed' AS Status, 'Virtual' AS Consultation_Mode, 'https://example.invalid/teaching/room/S01' AS Meeting_Link FROM dual) s
ON (t.Appointment_ID = s.Appointment_ID)
WHEN NOT MATCHED THEN INSERT (Appointment_ID,Patient_ID,Doctor_ID,Appointment_Date,Appointment_Time,Status,Consultation_Mode,Meeting_Link)
VALUES (s.Appointment_ID, s.Patient_ID, s.Doctor_ID, s.Appointment_Date, s.Appointment_Time, s.Status, s.Consultation_Mode, s.Meeting_Link);

MERGE INTO APPOINTMENT t
USING (SELECT 'APT-S02' AS Appointment_ID, 'PAT-S02' AS Patient_ID, 'DOC-S02' AS Doctor_ID, DATE '2026-10-03' AS Appointment_Date, '10:00 AM' AS Appointment_Time, 'Completed' AS Status, 'Virtual' AS Consultation_Mode, 'https://example.invalid/teaching/room/S02' AS Meeting_Link FROM dual) s
ON (t.Appointment_ID = s.Appointment_ID)
WHEN NOT MATCHED THEN INSERT (Appointment_ID,Patient_ID,Doctor_ID,Appointment_Date,Appointment_Time,Status,Consultation_Mode,Meeting_Link)
VALUES (s.Appointment_ID, s.Patient_ID, s.Doctor_ID, s.Appointment_Date, s.Appointment_Time, s.Status, s.Consultation_Mode, s.Meeting_Link);

MERGE INTO APPOINTMENT t
USING (SELECT 'APT-S03' AS Appointment_ID, 'PAT-S03' AS Patient_ID, 'DOC-S03' AS Doctor_ID, DATE '2026-10-04' AS Appointment_Date, '10:00 AM' AS Appointment_Time, 'Completed' AS Status, 'Virtual' AS Consultation_Mode, 'https://example.invalid/teaching/room/S03' AS Meeting_Link FROM dual) s
ON (t.Appointment_ID = s.Appointment_ID)
WHEN NOT MATCHED THEN INSERT (Appointment_ID,Patient_ID,Doctor_ID,Appointment_Date,Appointment_Time,Status,Consultation_Mode,Meeting_Link)
VALUES (s.Appointment_ID, s.Patient_ID, s.Doctor_ID, s.Appointment_Date, s.Appointment_Time, s.Status, s.Consultation_Mode, s.Meeting_Link);

MERGE INTO APPOINTMENT t
USING (SELECT 'APT-S04' AS Appointment_ID, 'PAT-S04' AS Patient_ID, 'DOC-S04' AS Doctor_ID, DATE '2026-10-05' AS Appointment_Date, '10:00 AM' AS Appointment_Time, 'Completed' AS Status, 'Virtual' AS Consultation_Mode, 'https://example.invalid/teaching/room/S04' AS Meeting_Link FROM dual) s
ON (t.Appointment_ID = s.Appointment_ID)
WHEN NOT MATCHED THEN INSERT (Appointment_ID,Patient_ID,Doctor_ID,Appointment_Date,Appointment_Time,Status,Consultation_Mode,Meeting_Link)
VALUES (s.Appointment_ID, s.Patient_ID, s.Doctor_ID, s.Appointment_Date, s.Appointment_Time, s.Status, s.Consultation_Mode, s.Meeting_Link);

MERGE INTO APPOINTMENT t
USING (SELECT 'APT-S05' AS Appointment_ID, 'PAT-S05' AS Patient_ID, 'DOC-S05' AS Doctor_ID, DATE '2026-10-06' AS Appointment_Date, '10:00 AM' AS Appointment_Time, 'Completed' AS Status, 'Virtual' AS Consultation_Mode, 'https://example.invalid/teaching/room/S05' AS Meeting_Link FROM dual) s
ON (t.Appointment_ID = s.Appointment_ID)
WHEN NOT MATCHED THEN INSERT (Appointment_ID,Patient_ID,Doctor_ID,Appointment_Date,Appointment_Time,Status,Consultation_Mode,Meeting_Link)
VALUES (s.Appointment_ID, s.Patient_ID, s.Doctor_ID, s.Appointment_Date, s.Appointment_Time, s.Status, s.Consultation_Mode, s.Meeting_Link);

MERGE INTO APPOINTMENT t
USING (SELECT 'APT-S06' AS Appointment_ID, 'PAT-S06' AS Patient_ID, 'DOC-S06' AS Doctor_ID, DATE '2026-10-07' AS Appointment_Date, '10:00 AM' AS Appointment_Time, 'Completed' AS Status, 'Virtual' AS Consultation_Mode, 'https://example.invalid/teaching/room/S06' AS Meeting_Link FROM dual) s
ON (t.Appointment_ID = s.Appointment_ID)
WHEN NOT MATCHED THEN INSERT (Appointment_ID,Patient_ID,Doctor_ID,Appointment_Date,Appointment_Time,Status,Consultation_Mode,Meeting_Link)
VALUES (s.Appointment_ID, s.Patient_ID, s.Doctor_ID, s.Appointment_Date, s.Appointment_Time, s.Status, s.Consultation_Mode, s.Meeting_Link);

MERGE INTO APPOINTMENT t
USING (SELECT 'APT-S07' AS Appointment_ID, 'PAT-S07' AS Patient_ID, 'DOC-S07' AS Doctor_ID, DATE '2026-10-08' AS Appointment_Date, '10:00 AM' AS Appointment_Time, 'Completed' AS Status, 'Virtual' AS Consultation_Mode, 'https://example.invalid/teaching/room/S07' AS Meeting_Link FROM dual) s
ON (t.Appointment_ID = s.Appointment_ID)
WHEN NOT MATCHED THEN INSERT (Appointment_ID,Patient_ID,Doctor_ID,Appointment_Date,Appointment_Time,Status,Consultation_Mode,Meeting_Link)
VALUES (s.Appointment_ID, s.Patient_ID, s.Doctor_ID, s.Appointment_Date, s.Appointment_Time, s.Status, s.Consultation_Mode, s.Meeting_Link);

MERGE INTO APPOINTMENT t
USING (SELECT 'APT-S08' AS Appointment_ID, 'PAT-S08' AS Patient_ID, 'DOC-S08' AS Doctor_ID, DATE '2026-10-09' AS Appointment_Date, '10:00 AM' AS Appointment_Time, 'Completed' AS Status, 'Virtual' AS Consultation_Mode, 'https://example.invalid/teaching/room/S08' AS Meeting_Link FROM dual) s
ON (t.Appointment_ID = s.Appointment_ID)
WHEN NOT MATCHED THEN INSERT (Appointment_ID,Patient_ID,Doctor_ID,Appointment_Date,Appointment_Time,Status,Consultation_Mode,Meeting_Link)
VALUES (s.Appointment_ID, s.Patient_ID, s.Doctor_ID, s.Appointment_Date, s.Appointment_Time, s.Status, s.Consultation_Mode, s.Meeting_Link);

MERGE INTO APPOINTMENT t
USING (SELECT 'APT-S09' AS Appointment_ID, 'PAT-S09' AS Patient_ID, 'DOC-S09' AS Doctor_ID, DATE '2026-10-10' AS Appointment_Date, '10:00 AM' AS Appointment_Time, 'Completed' AS Status, 'Virtual' AS Consultation_Mode, 'https://example.invalid/teaching/room/S09' AS Meeting_Link FROM dual) s
ON (t.Appointment_ID = s.Appointment_ID)
WHEN NOT MATCHED THEN INSERT (Appointment_ID,Patient_ID,Doctor_ID,Appointment_Date,Appointment_Time,Status,Consultation_Mode,Meeting_Link)
VALUES (s.Appointment_ID, s.Patient_ID, s.Doctor_ID, s.Appointment_Date, s.Appointment_Time, s.Status, s.Consultation_Mode, s.Meeting_Link);

MERGE INTO APPOINTMENT t
USING (SELECT 'APT-S10' AS Appointment_ID, 'PAT-S10' AS Patient_ID, 'DOC-S10' AS Doctor_ID, DATE '2026-10-11' AS Appointment_Date, '10:00 AM' AS Appointment_Time, 'Completed' AS Status, 'Virtual' AS Consultation_Mode, 'https://example.invalid/teaching/room/S10' AS Meeting_Link FROM dual) s
ON (t.Appointment_ID = s.Appointment_ID)
WHEN NOT MATCHED THEN INSERT (Appointment_ID,Patient_ID,Doctor_ID,Appointment_Date,Appointment_Time,Status,Consultation_Mode,Meeting_Link)
VALUES (s.Appointment_ID, s.Patient_ID, s.Doctor_ID, s.Appointment_Date, s.Appointment_Time, s.Status, s.Consultation_Mode, s.Meeting_Link);

MERGE INTO APPOINTMENT t
USING (SELECT 'APT-S11' AS Appointment_ID, 'PAT-S11' AS Patient_ID, 'DOC-S11' AS Doctor_ID, DATE '2026-10-12' AS Appointment_Date, '10:00 AM' AS Appointment_Time, 'Completed' AS Status, 'Virtual' AS Consultation_Mode, 'https://example.invalid/teaching/room/S11' AS Meeting_Link FROM dual) s
ON (t.Appointment_ID = s.Appointment_ID)
WHEN NOT MATCHED THEN INSERT (Appointment_ID,Patient_ID,Doctor_ID,Appointment_Date,Appointment_Time,Status,Consultation_Mode,Meeting_Link)
VALUES (s.Appointment_ID, s.Patient_ID, s.Doctor_ID, s.Appointment_Date, s.Appointment_Time, s.Status, s.Consultation_Mode, s.Meeting_Link);

MERGE INTO APPOINTMENT t
USING (SELECT 'APT-S12' AS Appointment_ID, 'PAT-S12' AS Patient_ID, 'DOC-S12' AS Doctor_ID, DATE '2026-10-01' AS Appointment_Date, '10:00 AM' AS Appointment_Time, 'Completed' AS Status, 'Virtual' AS Consultation_Mode, 'https://example.invalid/teaching/room/S12' AS Meeting_Link FROM dual) s
ON (t.Appointment_ID = s.Appointment_ID)
WHEN NOT MATCHED THEN INSERT (Appointment_ID,Patient_ID,Doctor_ID,Appointment_Date,Appointment_Time,Status,Consultation_Mode,Meeting_Link)
VALUES (s.Appointment_ID, s.Patient_ID, s.Doctor_ID, s.Appointment_Date, s.Appointment_Time, s.Status, s.Consultation_Mode, s.Meeting_Link);

MERGE INTO APPOINTMENT t
USING (SELECT 'APT-S13' AS Appointment_ID, 'PAT-S13' AS Patient_ID, 'DOC-S13' AS Doctor_ID, DATE '2026-10-02' AS Appointment_Date, '10:00 AM' AS Appointment_Time, 'Completed' AS Status, 'Virtual' AS Consultation_Mode, 'https://example.invalid/teaching/room/S13' AS Meeting_Link FROM dual) s
ON (t.Appointment_ID = s.Appointment_ID)
WHEN NOT MATCHED THEN INSERT (Appointment_ID,Patient_ID,Doctor_ID,Appointment_Date,Appointment_Time,Status,Consultation_Mode,Meeting_Link)
VALUES (s.Appointment_ID, s.Patient_ID, s.Doctor_ID, s.Appointment_Date, s.Appointment_Time, s.Status, s.Consultation_Mode, s.Meeting_Link);

MERGE INTO APPOINTMENT t
USING (SELECT 'APT-S14' AS Appointment_ID, 'PAT-S14' AS Patient_ID, 'DOC-S14' AS Doctor_ID, DATE '2026-10-03' AS Appointment_Date, '10:00 AM' AS Appointment_Time, 'Completed' AS Status, 'Virtual' AS Consultation_Mode, 'https://example.invalid/teaching/room/S14' AS Meeting_Link FROM dual) s
ON (t.Appointment_ID = s.Appointment_ID)
WHEN NOT MATCHED THEN INSERT (Appointment_ID,Patient_ID,Doctor_ID,Appointment_Date,Appointment_Time,Status,Consultation_Mode,Meeting_Link)
VALUES (s.Appointment_ID, s.Patient_ID, s.Doctor_ID, s.Appointment_Date, s.Appointment_Time, s.Status, s.Consultation_Mode, s.Meeting_Link);

MERGE INTO APPOINTMENT t
USING (SELECT 'APT-S15' AS Appointment_ID, 'PAT-S15' AS Patient_ID, 'DOC-S15' AS Doctor_ID, DATE '2026-10-04' AS Appointment_Date, '10:00 AM' AS Appointment_Time, 'Completed' AS Status, 'Virtual' AS Consultation_Mode, 'https://example.invalid/teaching/room/S15' AS Meeting_Link FROM dual) s
ON (t.Appointment_ID = s.Appointment_ID)
WHEN NOT MATCHED THEN INSERT (Appointment_ID,Patient_ID,Doctor_ID,Appointment_Date,Appointment_Time,Status,Consultation_Mode,Meeting_Link)
VALUES (s.Appointment_ID, s.Patient_ID, s.Doctor_ID, s.Appointment_Date, s.Appointment_Time, s.Status, s.Consultation_Mode, s.Meeting_Link);

MERGE INTO APPOINTMENT t
USING (SELECT 'APT-S16' AS Appointment_ID, 'PAT-S16' AS Patient_ID, 'DOC-S16' AS Doctor_ID, DATE '2026-10-05' AS Appointment_Date, '10:00 AM' AS Appointment_Time, 'Completed' AS Status, 'Virtual' AS Consultation_Mode, 'https://example.invalid/teaching/room/S16' AS Meeting_Link FROM dual) s
ON (t.Appointment_ID = s.Appointment_ID)
WHEN NOT MATCHED THEN INSERT (Appointment_ID,Patient_ID,Doctor_ID,Appointment_Date,Appointment_Time,Status,Consultation_Mode,Meeting_Link)
VALUES (s.Appointment_ID, s.Patient_ID, s.Doctor_ID, s.Appointment_Date, s.Appointment_Time, s.Status, s.Consultation_Mode, s.Meeting_Link);

MERGE INTO APPOINTMENT t
USING (SELECT 'APT-S17' AS Appointment_ID, 'PAT-S17' AS Patient_ID, 'DOC-S17' AS Doctor_ID, DATE '2026-10-06' AS Appointment_Date, '10:00 AM' AS Appointment_Time, 'Completed' AS Status, 'Virtual' AS Consultation_Mode, 'https://example.invalid/teaching/room/S17' AS Meeting_Link FROM dual) s
ON (t.Appointment_ID = s.Appointment_ID)
WHEN NOT MATCHED THEN INSERT (Appointment_ID,Patient_ID,Doctor_ID,Appointment_Date,Appointment_Time,Status,Consultation_Mode,Meeting_Link)
VALUES (s.Appointment_ID, s.Patient_ID, s.Doctor_ID, s.Appointment_Date, s.Appointment_Time, s.Status, s.Consultation_Mode, s.Meeting_Link);

-- TELEMEDICINE_SESSION: 17 additional synthetic records
MERGE INTO TELEMEDICINE_SESSION t
USING (SELECT 'APT-S01' AS Appointment_ID, 'SES-S01' AS Session_ID, DATE '2026-10-02' + 10/24 AS Start_Time, DATE '2026-10-02' + 10/24 + 20/1440 AS End_Time, 'Good' AS Network_Quality_Log, NULL AS Chat_Transcript_URL FROM dual) s
ON (t.Appointment_ID = s.Appointment_ID AND t.Session_ID = s.Session_ID)
WHEN NOT MATCHED THEN INSERT (Appointment_ID,Session_ID,Start_Time,End_Time,Network_Quality_Log,Chat_Transcript_URL)
VALUES (s.Appointment_ID, s.Session_ID, s.Start_Time, s.End_Time, s.Network_Quality_Log, s.Chat_Transcript_URL);

UPDATE TELEMEDICINE_SESSION SET Start_Time = DATE '2026-10-02' + 10/24, End_Time = DATE '2026-10-02' + 10/24 + 20/1440, Network_Quality_Log = 'Good'
WHERE Appointment_ID = 'APT-S01' AND Session_ID = 'SES-S01' AND Network_Quality_Log = 'Session created automatically';

MERGE INTO TELEMEDICINE_SESSION t
USING (SELECT 'APT-S02' AS Appointment_ID, 'SES-S02' AS Session_ID, DATE '2026-10-03' + 10/24 AS Start_Time, DATE '2026-10-03' + 10/24 + 20/1440 AS End_Time, 'Good' AS Network_Quality_Log, NULL AS Chat_Transcript_URL FROM dual) s
ON (t.Appointment_ID = s.Appointment_ID AND t.Session_ID = s.Session_ID)
WHEN NOT MATCHED THEN INSERT (Appointment_ID,Session_ID,Start_Time,End_Time,Network_Quality_Log,Chat_Transcript_URL)
VALUES (s.Appointment_ID, s.Session_ID, s.Start_Time, s.End_Time, s.Network_Quality_Log, s.Chat_Transcript_URL);

UPDATE TELEMEDICINE_SESSION SET Start_Time = DATE '2026-10-03' + 10/24, End_Time = DATE '2026-10-03' + 10/24 + 20/1440, Network_Quality_Log = 'Good'
WHERE Appointment_ID = 'APT-S02' AND Session_ID = 'SES-S02' AND Network_Quality_Log = 'Session created automatically';

MERGE INTO TELEMEDICINE_SESSION t
USING (SELECT 'APT-S03' AS Appointment_ID, 'SES-S03' AS Session_ID, DATE '2026-10-04' + 10/24 AS Start_Time, DATE '2026-10-04' + 10/24 + 20/1440 AS End_Time, 'Good' AS Network_Quality_Log, NULL AS Chat_Transcript_URL FROM dual) s
ON (t.Appointment_ID = s.Appointment_ID AND t.Session_ID = s.Session_ID)
WHEN NOT MATCHED THEN INSERT (Appointment_ID,Session_ID,Start_Time,End_Time,Network_Quality_Log,Chat_Transcript_URL)
VALUES (s.Appointment_ID, s.Session_ID, s.Start_Time, s.End_Time, s.Network_Quality_Log, s.Chat_Transcript_URL);

UPDATE TELEMEDICINE_SESSION SET Start_Time = DATE '2026-10-04' + 10/24, End_Time = DATE '2026-10-04' + 10/24 + 20/1440, Network_Quality_Log = 'Good'
WHERE Appointment_ID = 'APT-S03' AND Session_ID = 'SES-S03' AND Network_Quality_Log = 'Session created automatically';

MERGE INTO TELEMEDICINE_SESSION t
USING (SELECT 'APT-S04' AS Appointment_ID, 'SES-S04' AS Session_ID, DATE '2026-10-05' + 10/24 AS Start_Time, DATE '2026-10-05' + 10/24 + 20/1440 AS End_Time, 'Good' AS Network_Quality_Log, NULL AS Chat_Transcript_URL FROM dual) s
ON (t.Appointment_ID = s.Appointment_ID AND t.Session_ID = s.Session_ID)
WHEN NOT MATCHED THEN INSERT (Appointment_ID,Session_ID,Start_Time,End_Time,Network_Quality_Log,Chat_Transcript_URL)
VALUES (s.Appointment_ID, s.Session_ID, s.Start_Time, s.End_Time, s.Network_Quality_Log, s.Chat_Transcript_URL);

UPDATE TELEMEDICINE_SESSION SET Start_Time = DATE '2026-10-05' + 10/24, End_Time = DATE '2026-10-05' + 10/24 + 20/1440, Network_Quality_Log = 'Good'
WHERE Appointment_ID = 'APT-S04' AND Session_ID = 'SES-S04' AND Network_Quality_Log = 'Session created automatically';

MERGE INTO TELEMEDICINE_SESSION t
USING (SELECT 'APT-S05' AS Appointment_ID, 'SES-S05' AS Session_ID, DATE '2026-10-06' + 10/24 AS Start_Time, DATE '2026-10-06' + 10/24 + 20/1440 AS End_Time, 'Good' AS Network_Quality_Log, NULL AS Chat_Transcript_URL FROM dual) s
ON (t.Appointment_ID = s.Appointment_ID AND t.Session_ID = s.Session_ID)
WHEN NOT MATCHED THEN INSERT (Appointment_ID,Session_ID,Start_Time,End_Time,Network_Quality_Log,Chat_Transcript_URL)
VALUES (s.Appointment_ID, s.Session_ID, s.Start_Time, s.End_Time, s.Network_Quality_Log, s.Chat_Transcript_URL);

UPDATE TELEMEDICINE_SESSION SET Start_Time = DATE '2026-10-06' + 10/24, End_Time = DATE '2026-10-06' + 10/24 + 20/1440, Network_Quality_Log = 'Good'
WHERE Appointment_ID = 'APT-S05' AND Session_ID = 'SES-S05' AND Network_Quality_Log = 'Session created automatically';

MERGE INTO TELEMEDICINE_SESSION t
USING (SELECT 'APT-S06' AS Appointment_ID, 'SES-S06' AS Session_ID, DATE '2026-10-07' + 10/24 AS Start_Time, DATE '2026-10-07' + 10/24 + 20/1440 AS End_Time, 'Good' AS Network_Quality_Log, NULL AS Chat_Transcript_URL FROM dual) s
ON (t.Appointment_ID = s.Appointment_ID AND t.Session_ID = s.Session_ID)
WHEN NOT MATCHED THEN INSERT (Appointment_ID,Session_ID,Start_Time,End_Time,Network_Quality_Log,Chat_Transcript_URL)
VALUES (s.Appointment_ID, s.Session_ID, s.Start_Time, s.End_Time, s.Network_Quality_Log, s.Chat_Transcript_URL);

UPDATE TELEMEDICINE_SESSION SET Start_Time = DATE '2026-10-07' + 10/24, End_Time = DATE '2026-10-07' + 10/24 + 20/1440, Network_Quality_Log = 'Good'
WHERE Appointment_ID = 'APT-S06' AND Session_ID = 'SES-S06' AND Network_Quality_Log = 'Session created automatically';

MERGE INTO TELEMEDICINE_SESSION t
USING (SELECT 'APT-S07' AS Appointment_ID, 'SES-S07' AS Session_ID, DATE '2026-10-08' + 10/24 AS Start_Time, DATE '2026-10-08' + 10/24 + 20/1440 AS End_Time, 'Good' AS Network_Quality_Log, NULL AS Chat_Transcript_URL FROM dual) s
ON (t.Appointment_ID = s.Appointment_ID AND t.Session_ID = s.Session_ID)
WHEN NOT MATCHED THEN INSERT (Appointment_ID,Session_ID,Start_Time,End_Time,Network_Quality_Log,Chat_Transcript_URL)
VALUES (s.Appointment_ID, s.Session_ID, s.Start_Time, s.End_Time, s.Network_Quality_Log, s.Chat_Transcript_URL);

UPDATE TELEMEDICINE_SESSION SET Start_Time = DATE '2026-10-08' + 10/24, End_Time = DATE '2026-10-08' + 10/24 + 20/1440, Network_Quality_Log = 'Good'
WHERE Appointment_ID = 'APT-S07' AND Session_ID = 'SES-S07' AND Network_Quality_Log = 'Session created automatically';

MERGE INTO TELEMEDICINE_SESSION t
USING (SELECT 'APT-S08' AS Appointment_ID, 'SES-S08' AS Session_ID, DATE '2026-10-09' + 10/24 AS Start_Time, DATE '2026-10-09' + 10/24 + 20/1440 AS End_Time, 'Good' AS Network_Quality_Log, NULL AS Chat_Transcript_URL FROM dual) s
ON (t.Appointment_ID = s.Appointment_ID AND t.Session_ID = s.Session_ID)
WHEN NOT MATCHED THEN INSERT (Appointment_ID,Session_ID,Start_Time,End_Time,Network_Quality_Log,Chat_Transcript_URL)
VALUES (s.Appointment_ID, s.Session_ID, s.Start_Time, s.End_Time, s.Network_Quality_Log, s.Chat_Transcript_URL);

UPDATE TELEMEDICINE_SESSION SET Start_Time = DATE '2026-10-09' + 10/24, End_Time = DATE '2026-10-09' + 10/24 + 20/1440, Network_Quality_Log = 'Good'
WHERE Appointment_ID = 'APT-S08' AND Session_ID = 'SES-S08' AND Network_Quality_Log = 'Session created automatically';

MERGE INTO TELEMEDICINE_SESSION t
USING (SELECT 'APT-S09' AS Appointment_ID, 'SES-S09' AS Session_ID, DATE '2026-10-10' + 10/24 AS Start_Time, DATE '2026-10-10' + 10/24 + 20/1440 AS End_Time, 'Good' AS Network_Quality_Log, NULL AS Chat_Transcript_URL FROM dual) s
ON (t.Appointment_ID = s.Appointment_ID AND t.Session_ID = s.Session_ID)
WHEN NOT MATCHED THEN INSERT (Appointment_ID,Session_ID,Start_Time,End_Time,Network_Quality_Log,Chat_Transcript_URL)
VALUES (s.Appointment_ID, s.Session_ID, s.Start_Time, s.End_Time, s.Network_Quality_Log, s.Chat_Transcript_URL);

UPDATE TELEMEDICINE_SESSION SET Start_Time = DATE '2026-10-10' + 10/24, End_Time = DATE '2026-10-10' + 10/24 + 20/1440, Network_Quality_Log = 'Good'
WHERE Appointment_ID = 'APT-S09' AND Session_ID = 'SES-S09' AND Network_Quality_Log = 'Session created automatically';

MERGE INTO TELEMEDICINE_SESSION t
USING (SELECT 'APT-S10' AS Appointment_ID, 'SES-S10' AS Session_ID, DATE '2026-10-11' + 10/24 AS Start_Time, DATE '2026-10-11' + 10/24 + 20/1440 AS End_Time, 'Good' AS Network_Quality_Log, NULL AS Chat_Transcript_URL FROM dual) s
ON (t.Appointment_ID = s.Appointment_ID AND t.Session_ID = s.Session_ID)
WHEN NOT MATCHED THEN INSERT (Appointment_ID,Session_ID,Start_Time,End_Time,Network_Quality_Log,Chat_Transcript_URL)
VALUES (s.Appointment_ID, s.Session_ID, s.Start_Time, s.End_Time, s.Network_Quality_Log, s.Chat_Transcript_URL);

UPDATE TELEMEDICINE_SESSION SET Start_Time = DATE '2026-10-11' + 10/24, End_Time = DATE '2026-10-11' + 10/24 + 20/1440, Network_Quality_Log = 'Good'
WHERE Appointment_ID = 'APT-S10' AND Session_ID = 'SES-S10' AND Network_Quality_Log = 'Session created automatically';

MERGE INTO TELEMEDICINE_SESSION t
USING (SELECT 'APT-S11' AS Appointment_ID, 'SES-S11' AS Session_ID, DATE '2026-10-12' + 10/24 AS Start_Time, DATE '2026-10-12' + 10/24 + 20/1440 AS End_Time, 'Good' AS Network_Quality_Log, NULL AS Chat_Transcript_URL FROM dual) s
ON (t.Appointment_ID = s.Appointment_ID AND t.Session_ID = s.Session_ID)
WHEN NOT MATCHED THEN INSERT (Appointment_ID,Session_ID,Start_Time,End_Time,Network_Quality_Log,Chat_Transcript_URL)
VALUES (s.Appointment_ID, s.Session_ID, s.Start_Time, s.End_Time, s.Network_Quality_Log, s.Chat_Transcript_URL);

UPDATE TELEMEDICINE_SESSION SET Start_Time = DATE '2026-10-12' + 10/24, End_Time = DATE '2026-10-12' + 10/24 + 20/1440, Network_Quality_Log = 'Good'
WHERE Appointment_ID = 'APT-S11' AND Session_ID = 'SES-S11' AND Network_Quality_Log = 'Session created automatically';

MERGE INTO TELEMEDICINE_SESSION t
USING (SELECT 'APT-S12' AS Appointment_ID, 'SES-S12' AS Session_ID, DATE '2026-10-01' + 10/24 AS Start_Time, DATE '2026-10-01' + 10/24 + 20/1440 AS End_Time, 'Good' AS Network_Quality_Log, NULL AS Chat_Transcript_URL FROM dual) s
ON (t.Appointment_ID = s.Appointment_ID AND t.Session_ID = s.Session_ID)
WHEN NOT MATCHED THEN INSERT (Appointment_ID,Session_ID,Start_Time,End_Time,Network_Quality_Log,Chat_Transcript_URL)
VALUES (s.Appointment_ID, s.Session_ID, s.Start_Time, s.End_Time, s.Network_Quality_Log, s.Chat_Transcript_URL);

UPDATE TELEMEDICINE_SESSION SET Start_Time = DATE '2026-10-01' + 10/24, End_Time = DATE '2026-10-01' + 10/24 + 20/1440, Network_Quality_Log = 'Good'
WHERE Appointment_ID = 'APT-S12' AND Session_ID = 'SES-S12' AND Network_Quality_Log = 'Session created automatically';

MERGE INTO TELEMEDICINE_SESSION t
USING (SELECT 'APT-S13' AS Appointment_ID, 'SES-S13' AS Session_ID, DATE '2026-10-02' + 10/24 AS Start_Time, DATE '2026-10-02' + 10/24 + 20/1440 AS End_Time, 'Good' AS Network_Quality_Log, NULL AS Chat_Transcript_URL FROM dual) s
ON (t.Appointment_ID = s.Appointment_ID AND t.Session_ID = s.Session_ID)
WHEN NOT MATCHED THEN INSERT (Appointment_ID,Session_ID,Start_Time,End_Time,Network_Quality_Log,Chat_Transcript_URL)
VALUES (s.Appointment_ID, s.Session_ID, s.Start_Time, s.End_Time, s.Network_Quality_Log, s.Chat_Transcript_URL);

UPDATE TELEMEDICINE_SESSION SET Start_Time = DATE '2026-10-02' + 10/24, End_Time = DATE '2026-10-02' + 10/24 + 20/1440, Network_Quality_Log = 'Good'
WHERE Appointment_ID = 'APT-S13' AND Session_ID = 'SES-S13' AND Network_Quality_Log = 'Session created automatically';

MERGE INTO TELEMEDICINE_SESSION t
USING (SELECT 'APT-S14' AS Appointment_ID, 'SES-S14' AS Session_ID, DATE '2026-10-03' + 10/24 AS Start_Time, DATE '2026-10-03' + 10/24 + 20/1440 AS End_Time, 'Good' AS Network_Quality_Log, NULL AS Chat_Transcript_URL FROM dual) s
ON (t.Appointment_ID = s.Appointment_ID AND t.Session_ID = s.Session_ID)
WHEN NOT MATCHED THEN INSERT (Appointment_ID,Session_ID,Start_Time,End_Time,Network_Quality_Log,Chat_Transcript_URL)
VALUES (s.Appointment_ID, s.Session_ID, s.Start_Time, s.End_Time, s.Network_Quality_Log, s.Chat_Transcript_URL);

UPDATE TELEMEDICINE_SESSION SET Start_Time = DATE '2026-10-03' + 10/24, End_Time = DATE '2026-10-03' + 10/24 + 20/1440, Network_Quality_Log = 'Good'
WHERE Appointment_ID = 'APT-S14' AND Session_ID = 'SES-S14' AND Network_Quality_Log = 'Session created automatically';

MERGE INTO TELEMEDICINE_SESSION t
USING (SELECT 'APT-S15' AS Appointment_ID, 'SES-S15' AS Session_ID, DATE '2026-10-04' + 10/24 AS Start_Time, DATE '2026-10-04' + 10/24 + 20/1440 AS End_Time, 'Good' AS Network_Quality_Log, NULL AS Chat_Transcript_URL FROM dual) s
ON (t.Appointment_ID = s.Appointment_ID AND t.Session_ID = s.Session_ID)
WHEN NOT MATCHED THEN INSERT (Appointment_ID,Session_ID,Start_Time,End_Time,Network_Quality_Log,Chat_Transcript_URL)
VALUES (s.Appointment_ID, s.Session_ID, s.Start_Time, s.End_Time, s.Network_Quality_Log, s.Chat_Transcript_URL);

UPDATE TELEMEDICINE_SESSION SET Start_Time = DATE '2026-10-04' + 10/24, End_Time = DATE '2026-10-04' + 10/24 + 20/1440, Network_Quality_Log = 'Good'
WHERE Appointment_ID = 'APT-S15' AND Session_ID = 'SES-S15' AND Network_Quality_Log = 'Session created automatically';

MERGE INTO TELEMEDICINE_SESSION t
USING (SELECT 'APT-S16' AS Appointment_ID, 'SES-S16' AS Session_ID, DATE '2026-10-05' + 10/24 AS Start_Time, DATE '2026-10-05' + 10/24 + 20/1440 AS End_Time, 'Good' AS Network_Quality_Log, NULL AS Chat_Transcript_URL FROM dual) s
ON (t.Appointment_ID = s.Appointment_ID AND t.Session_ID = s.Session_ID)
WHEN NOT MATCHED THEN INSERT (Appointment_ID,Session_ID,Start_Time,End_Time,Network_Quality_Log,Chat_Transcript_URL)
VALUES (s.Appointment_ID, s.Session_ID, s.Start_Time, s.End_Time, s.Network_Quality_Log, s.Chat_Transcript_URL);

UPDATE TELEMEDICINE_SESSION SET Start_Time = DATE '2026-10-05' + 10/24, End_Time = DATE '2026-10-05' + 10/24 + 20/1440, Network_Quality_Log = 'Good'
WHERE Appointment_ID = 'APT-S16' AND Session_ID = 'SES-S16' AND Network_Quality_Log = 'Session created automatically';

MERGE INTO TELEMEDICINE_SESSION t
USING (SELECT 'APT-S17' AS Appointment_ID, 'SES-S17' AS Session_ID, DATE '2026-10-06' + 10/24 AS Start_Time, DATE '2026-10-06' + 10/24 + 20/1440 AS End_Time, 'Good' AS Network_Quality_Log, NULL AS Chat_Transcript_URL FROM dual) s
ON (t.Appointment_ID = s.Appointment_ID AND t.Session_ID = s.Session_ID)
WHEN NOT MATCHED THEN INSERT (Appointment_ID,Session_ID,Start_Time,End_Time,Network_Quality_Log,Chat_Transcript_URL)
VALUES (s.Appointment_ID, s.Session_ID, s.Start_Time, s.End_Time, s.Network_Quality_Log, s.Chat_Transcript_URL);

UPDATE TELEMEDICINE_SESSION SET Start_Time = DATE '2026-10-06' + 10/24, End_Time = DATE '2026-10-06' + 10/24 + 20/1440, Network_Quality_Log = 'Good'
WHERE Appointment_ID = 'APT-S17' AND Session_ID = 'SES-S17' AND Network_Quality_Log = 'Session created automatically';

-- PRESCRIPTION: 17 additional synthetic records
MERGE INTO PRESCRIPTION t
USING (SELECT 'APT-S01' AS Appointment_ID, 'RX-S01' AS Prescription_No, 'PHARM-S01' AS Pharmacy_ID, DATE '2026-10-02' AS Issue_Date, 'Synthetic academic example; not clinical advice' AS Notes FROM dual) s
ON (t.Appointment_ID = s.Appointment_ID AND t.Prescription_No = s.Prescription_No)
WHEN NOT MATCHED THEN INSERT (Appointment_ID,Prescription_No,Pharmacy_ID,Issue_Date,Notes)
VALUES (s.Appointment_ID, s.Prescription_No, s.Pharmacy_ID, s.Issue_Date, s.Notes);

MERGE INTO PRESCRIPTION t
USING (SELECT 'APT-S02' AS Appointment_ID, 'RX-S02' AS Prescription_No, 'PHARM-S02' AS Pharmacy_ID, DATE '2026-10-03' AS Issue_Date, 'Synthetic academic example; not clinical advice' AS Notes FROM dual) s
ON (t.Appointment_ID = s.Appointment_ID AND t.Prescription_No = s.Prescription_No)
WHEN NOT MATCHED THEN INSERT (Appointment_ID,Prescription_No,Pharmacy_ID,Issue_Date,Notes)
VALUES (s.Appointment_ID, s.Prescription_No, s.Pharmacy_ID, s.Issue_Date, s.Notes);

MERGE INTO PRESCRIPTION t
USING (SELECT 'APT-S03' AS Appointment_ID, 'RX-S03' AS Prescription_No, 'PHARM-S03' AS Pharmacy_ID, DATE '2026-10-04' AS Issue_Date, 'Synthetic academic example; not clinical advice' AS Notes FROM dual) s
ON (t.Appointment_ID = s.Appointment_ID AND t.Prescription_No = s.Prescription_No)
WHEN NOT MATCHED THEN INSERT (Appointment_ID,Prescription_No,Pharmacy_ID,Issue_Date,Notes)
VALUES (s.Appointment_ID, s.Prescription_No, s.Pharmacy_ID, s.Issue_Date, s.Notes);

MERGE INTO PRESCRIPTION t
USING (SELECT 'APT-S04' AS Appointment_ID, 'RX-S04' AS Prescription_No, 'PHARM-S04' AS Pharmacy_ID, DATE '2026-10-05' AS Issue_Date, 'Synthetic academic example; not clinical advice' AS Notes FROM dual) s
ON (t.Appointment_ID = s.Appointment_ID AND t.Prescription_No = s.Prescription_No)
WHEN NOT MATCHED THEN INSERT (Appointment_ID,Prescription_No,Pharmacy_ID,Issue_Date,Notes)
VALUES (s.Appointment_ID, s.Prescription_No, s.Pharmacy_ID, s.Issue_Date, s.Notes);

MERGE INTO PRESCRIPTION t
USING (SELECT 'APT-S05' AS Appointment_ID, 'RX-S05' AS Prescription_No, 'PHARM-S05' AS Pharmacy_ID, DATE '2026-10-06' AS Issue_Date, 'Synthetic academic example; not clinical advice' AS Notes FROM dual) s
ON (t.Appointment_ID = s.Appointment_ID AND t.Prescription_No = s.Prescription_No)
WHEN NOT MATCHED THEN INSERT (Appointment_ID,Prescription_No,Pharmacy_ID,Issue_Date,Notes)
VALUES (s.Appointment_ID, s.Prescription_No, s.Pharmacy_ID, s.Issue_Date, s.Notes);

MERGE INTO PRESCRIPTION t
USING (SELECT 'APT-S06' AS Appointment_ID, 'RX-S06' AS Prescription_No, 'PHARM-S06' AS Pharmacy_ID, DATE '2026-10-07' AS Issue_Date, 'Synthetic academic example; not clinical advice' AS Notes FROM dual) s
ON (t.Appointment_ID = s.Appointment_ID AND t.Prescription_No = s.Prescription_No)
WHEN NOT MATCHED THEN INSERT (Appointment_ID,Prescription_No,Pharmacy_ID,Issue_Date,Notes)
VALUES (s.Appointment_ID, s.Prescription_No, s.Pharmacy_ID, s.Issue_Date, s.Notes);

MERGE INTO PRESCRIPTION t
USING (SELECT 'APT-S07' AS Appointment_ID, 'RX-S07' AS Prescription_No, 'PHARM-S07' AS Pharmacy_ID, DATE '2026-10-08' AS Issue_Date, 'Synthetic academic example; not clinical advice' AS Notes FROM dual) s
ON (t.Appointment_ID = s.Appointment_ID AND t.Prescription_No = s.Prescription_No)
WHEN NOT MATCHED THEN INSERT (Appointment_ID,Prescription_No,Pharmacy_ID,Issue_Date,Notes)
VALUES (s.Appointment_ID, s.Prescription_No, s.Pharmacy_ID, s.Issue_Date, s.Notes);

MERGE INTO PRESCRIPTION t
USING (SELECT 'APT-S08' AS Appointment_ID, 'RX-S08' AS Prescription_No, 'PHARM-S08' AS Pharmacy_ID, DATE '2026-10-09' AS Issue_Date, 'Synthetic academic example; not clinical advice' AS Notes FROM dual) s
ON (t.Appointment_ID = s.Appointment_ID AND t.Prescription_No = s.Prescription_No)
WHEN NOT MATCHED THEN INSERT (Appointment_ID,Prescription_No,Pharmacy_ID,Issue_Date,Notes)
VALUES (s.Appointment_ID, s.Prescription_No, s.Pharmacy_ID, s.Issue_Date, s.Notes);

MERGE INTO PRESCRIPTION t
USING (SELECT 'APT-S09' AS Appointment_ID, 'RX-S09' AS Prescription_No, 'PHARM-S09' AS Pharmacy_ID, DATE '2026-10-10' AS Issue_Date, 'Synthetic academic example; not clinical advice' AS Notes FROM dual) s
ON (t.Appointment_ID = s.Appointment_ID AND t.Prescription_No = s.Prescription_No)
WHEN NOT MATCHED THEN INSERT (Appointment_ID,Prescription_No,Pharmacy_ID,Issue_Date,Notes)
VALUES (s.Appointment_ID, s.Prescription_No, s.Pharmacy_ID, s.Issue_Date, s.Notes);

MERGE INTO PRESCRIPTION t
USING (SELECT 'APT-S10' AS Appointment_ID, 'RX-S10' AS Prescription_No, 'PHARM-S10' AS Pharmacy_ID, DATE '2026-10-11' AS Issue_Date, 'Synthetic academic example; not clinical advice' AS Notes FROM dual) s
ON (t.Appointment_ID = s.Appointment_ID AND t.Prescription_No = s.Prescription_No)
WHEN NOT MATCHED THEN INSERT (Appointment_ID,Prescription_No,Pharmacy_ID,Issue_Date,Notes)
VALUES (s.Appointment_ID, s.Prescription_No, s.Pharmacy_ID, s.Issue_Date, s.Notes);

MERGE INTO PRESCRIPTION t
USING (SELECT 'APT-S11' AS Appointment_ID, 'RX-S11' AS Prescription_No, 'PHARM-S11' AS Pharmacy_ID, DATE '2026-10-12' AS Issue_Date, 'Synthetic academic example; not clinical advice' AS Notes FROM dual) s
ON (t.Appointment_ID = s.Appointment_ID AND t.Prescription_No = s.Prescription_No)
WHEN NOT MATCHED THEN INSERT (Appointment_ID,Prescription_No,Pharmacy_ID,Issue_Date,Notes)
VALUES (s.Appointment_ID, s.Prescription_No, s.Pharmacy_ID, s.Issue_Date, s.Notes);

MERGE INTO PRESCRIPTION t
USING (SELECT 'APT-S12' AS Appointment_ID, 'RX-S12' AS Prescription_No, 'PHARM-S12' AS Pharmacy_ID, DATE '2026-10-01' AS Issue_Date, 'Synthetic academic example; not clinical advice' AS Notes FROM dual) s
ON (t.Appointment_ID = s.Appointment_ID AND t.Prescription_No = s.Prescription_No)
WHEN NOT MATCHED THEN INSERT (Appointment_ID,Prescription_No,Pharmacy_ID,Issue_Date,Notes)
VALUES (s.Appointment_ID, s.Prescription_No, s.Pharmacy_ID, s.Issue_Date, s.Notes);

MERGE INTO PRESCRIPTION t
USING (SELECT 'APT-S13' AS Appointment_ID, 'RX-S13' AS Prescription_No, 'PHARM-S13' AS Pharmacy_ID, DATE '2026-10-02' AS Issue_Date, 'Synthetic academic example; not clinical advice' AS Notes FROM dual) s
ON (t.Appointment_ID = s.Appointment_ID AND t.Prescription_No = s.Prescription_No)
WHEN NOT MATCHED THEN INSERT (Appointment_ID,Prescription_No,Pharmacy_ID,Issue_Date,Notes)
VALUES (s.Appointment_ID, s.Prescription_No, s.Pharmacy_ID, s.Issue_Date, s.Notes);

MERGE INTO PRESCRIPTION t
USING (SELECT 'APT-S14' AS Appointment_ID, 'RX-S14' AS Prescription_No, 'PHARM-S14' AS Pharmacy_ID, DATE '2026-10-03' AS Issue_Date, 'Synthetic academic example; not clinical advice' AS Notes FROM dual) s
ON (t.Appointment_ID = s.Appointment_ID AND t.Prescription_No = s.Prescription_No)
WHEN NOT MATCHED THEN INSERT (Appointment_ID,Prescription_No,Pharmacy_ID,Issue_Date,Notes)
VALUES (s.Appointment_ID, s.Prescription_No, s.Pharmacy_ID, s.Issue_Date, s.Notes);

MERGE INTO PRESCRIPTION t
USING (SELECT 'APT-S15' AS Appointment_ID, 'RX-S15' AS Prescription_No, 'PHARM-S15' AS Pharmacy_ID, DATE '2026-10-04' AS Issue_Date, 'Synthetic academic example; not clinical advice' AS Notes FROM dual) s
ON (t.Appointment_ID = s.Appointment_ID AND t.Prescription_No = s.Prescription_No)
WHEN NOT MATCHED THEN INSERT (Appointment_ID,Prescription_No,Pharmacy_ID,Issue_Date,Notes)
VALUES (s.Appointment_ID, s.Prescription_No, s.Pharmacy_ID, s.Issue_Date, s.Notes);

MERGE INTO PRESCRIPTION t
USING (SELECT 'APT-S16' AS Appointment_ID, 'RX-S16' AS Prescription_No, 'PHARM-S16' AS Pharmacy_ID, DATE '2026-10-05' AS Issue_Date, 'Synthetic academic example; not clinical advice' AS Notes FROM dual) s
ON (t.Appointment_ID = s.Appointment_ID AND t.Prescription_No = s.Prescription_No)
WHEN NOT MATCHED THEN INSERT (Appointment_ID,Prescription_No,Pharmacy_ID,Issue_Date,Notes)
VALUES (s.Appointment_ID, s.Prescription_No, s.Pharmacy_ID, s.Issue_Date, s.Notes);

MERGE INTO PRESCRIPTION t
USING (SELECT 'APT-S17' AS Appointment_ID, 'RX-S17' AS Prescription_No, 'PHARM-S17' AS Pharmacy_ID, DATE '2026-10-06' AS Issue_Date, 'Synthetic academic example; not clinical advice' AS Notes FROM dual) s
ON (t.Appointment_ID = s.Appointment_ID AND t.Prescription_No = s.Prescription_No)
WHEN NOT MATCHED THEN INSERT (Appointment_ID,Prescription_No,Pharmacy_ID,Issue_Date,Notes)
VALUES (s.Appointment_ID, s.Prescription_No, s.Pharmacy_ID, s.Issue_Date, s.Notes);

-- PRESCRIPTION_ITEM: 17 additional synthetic records
MERGE INTO PRESCRIPTION_ITEM t
USING (SELECT 'APT-S01' AS Appointment_ID, 'RX-S01' AS Prescription_No, 1 AS Item_Seq_No, 'MED-S01' AS Medicine_ID, 'Demo dose once daily' AS Dosage, 5 AS Duration_Days, 5 AS Quantity FROM dual) s
ON (t.Appointment_ID = s.Appointment_ID AND t.Prescription_No = s.Prescription_No AND t.Item_Seq_No = s.Item_Seq_No)
WHEN NOT MATCHED THEN INSERT (Appointment_ID,Prescription_No,Item_Seq_No,Medicine_ID,Dosage,Duration_Days,Quantity)
VALUES (s.Appointment_ID, s.Prescription_No, s.Item_Seq_No, s.Medicine_ID, s.Dosage, s.Duration_Days, s.Quantity);

MERGE INTO PRESCRIPTION_ITEM t
USING (SELECT 'APT-S02' AS Appointment_ID, 'RX-S02' AS Prescription_No, 1 AS Item_Seq_No, 'MED-S02' AS Medicine_ID, 'Demo dose once daily' AS Dosage, 5 AS Duration_Days, 5 AS Quantity FROM dual) s
ON (t.Appointment_ID = s.Appointment_ID AND t.Prescription_No = s.Prescription_No AND t.Item_Seq_No = s.Item_Seq_No)
WHEN NOT MATCHED THEN INSERT (Appointment_ID,Prescription_No,Item_Seq_No,Medicine_ID,Dosage,Duration_Days,Quantity)
VALUES (s.Appointment_ID, s.Prescription_No, s.Item_Seq_No, s.Medicine_ID, s.Dosage, s.Duration_Days, s.Quantity);

MERGE INTO PRESCRIPTION_ITEM t
USING (SELECT 'APT-S03' AS Appointment_ID, 'RX-S03' AS Prescription_No, 1 AS Item_Seq_No, 'MED-S03' AS Medicine_ID, 'Demo dose once daily' AS Dosage, 5 AS Duration_Days, 5 AS Quantity FROM dual) s
ON (t.Appointment_ID = s.Appointment_ID AND t.Prescription_No = s.Prescription_No AND t.Item_Seq_No = s.Item_Seq_No)
WHEN NOT MATCHED THEN INSERT (Appointment_ID,Prescription_No,Item_Seq_No,Medicine_ID,Dosage,Duration_Days,Quantity)
VALUES (s.Appointment_ID, s.Prescription_No, s.Item_Seq_No, s.Medicine_ID, s.Dosage, s.Duration_Days, s.Quantity);

MERGE INTO PRESCRIPTION_ITEM t
USING (SELECT 'APT-S04' AS Appointment_ID, 'RX-S04' AS Prescription_No, 1 AS Item_Seq_No, 'MED-S04' AS Medicine_ID, 'Demo dose once daily' AS Dosage, 5 AS Duration_Days, 5 AS Quantity FROM dual) s
ON (t.Appointment_ID = s.Appointment_ID AND t.Prescription_No = s.Prescription_No AND t.Item_Seq_No = s.Item_Seq_No)
WHEN NOT MATCHED THEN INSERT (Appointment_ID,Prescription_No,Item_Seq_No,Medicine_ID,Dosage,Duration_Days,Quantity)
VALUES (s.Appointment_ID, s.Prescription_No, s.Item_Seq_No, s.Medicine_ID, s.Dosage, s.Duration_Days, s.Quantity);

MERGE INTO PRESCRIPTION_ITEM t
USING (SELECT 'APT-S05' AS Appointment_ID, 'RX-S05' AS Prescription_No, 1 AS Item_Seq_No, 'MED-S05' AS Medicine_ID, 'Demo dose once daily' AS Dosage, 5 AS Duration_Days, 5 AS Quantity FROM dual) s
ON (t.Appointment_ID = s.Appointment_ID AND t.Prescription_No = s.Prescription_No AND t.Item_Seq_No = s.Item_Seq_No)
WHEN NOT MATCHED THEN INSERT (Appointment_ID,Prescription_No,Item_Seq_No,Medicine_ID,Dosage,Duration_Days,Quantity)
VALUES (s.Appointment_ID, s.Prescription_No, s.Item_Seq_No, s.Medicine_ID, s.Dosage, s.Duration_Days, s.Quantity);

MERGE INTO PRESCRIPTION_ITEM t
USING (SELECT 'APT-S06' AS Appointment_ID, 'RX-S06' AS Prescription_No, 1 AS Item_Seq_No, 'MED-S06' AS Medicine_ID, 'Demo dose once daily' AS Dosage, 5 AS Duration_Days, 5 AS Quantity FROM dual) s
ON (t.Appointment_ID = s.Appointment_ID AND t.Prescription_No = s.Prescription_No AND t.Item_Seq_No = s.Item_Seq_No)
WHEN NOT MATCHED THEN INSERT (Appointment_ID,Prescription_No,Item_Seq_No,Medicine_ID,Dosage,Duration_Days,Quantity)
VALUES (s.Appointment_ID, s.Prescription_No, s.Item_Seq_No, s.Medicine_ID, s.Dosage, s.Duration_Days, s.Quantity);

MERGE INTO PRESCRIPTION_ITEM t
USING (SELECT 'APT-S07' AS Appointment_ID, 'RX-S07' AS Prescription_No, 1 AS Item_Seq_No, 'MED-S07' AS Medicine_ID, 'Demo dose once daily' AS Dosage, 5 AS Duration_Days, 5 AS Quantity FROM dual) s
ON (t.Appointment_ID = s.Appointment_ID AND t.Prescription_No = s.Prescription_No AND t.Item_Seq_No = s.Item_Seq_No)
WHEN NOT MATCHED THEN INSERT (Appointment_ID,Prescription_No,Item_Seq_No,Medicine_ID,Dosage,Duration_Days,Quantity)
VALUES (s.Appointment_ID, s.Prescription_No, s.Item_Seq_No, s.Medicine_ID, s.Dosage, s.Duration_Days, s.Quantity);

MERGE INTO PRESCRIPTION_ITEM t
USING (SELECT 'APT-S08' AS Appointment_ID, 'RX-S08' AS Prescription_No, 1 AS Item_Seq_No, 'MED-S08' AS Medicine_ID, 'Demo dose once daily' AS Dosage, 5 AS Duration_Days, 5 AS Quantity FROM dual) s
ON (t.Appointment_ID = s.Appointment_ID AND t.Prescription_No = s.Prescription_No AND t.Item_Seq_No = s.Item_Seq_No)
WHEN NOT MATCHED THEN INSERT (Appointment_ID,Prescription_No,Item_Seq_No,Medicine_ID,Dosage,Duration_Days,Quantity)
VALUES (s.Appointment_ID, s.Prescription_No, s.Item_Seq_No, s.Medicine_ID, s.Dosage, s.Duration_Days, s.Quantity);

MERGE INTO PRESCRIPTION_ITEM t
USING (SELECT 'APT-S09' AS Appointment_ID, 'RX-S09' AS Prescription_No, 1 AS Item_Seq_No, 'MED-S09' AS Medicine_ID, 'Demo dose once daily' AS Dosage, 5 AS Duration_Days, 5 AS Quantity FROM dual) s
ON (t.Appointment_ID = s.Appointment_ID AND t.Prescription_No = s.Prescription_No AND t.Item_Seq_No = s.Item_Seq_No)
WHEN NOT MATCHED THEN INSERT (Appointment_ID,Prescription_No,Item_Seq_No,Medicine_ID,Dosage,Duration_Days,Quantity)
VALUES (s.Appointment_ID, s.Prescription_No, s.Item_Seq_No, s.Medicine_ID, s.Dosage, s.Duration_Days, s.Quantity);

MERGE INTO PRESCRIPTION_ITEM t
USING (SELECT 'APT-S10' AS Appointment_ID, 'RX-S10' AS Prescription_No, 1 AS Item_Seq_No, 'MED-S10' AS Medicine_ID, 'Demo dose once daily' AS Dosage, 5 AS Duration_Days, 5 AS Quantity FROM dual) s
ON (t.Appointment_ID = s.Appointment_ID AND t.Prescription_No = s.Prescription_No AND t.Item_Seq_No = s.Item_Seq_No)
WHEN NOT MATCHED THEN INSERT (Appointment_ID,Prescription_No,Item_Seq_No,Medicine_ID,Dosage,Duration_Days,Quantity)
VALUES (s.Appointment_ID, s.Prescription_No, s.Item_Seq_No, s.Medicine_ID, s.Dosage, s.Duration_Days, s.Quantity);

MERGE INTO PRESCRIPTION_ITEM t
USING (SELECT 'APT-S11' AS Appointment_ID, 'RX-S11' AS Prescription_No, 1 AS Item_Seq_No, 'MED-S11' AS Medicine_ID, 'Demo dose once daily' AS Dosage, 5 AS Duration_Days, 5 AS Quantity FROM dual) s
ON (t.Appointment_ID = s.Appointment_ID AND t.Prescription_No = s.Prescription_No AND t.Item_Seq_No = s.Item_Seq_No)
WHEN NOT MATCHED THEN INSERT (Appointment_ID,Prescription_No,Item_Seq_No,Medicine_ID,Dosage,Duration_Days,Quantity)
VALUES (s.Appointment_ID, s.Prescription_No, s.Item_Seq_No, s.Medicine_ID, s.Dosage, s.Duration_Days, s.Quantity);

MERGE INTO PRESCRIPTION_ITEM t
USING (SELECT 'APT-S12' AS Appointment_ID, 'RX-S12' AS Prescription_No, 1 AS Item_Seq_No, 'MED-S12' AS Medicine_ID, 'Demo dose once daily' AS Dosage, 5 AS Duration_Days, 5 AS Quantity FROM dual) s
ON (t.Appointment_ID = s.Appointment_ID AND t.Prescription_No = s.Prescription_No AND t.Item_Seq_No = s.Item_Seq_No)
WHEN NOT MATCHED THEN INSERT (Appointment_ID,Prescription_No,Item_Seq_No,Medicine_ID,Dosage,Duration_Days,Quantity)
VALUES (s.Appointment_ID, s.Prescription_No, s.Item_Seq_No, s.Medicine_ID, s.Dosage, s.Duration_Days, s.Quantity);

MERGE INTO PRESCRIPTION_ITEM t
USING (SELECT 'APT-S13' AS Appointment_ID, 'RX-S13' AS Prescription_No, 1 AS Item_Seq_No, 'MED-S13' AS Medicine_ID, 'Demo dose once daily' AS Dosage, 5 AS Duration_Days, 5 AS Quantity FROM dual) s
ON (t.Appointment_ID = s.Appointment_ID AND t.Prescription_No = s.Prescription_No AND t.Item_Seq_No = s.Item_Seq_No)
WHEN NOT MATCHED THEN INSERT (Appointment_ID,Prescription_No,Item_Seq_No,Medicine_ID,Dosage,Duration_Days,Quantity)
VALUES (s.Appointment_ID, s.Prescription_No, s.Item_Seq_No, s.Medicine_ID, s.Dosage, s.Duration_Days, s.Quantity);

MERGE INTO PRESCRIPTION_ITEM t
USING (SELECT 'APT-S14' AS Appointment_ID, 'RX-S14' AS Prescription_No, 1 AS Item_Seq_No, 'MED-S14' AS Medicine_ID, 'Demo dose once daily' AS Dosage, 5 AS Duration_Days, 5 AS Quantity FROM dual) s
ON (t.Appointment_ID = s.Appointment_ID AND t.Prescription_No = s.Prescription_No AND t.Item_Seq_No = s.Item_Seq_No)
WHEN NOT MATCHED THEN INSERT (Appointment_ID,Prescription_No,Item_Seq_No,Medicine_ID,Dosage,Duration_Days,Quantity)
VALUES (s.Appointment_ID, s.Prescription_No, s.Item_Seq_No, s.Medicine_ID, s.Dosage, s.Duration_Days, s.Quantity);

MERGE INTO PRESCRIPTION_ITEM t
USING (SELECT 'APT-S15' AS Appointment_ID, 'RX-S15' AS Prescription_No, 1 AS Item_Seq_No, 'MED-S15' AS Medicine_ID, 'Demo dose once daily' AS Dosage, 5 AS Duration_Days, 5 AS Quantity FROM dual) s
ON (t.Appointment_ID = s.Appointment_ID AND t.Prescription_No = s.Prescription_No AND t.Item_Seq_No = s.Item_Seq_No)
WHEN NOT MATCHED THEN INSERT (Appointment_ID,Prescription_No,Item_Seq_No,Medicine_ID,Dosage,Duration_Days,Quantity)
VALUES (s.Appointment_ID, s.Prescription_No, s.Item_Seq_No, s.Medicine_ID, s.Dosage, s.Duration_Days, s.Quantity);

MERGE INTO PRESCRIPTION_ITEM t
USING (SELECT 'APT-S16' AS Appointment_ID, 'RX-S16' AS Prescription_No, 1 AS Item_Seq_No, 'MED-S16' AS Medicine_ID, 'Demo dose once daily' AS Dosage, 5 AS Duration_Days, 5 AS Quantity FROM dual) s
ON (t.Appointment_ID = s.Appointment_ID AND t.Prescription_No = s.Prescription_No AND t.Item_Seq_No = s.Item_Seq_No)
WHEN NOT MATCHED THEN INSERT (Appointment_ID,Prescription_No,Item_Seq_No,Medicine_ID,Dosage,Duration_Days,Quantity)
VALUES (s.Appointment_ID, s.Prescription_No, s.Item_Seq_No, s.Medicine_ID, s.Dosage, s.Duration_Days, s.Quantity);

MERGE INTO PRESCRIPTION_ITEM t
USING (SELECT 'APT-S17' AS Appointment_ID, 'RX-S17' AS Prescription_No, 1 AS Item_Seq_No, 'MED-S17' AS Medicine_ID, 'Demo dose once daily' AS Dosage, 5 AS Duration_Days, 5 AS Quantity FROM dual) s
ON (t.Appointment_ID = s.Appointment_ID AND t.Prescription_No = s.Prescription_No AND t.Item_Seq_No = s.Item_Seq_No)
WHEN NOT MATCHED THEN INSERT (Appointment_ID,Prescription_No,Item_Seq_No,Medicine_ID,Dosage,Duration_Days,Quantity)
VALUES (s.Appointment_ID, s.Prescription_No, s.Item_Seq_No, s.Medicine_ID, s.Dosage, s.Duration_Days, s.Quantity);

-- LAB_ORDER: 17 additional synthetic records
MERGE INTO LAB_ORDER t
USING (SELECT 'ORD-S01' AS Order_ID, 'APT-S01' AS Appointment_ID, 'LAB-S01' AS Test_Catalog_ID, DATE '2026-10-02' AS Order_Date, 'Routine' AS Priority FROM dual) s
ON (t.Order_ID = s.Order_ID)
WHEN NOT MATCHED THEN INSERT (Order_ID,Appointment_ID,Test_Catalog_ID,Order_Date,Priority)
VALUES (s.Order_ID, s.Appointment_ID, s.Test_Catalog_ID, s.Order_Date, s.Priority);

MERGE INTO LAB_ORDER t
USING (SELECT 'ORD-S02' AS Order_ID, 'APT-S02' AS Appointment_ID, 'LAB-S02' AS Test_Catalog_ID, DATE '2026-10-03' AS Order_Date, 'Routine' AS Priority FROM dual) s
ON (t.Order_ID = s.Order_ID)
WHEN NOT MATCHED THEN INSERT (Order_ID,Appointment_ID,Test_Catalog_ID,Order_Date,Priority)
VALUES (s.Order_ID, s.Appointment_ID, s.Test_Catalog_ID, s.Order_Date, s.Priority);

MERGE INTO LAB_ORDER t
USING (SELECT 'ORD-S03' AS Order_ID, 'APT-S03' AS Appointment_ID, 'LAB-S03' AS Test_Catalog_ID, DATE '2026-10-04' AS Order_Date, 'Routine' AS Priority FROM dual) s
ON (t.Order_ID = s.Order_ID)
WHEN NOT MATCHED THEN INSERT (Order_ID,Appointment_ID,Test_Catalog_ID,Order_Date,Priority)
VALUES (s.Order_ID, s.Appointment_ID, s.Test_Catalog_ID, s.Order_Date, s.Priority);

MERGE INTO LAB_ORDER t
USING (SELECT 'ORD-S04' AS Order_ID, 'APT-S04' AS Appointment_ID, 'LAB-S04' AS Test_Catalog_ID, DATE '2026-10-05' AS Order_Date, 'Urgent' AS Priority FROM dual) s
ON (t.Order_ID = s.Order_ID)
WHEN NOT MATCHED THEN INSERT (Order_ID,Appointment_ID,Test_Catalog_ID,Order_Date,Priority)
VALUES (s.Order_ID, s.Appointment_ID, s.Test_Catalog_ID, s.Order_Date, s.Priority);

MERGE INTO LAB_ORDER t
USING (SELECT 'ORD-S05' AS Order_ID, 'APT-S05' AS Appointment_ID, 'LAB-S05' AS Test_Catalog_ID, DATE '2026-10-06' AS Order_Date, 'Routine' AS Priority FROM dual) s
ON (t.Order_ID = s.Order_ID)
WHEN NOT MATCHED THEN INSERT (Order_ID,Appointment_ID,Test_Catalog_ID,Order_Date,Priority)
VALUES (s.Order_ID, s.Appointment_ID, s.Test_Catalog_ID, s.Order_Date, s.Priority);

MERGE INTO LAB_ORDER t
USING (SELECT 'ORD-S06' AS Order_ID, 'APT-S06' AS Appointment_ID, 'LAB-S06' AS Test_Catalog_ID, DATE '2026-10-07' AS Order_Date, 'Routine' AS Priority FROM dual) s
ON (t.Order_ID = s.Order_ID)
WHEN NOT MATCHED THEN INSERT (Order_ID,Appointment_ID,Test_Catalog_ID,Order_Date,Priority)
VALUES (s.Order_ID, s.Appointment_ID, s.Test_Catalog_ID, s.Order_Date, s.Priority);

MERGE INTO LAB_ORDER t
USING (SELECT 'ORD-S07' AS Order_ID, 'APT-S07' AS Appointment_ID, 'LAB-S07' AS Test_Catalog_ID, DATE '2026-10-08' AS Order_Date, 'Routine' AS Priority FROM dual) s
ON (t.Order_ID = s.Order_ID)
WHEN NOT MATCHED THEN INSERT (Order_ID,Appointment_ID,Test_Catalog_ID,Order_Date,Priority)
VALUES (s.Order_ID, s.Appointment_ID, s.Test_Catalog_ID, s.Order_Date, s.Priority);

MERGE INTO LAB_ORDER t
USING (SELECT 'ORD-S08' AS Order_ID, 'APT-S08' AS Appointment_ID, 'LAB-S08' AS Test_Catalog_ID, DATE '2026-10-09' AS Order_Date, 'Urgent' AS Priority FROM dual) s
ON (t.Order_ID = s.Order_ID)
WHEN NOT MATCHED THEN INSERT (Order_ID,Appointment_ID,Test_Catalog_ID,Order_Date,Priority)
VALUES (s.Order_ID, s.Appointment_ID, s.Test_Catalog_ID, s.Order_Date, s.Priority);

MERGE INTO LAB_ORDER t
USING (SELECT 'ORD-S09' AS Order_ID, 'APT-S09' AS Appointment_ID, 'LAB-S09' AS Test_Catalog_ID, DATE '2026-10-10' AS Order_Date, 'Routine' AS Priority FROM dual) s
ON (t.Order_ID = s.Order_ID)
WHEN NOT MATCHED THEN INSERT (Order_ID,Appointment_ID,Test_Catalog_ID,Order_Date,Priority)
VALUES (s.Order_ID, s.Appointment_ID, s.Test_Catalog_ID, s.Order_Date, s.Priority);

MERGE INTO LAB_ORDER t
USING (SELECT 'ORD-S10' AS Order_ID, 'APT-S10' AS Appointment_ID, 'LAB-S10' AS Test_Catalog_ID, DATE '2026-10-11' AS Order_Date, 'Routine' AS Priority FROM dual) s
ON (t.Order_ID = s.Order_ID)
WHEN NOT MATCHED THEN INSERT (Order_ID,Appointment_ID,Test_Catalog_ID,Order_Date,Priority)
VALUES (s.Order_ID, s.Appointment_ID, s.Test_Catalog_ID, s.Order_Date, s.Priority);

MERGE INTO LAB_ORDER t
USING (SELECT 'ORD-S11' AS Order_ID, 'APT-S11' AS Appointment_ID, 'LAB-S11' AS Test_Catalog_ID, DATE '2026-10-12' AS Order_Date, 'Routine' AS Priority FROM dual) s
ON (t.Order_ID = s.Order_ID)
WHEN NOT MATCHED THEN INSERT (Order_ID,Appointment_ID,Test_Catalog_ID,Order_Date,Priority)
VALUES (s.Order_ID, s.Appointment_ID, s.Test_Catalog_ID, s.Order_Date, s.Priority);

MERGE INTO LAB_ORDER t
USING (SELECT 'ORD-S12' AS Order_ID, 'APT-S12' AS Appointment_ID, 'LAB-S12' AS Test_Catalog_ID, DATE '2026-10-01' AS Order_Date, 'Urgent' AS Priority FROM dual) s
ON (t.Order_ID = s.Order_ID)
WHEN NOT MATCHED THEN INSERT (Order_ID,Appointment_ID,Test_Catalog_ID,Order_Date,Priority)
VALUES (s.Order_ID, s.Appointment_ID, s.Test_Catalog_ID, s.Order_Date, s.Priority);

MERGE INTO LAB_ORDER t
USING (SELECT 'ORD-S13' AS Order_ID, 'APT-S13' AS Appointment_ID, 'LAB-S13' AS Test_Catalog_ID, DATE '2026-10-02' AS Order_Date, 'Routine' AS Priority FROM dual) s
ON (t.Order_ID = s.Order_ID)
WHEN NOT MATCHED THEN INSERT (Order_ID,Appointment_ID,Test_Catalog_ID,Order_Date,Priority)
VALUES (s.Order_ID, s.Appointment_ID, s.Test_Catalog_ID, s.Order_Date, s.Priority);

MERGE INTO LAB_ORDER t
USING (SELECT 'ORD-S14' AS Order_ID, 'APT-S14' AS Appointment_ID, 'LAB-S14' AS Test_Catalog_ID, DATE '2026-10-03' AS Order_Date, 'Routine' AS Priority FROM dual) s
ON (t.Order_ID = s.Order_ID)
WHEN NOT MATCHED THEN INSERT (Order_ID,Appointment_ID,Test_Catalog_ID,Order_Date,Priority)
VALUES (s.Order_ID, s.Appointment_ID, s.Test_Catalog_ID, s.Order_Date, s.Priority);

MERGE INTO LAB_ORDER t
USING (SELECT 'ORD-S15' AS Order_ID, 'APT-S15' AS Appointment_ID, 'LAB-S15' AS Test_Catalog_ID, DATE '2026-10-04' AS Order_Date, 'Routine' AS Priority FROM dual) s
ON (t.Order_ID = s.Order_ID)
WHEN NOT MATCHED THEN INSERT (Order_ID,Appointment_ID,Test_Catalog_ID,Order_Date,Priority)
VALUES (s.Order_ID, s.Appointment_ID, s.Test_Catalog_ID, s.Order_Date, s.Priority);

MERGE INTO LAB_ORDER t
USING (SELECT 'ORD-S16' AS Order_ID, 'APT-S16' AS Appointment_ID, 'LAB-S16' AS Test_Catalog_ID, DATE '2026-10-05' AS Order_Date, 'Urgent' AS Priority FROM dual) s
ON (t.Order_ID = s.Order_ID)
WHEN NOT MATCHED THEN INSERT (Order_ID,Appointment_ID,Test_Catalog_ID,Order_Date,Priority)
VALUES (s.Order_ID, s.Appointment_ID, s.Test_Catalog_ID, s.Order_Date, s.Priority);

MERGE INTO LAB_ORDER t
USING (SELECT 'ORD-S17' AS Order_ID, 'APT-S17' AS Appointment_ID, 'LAB-S17' AS Test_Catalog_ID, DATE '2026-10-06' AS Order_Date, 'Routine' AS Priority FROM dual) s
ON (t.Order_ID = s.Order_ID)
WHEN NOT MATCHED THEN INSERT (Order_ID,Appointment_ID,Test_Catalog_ID,Order_Date,Priority)
VALUES (s.Order_ID, s.Appointment_ID, s.Test_Catalog_ID, s.Order_Date, s.Priority);

-- TEST_RESULT: 17 additional synthetic records
MERGE INTO TEST_RESULT t
USING (SELECT 'ORD-S01' AS Order_ID, 1 AS Result_Seq_No, 'Synthetic panel 1: within demo reference range' AS Result_Value, DATE '2026-10-02' AS Report_Date, 'Synthetic academic data' AS Technician_Remarks, NULL AS Document_URL, NULL AS File_Format FROM dual) s
ON (t.Order_ID = s.Order_ID AND t.Result_Seq_No = s.Result_Seq_No)
WHEN NOT MATCHED THEN INSERT (Order_ID,Result_Seq_No,Result_Value,Report_Date,Technician_Remarks,Document_URL,File_Format)
VALUES (s.Order_ID, s.Result_Seq_No, s.Result_Value, s.Report_Date, s.Technician_Remarks, s.Document_URL, s.File_Format);

MERGE INTO TEST_RESULT t
USING (SELECT 'ORD-S02' AS Order_ID, 1 AS Result_Seq_No, 'Synthetic panel 2: within demo reference range' AS Result_Value, DATE '2026-10-03' AS Report_Date, 'Synthetic academic data' AS Technician_Remarks, NULL AS Document_URL, NULL AS File_Format FROM dual) s
ON (t.Order_ID = s.Order_ID AND t.Result_Seq_No = s.Result_Seq_No)
WHEN NOT MATCHED THEN INSERT (Order_ID,Result_Seq_No,Result_Value,Report_Date,Technician_Remarks,Document_URL,File_Format)
VALUES (s.Order_ID, s.Result_Seq_No, s.Result_Value, s.Report_Date, s.Technician_Remarks, s.Document_URL, s.File_Format);

MERGE INTO TEST_RESULT t
USING (SELECT 'ORD-S03' AS Order_ID, 1 AS Result_Seq_No, 'Synthetic panel 3: within demo reference range' AS Result_Value, DATE '2026-10-04' AS Report_Date, 'Synthetic academic data' AS Technician_Remarks, NULL AS Document_URL, NULL AS File_Format FROM dual) s
ON (t.Order_ID = s.Order_ID AND t.Result_Seq_No = s.Result_Seq_No)
WHEN NOT MATCHED THEN INSERT (Order_ID,Result_Seq_No,Result_Value,Report_Date,Technician_Remarks,Document_URL,File_Format)
VALUES (s.Order_ID, s.Result_Seq_No, s.Result_Value, s.Report_Date, s.Technician_Remarks, s.Document_URL, s.File_Format);

MERGE INTO TEST_RESULT t
USING (SELECT 'ORD-S04' AS Order_ID, 1 AS Result_Seq_No, 'Synthetic panel 4: within demo reference range' AS Result_Value, DATE '2026-10-05' AS Report_Date, 'Synthetic academic data' AS Technician_Remarks, NULL AS Document_URL, NULL AS File_Format FROM dual) s
ON (t.Order_ID = s.Order_ID AND t.Result_Seq_No = s.Result_Seq_No)
WHEN NOT MATCHED THEN INSERT (Order_ID,Result_Seq_No,Result_Value,Report_Date,Technician_Remarks,Document_URL,File_Format)
VALUES (s.Order_ID, s.Result_Seq_No, s.Result_Value, s.Report_Date, s.Technician_Remarks, s.Document_URL, s.File_Format);

MERGE INTO TEST_RESULT t
USING (SELECT 'ORD-S05' AS Order_ID, 1 AS Result_Seq_No, 'Synthetic panel 5: within demo reference range' AS Result_Value, DATE '2026-10-06' AS Report_Date, 'Synthetic academic data' AS Technician_Remarks, NULL AS Document_URL, NULL AS File_Format FROM dual) s
ON (t.Order_ID = s.Order_ID AND t.Result_Seq_No = s.Result_Seq_No)
WHEN NOT MATCHED THEN INSERT (Order_ID,Result_Seq_No,Result_Value,Report_Date,Technician_Remarks,Document_URL,File_Format)
VALUES (s.Order_ID, s.Result_Seq_No, s.Result_Value, s.Report_Date, s.Technician_Remarks, s.Document_URL, s.File_Format);

MERGE INTO TEST_RESULT t
USING (SELECT 'ORD-S06' AS Order_ID, 1 AS Result_Seq_No, 'Synthetic panel 6: within demo reference range' AS Result_Value, DATE '2026-10-07' AS Report_Date, 'Synthetic academic data' AS Technician_Remarks, NULL AS Document_URL, NULL AS File_Format FROM dual) s
ON (t.Order_ID = s.Order_ID AND t.Result_Seq_No = s.Result_Seq_No)
WHEN NOT MATCHED THEN INSERT (Order_ID,Result_Seq_No,Result_Value,Report_Date,Technician_Remarks,Document_URL,File_Format)
VALUES (s.Order_ID, s.Result_Seq_No, s.Result_Value, s.Report_Date, s.Technician_Remarks, s.Document_URL, s.File_Format);

MERGE INTO TEST_RESULT t
USING (SELECT 'ORD-S07' AS Order_ID, 1 AS Result_Seq_No, 'Synthetic panel 7: within demo reference range' AS Result_Value, DATE '2026-10-08' AS Report_Date, 'Synthetic academic data' AS Technician_Remarks, NULL AS Document_URL, NULL AS File_Format FROM dual) s
ON (t.Order_ID = s.Order_ID AND t.Result_Seq_No = s.Result_Seq_No)
WHEN NOT MATCHED THEN INSERT (Order_ID,Result_Seq_No,Result_Value,Report_Date,Technician_Remarks,Document_URL,File_Format)
VALUES (s.Order_ID, s.Result_Seq_No, s.Result_Value, s.Report_Date, s.Technician_Remarks, s.Document_URL, s.File_Format);

MERGE INTO TEST_RESULT t
USING (SELECT 'ORD-S08' AS Order_ID, 1 AS Result_Seq_No, 'Synthetic panel 8: within demo reference range' AS Result_Value, DATE '2026-10-09' AS Report_Date, 'Synthetic academic data' AS Technician_Remarks, NULL AS Document_URL, NULL AS File_Format FROM dual) s
ON (t.Order_ID = s.Order_ID AND t.Result_Seq_No = s.Result_Seq_No)
WHEN NOT MATCHED THEN INSERT (Order_ID,Result_Seq_No,Result_Value,Report_Date,Technician_Remarks,Document_URL,File_Format)
VALUES (s.Order_ID, s.Result_Seq_No, s.Result_Value, s.Report_Date, s.Technician_Remarks, s.Document_URL, s.File_Format);

MERGE INTO TEST_RESULT t
USING (SELECT 'ORD-S09' AS Order_ID, 1 AS Result_Seq_No, 'Synthetic panel 9: within demo reference range' AS Result_Value, DATE '2026-10-10' AS Report_Date, 'Synthetic academic data' AS Technician_Remarks, NULL AS Document_URL, NULL AS File_Format FROM dual) s
ON (t.Order_ID = s.Order_ID AND t.Result_Seq_No = s.Result_Seq_No)
WHEN NOT MATCHED THEN INSERT (Order_ID,Result_Seq_No,Result_Value,Report_Date,Technician_Remarks,Document_URL,File_Format)
VALUES (s.Order_ID, s.Result_Seq_No, s.Result_Value, s.Report_Date, s.Technician_Remarks, s.Document_URL, s.File_Format);

MERGE INTO TEST_RESULT t
USING (SELECT 'ORD-S10' AS Order_ID, 1 AS Result_Seq_No, 'Synthetic panel 10: within demo reference range' AS Result_Value, DATE '2026-10-11' AS Report_Date, 'Synthetic academic data' AS Technician_Remarks, NULL AS Document_URL, NULL AS File_Format FROM dual) s
ON (t.Order_ID = s.Order_ID AND t.Result_Seq_No = s.Result_Seq_No)
WHEN NOT MATCHED THEN INSERT (Order_ID,Result_Seq_No,Result_Value,Report_Date,Technician_Remarks,Document_URL,File_Format)
VALUES (s.Order_ID, s.Result_Seq_No, s.Result_Value, s.Report_Date, s.Technician_Remarks, s.Document_URL, s.File_Format);

MERGE INTO TEST_RESULT t
USING (SELECT 'ORD-S11' AS Order_ID, 1 AS Result_Seq_No, 'Synthetic panel 11: within demo reference range' AS Result_Value, DATE '2026-10-12' AS Report_Date, 'Synthetic academic data' AS Technician_Remarks, NULL AS Document_URL, NULL AS File_Format FROM dual) s
ON (t.Order_ID = s.Order_ID AND t.Result_Seq_No = s.Result_Seq_No)
WHEN NOT MATCHED THEN INSERT (Order_ID,Result_Seq_No,Result_Value,Report_Date,Technician_Remarks,Document_URL,File_Format)
VALUES (s.Order_ID, s.Result_Seq_No, s.Result_Value, s.Report_Date, s.Technician_Remarks, s.Document_URL, s.File_Format);

MERGE INTO TEST_RESULT t
USING (SELECT 'ORD-S12' AS Order_ID, 1 AS Result_Seq_No, 'Synthetic panel 12: within demo reference range' AS Result_Value, DATE '2026-10-01' AS Report_Date, 'Synthetic academic data' AS Technician_Remarks, NULL AS Document_URL, NULL AS File_Format FROM dual) s
ON (t.Order_ID = s.Order_ID AND t.Result_Seq_No = s.Result_Seq_No)
WHEN NOT MATCHED THEN INSERT (Order_ID,Result_Seq_No,Result_Value,Report_Date,Technician_Remarks,Document_URL,File_Format)
VALUES (s.Order_ID, s.Result_Seq_No, s.Result_Value, s.Report_Date, s.Technician_Remarks, s.Document_URL, s.File_Format);

MERGE INTO TEST_RESULT t
USING (SELECT 'ORD-S13' AS Order_ID, 1 AS Result_Seq_No, 'Synthetic panel 13: within demo reference range' AS Result_Value, DATE '2026-10-02' AS Report_Date, 'Synthetic academic data' AS Technician_Remarks, NULL AS Document_URL, NULL AS File_Format FROM dual) s
ON (t.Order_ID = s.Order_ID AND t.Result_Seq_No = s.Result_Seq_No)
WHEN NOT MATCHED THEN INSERT (Order_ID,Result_Seq_No,Result_Value,Report_Date,Technician_Remarks,Document_URL,File_Format)
VALUES (s.Order_ID, s.Result_Seq_No, s.Result_Value, s.Report_Date, s.Technician_Remarks, s.Document_URL, s.File_Format);

MERGE INTO TEST_RESULT t
USING (SELECT 'ORD-S14' AS Order_ID, 1 AS Result_Seq_No, 'Synthetic panel 14: within demo reference range' AS Result_Value, DATE '2026-10-03' AS Report_Date, 'Synthetic academic data' AS Technician_Remarks, NULL AS Document_URL, NULL AS File_Format FROM dual) s
ON (t.Order_ID = s.Order_ID AND t.Result_Seq_No = s.Result_Seq_No)
WHEN NOT MATCHED THEN INSERT (Order_ID,Result_Seq_No,Result_Value,Report_Date,Technician_Remarks,Document_URL,File_Format)
VALUES (s.Order_ID, s.Result_Seq_No, s.Result_Value, s.Report_Date, s.Technician_Remarks, s.Document_URL, s.File_Format);

MERGE INTO TEST_RESULT t
USING (SELECT 'ORD-S15' AS Order_ID, 1 AS Result_Seq_No, 'Synthetic panel 15: within demo reference range' AS Result_Value, DATE '2026-10-04' AS Report_Date, 'Synthetic academic data' AS Technician_Remarks, NULL AS Document_URL, NULL AS File_Format FROM dual) s
ON (t.Order_ID = s.Order_ID AND t.Result_Seq_No = s.Result_Seq_No)
WHEN NOT MATCHED THEN INSERT (Order_ID,Result_Seq_No,Result_Value,Report_Date,Technician_Remarks,Document_URL,File_Format)
VALUES (s.Order_ID, s.Result_Seq_No, s.Result_Value, s.Report_Date, s.Technician_Remarks, s.Document_URL, s.File_Format);

MERGE INTO TEST_RESULT t
USING (SELECT 'ORD-S16' AS Order_ID, 1 AS Result_Seq_No, 'Synthetic panel 16: within demo reference range' AS Result_Value, DATE '2026-10-05' AS Report_Date, 'Synthetic academic data' AS Technician_Remarks, NULL AS Document_URL, NULL AS File_Format FROM dual) s
ON (t.Order_ID = s.Order_ID AND t.Result_Seq_No = s.Result_Seq_No)
WHEN NOT MATCHED THEN INSERT (Order_ID,Result_Seq_No,Result_Value,Report_Date,Technician_Remarks,Document_URL,File_Format)
VALUES (s.Order_ID, s.Result_Seq_No, s.Result_Value, s.Report_Date, s.Technician_Remarks, s.Document_URL, s.File_Format);

MERGE INTO TEST_RESULT t
USING (SELECT 'ORD-S17' AS Order_ID, 1 AS Result_Seq_No, 'Synthetic panel 17: within demo reference range' AS Result_Value, DATE '2026-10-06' AS Report_Date, 'Synthetic academic data' AS Technician_Remarks, NULL AS Document_URL, NULL AS File_Format FROM dual) s
ON (t.Order_ID = s.Order_ID AND t.Result_Seq_No = s.Result_Seq_No)
WHEN NOT MATCHED THEN INSERT (Order_ID,Result_Seq_No,Result_Value,Report_Date,Technician_Remarks,Document_URL,File_Format)
VALUES (s.Order_ID, s.Result_Seq_No, s.Result_Value, s.Report_Date, s.Technician_Remarks, s.Document_URL, s.File_Format);

-- BILLING_INVOICE: 17 additional synthetic records
MERGE INTO BILLING_INVOICE t
USING (SELECT 'APT-S01' AS Appointment_ID, 'INV-S01' AS Invoice_No, DATE '2026-10-02' AS Billing_Date, 280 AS Total_Amount, 'Paid' AS Payment_Status FROM dual) s
ON (t.Appointment_ID = s.Appointment_ID AND t.Invoice_No = s.Invoice_No)
WHEN NOT MATCHED THEN INSERT (Appointment_ID,Invoice_No,Billing_Date,Total_Amount,Payment_Status)
VALUES (s.Appointment_ID, s.Invoice_No, s.Billing_Date, s.Total_Amount, s.Payment_Status);

MERGE INTO BILLING_INVOICE t
USING (SELECT 'APT-S02' AS Appointment_ID, 'INV-S02' AS Invoice_No, DATE '2026-10-03' AS Billing_Date, 310 AS Total_Amount, 'Paid' AS Payment_Status FROM dual) s
ON (t.Appointment_ID = s.Appointment_ID AND t.Invoice_No = s.Invoice_No)
WHEN NOT MATCHED THEN INSERT (Appointment_ID,Invoice_No,Billing_Date,Total_Amount,Payment_Status)
VALUES (s.Appointment_ID, s.Invoice_No, s.Billing_Date, s.Total_Amount, s.Payment_Status);

MERGE INTO BILLING_INVOICE t
USING (SELECT 'APT-S03' AS Appointment_ID, 'INV-S03' AS Invoice_No, DATE '2026-10-04' AS Billing_Date, 340 AS Total_Amount, 'Pending' AS Payment_Status FROM dual) s
ON (t.Appointment_ID = s.Appointment_ID AND t.Invoice_No = s.Invoice_No)
WHEN NOT MATCHED THEN INSERT (Appointment_ID,Invoice_No,Billing_Date,Total_Amount,Payment_Status)
VALUES (s.Appointment_ID, s.Invoice_No, s.Billing_Date, s.Total_Amount, s.Payment_Status);

MERGE INTO BILLING_INVOICE t
USING (SELECT 'APT-S04' AS Appointment_ID, 'INV-S04' AS Invoice_No, DATE '2026-10-05' AS Billing_Date, 370 AS Total_Amount, 'Paid' AS Payment_Status FROM dual) s
ON (t.Appointment_ID = s.Appointment_ID AND t.Invoice_No = s.Invoice_No)
WHEN NOT MATCHED THEN INSERT (Appointment_ID,Invoice_No,Billing_Date,Total_Amount,Payment_Status)
VALUES (s.Appointment_ID, s.Invoice_No, s.Billing_Date, s.Total_Amount, s.Payment_Status);

MERGE INTO BILLING_INVOICE t
USING (SELECT 'APT-S05' AS Appointment_ID, 'INV-S05' AS Invoice_No, DATE '2026-10-06' AS Billing_Date, 400 AS Total_Amount, 'Paid' AS Payment_Status FROM dual) s
ON (t.Appointment_ID = s.Appointment_ID AND t.Invoice_No = s.Invoice_No)
WHEN NOT MATCHED THEN INSERT (Appointment_ID,Invoice_No,Billing_Date,Total_Amount,Payment_Status)
VALUES (s.Appointment_ID, s.Invoice_No, s.Billing_Date, s.Total_Amount, s.Payment_Status);

MERGE INTO BILLING_INVOICE t
USING (SELECT 'APT-S06' AS Appointment_ID, 'INV-S06' AS Invoice_No, DATE '2026-10-07' AS Billing_Date, 430 AS Total_Amount, 'Pending' AS Payment_Status FROM dual) s
ON (t.Appointment_ID = s.Appointment_ID AND t.Invoice_No = s.Invoice_No)
WHEN NOT MATCHED THEN INSERT (Appointment_ID,Invoice_No,Billing_Date,Total_Amount,Payment_Status)
VALUES (s.Appointment_ID, s.Invoice_No, s.Billing_Date, s.Total_Amount, s.Payment_Status);

MERGE INTO BILLING_INVOICE t
USING (SELECT 'APT-S07' AS Appointment_ID, 'INV-S07' AS Invoice_No, DATE '2026-10-08' AS Billing_Date, 460 AS Total_Amount, 'Paid' AS Payment_Status FROM dual) s
ON (t.Appointment_ID = s.Appointment_ID AND t.Invoice_No = s.Invoice_No)
WHEN NOT MATCHED THEN INSERT (Appointment_ID,Invoice_No,Billing_Date,Total_Amount,Payment_Status)
VALUES (s.Appointment_ID, s.Invoice_No, s.Billing_Date, s.Total_Amount, s.Payment_Status);

MERGE INTO BILLING_INVOICE t
USING (SELECT 'APT-S08' AS Appointment_ID, 'INV-S08' AS Invoice_No, DATE '2026-10-09' AS Billing_Date, 490 AS Total_Amount, 'Paid' AS Payment_Status FROM dual) s
ON (t.Appointment_ID = s.Appointment_ID AND t.Invoice_No = s.Invoice_No)
WHEN NOT MATCHED THEN INSERT (Appointment_ID,Invoice_No,Billing_Date,Total_Amount,Payment_Status)
VALUES (s.Appointment_ID, s.Invoice_No, s.Billing_Date, s.Total_Amount, s.Payment_Status);

MERGE INTO BILLING_INVOICE t
USING (SELECT 'APT-S09' AS Appointment_ID, 'INV-S09' AS Invoice_No, DATE '2026-10-10' AS Billing_Date, 520 AS Total_Amount, 'Pending' AS Payment_Status FROM dual) s
ON (t.Appointment_ID = s.Appointment_ID AND t.Invoice_No = s.Invoice_No)
WHEN NOT MATCHED THEN INSERT (Appointment_ID,Invoice_No,Billing_Date,Total_Amount,Payment_Status)
VALUES (s.Appointment_ID, s.Invoice_No, s.Billing_Date, s.Total_Amount, s.Payment_Status);

MERGE INTO BILLING_INVOICE t
USING (SELECT 'APT-S10' AS Appointment_ID, 'INV-S10' AS Invoice_No, DATE '2026-10-11' AS Billing_Date, 550 AS Total_Amount, 'Paid' AS Payment_Status FROM dual) s
ON (t.Appointment_ID = s.Appointment_ID AND t.Invoice_No = s.Invoice_No)
WHEN NOT MATCHED THEN INSERT (Appointment_ID,Invoice_No,Billing_Date,Total_Amount,Payment_Status)
VALUES (s.Appointment_ID, s.Invoice_No, s.Billing_Date, s.Total_Amount, s.Payment_Status);

MERGE INTO BILLING_INVOICE t
USING (SELECT 'APT-S11' AS Appointment_ID, 'INV-S11' AS Invoice_No, DATE '2026-10-12' AS Billing_Date, 580 AS Total_Amount, 'Paid' AS Payment_Status FROM dual) s
ON (t.Appointment_ID = s.Appointment_ID AND t.Invoice_No = s.Invoice_No)
WHEN NOT MATCHED THEN INSERT (Appointment_ID,Invoice_No,Billing_Date,Total_Amount,Payment_Status)
VALUES (s.Appointment_ID, s.Invoice_No, s.Billing_Date, s.Total_Amount, s.Payment_Status);

MERGE INTO BILLING_INVOICE t
USING (SELECT 'APT-S12' AS Appointment_ID, 'INV-S12' AS Invoice_No, DATE '2026-10-01' AS Billing_Date, 610 AS Total_Amount, 'Pending' AS Payment_Status FROM dual) s
ON (t.Appointment_ID = s.Appointment_ID AND t.Invoice_No = s.Invoice_No)
WHEN NOT MATCHED THEN INSERT (Appointment_ID,Invoice_No,Billing_Date,Total_Amount,Payment_Status)
VALUES (s.Appointment_ID, s.Invoice_No, s.Billing_Date, s.Total_Amount, s.Payment_Status);

MERGE INTO BILLING_INVOICE t
USING (SELECT 'APT-S13' AS Appointment_ID, 'INV-S13' AS Invoice_No, DATE '2026-10-02' AS Billing_Date, 640 AS Total_Amount, 'Paid' AS Payment_Status FROM dual) s
ON (t.Appointment_ID = s.Appointment_ID AND t.Invoice_No = s.Invoice_No)
WHEN NOT MATCHED THEN INSERT (Appointment_ID,Invoice_No,Billing_Date,Total_Amount,Payment_Status)
VALUES (s.Appointment_ID, s.Invoice_No, s.Billing_Date, s.Total_Amount, s.Payment_Status);

MERGE INTO BILLING_INVOICE t
USING (SELECT 'APT-S14' AS Appointment_ID, 'INV-S14' AS Invoice_No, DATE '2026-10-03' AS Billing_Date, 670 AS Total_Amount, 'Paid' AS Payment_Status FROM dual) s
ON (t.Appointment_ID = s.Appointment_ID AND t.Invoice_No = s.Invoice_No)
WHEN NOT MATCHED THEN INSERT (Appointment_ID,Invoice_No,Billing_Date,Total_Amount,Payment_Status)
VALUES (s.Appointment_ID, s.Invoice_No, s.Billing_Date, s.Total_Amount, s.Payment_Status);

MERGE INTO BILLING_INVOICE t
USING (SELECT 'APT-S15' AS Appointment_ID, 'INV-S15' AS Invoice_No, DATE '2026-10-04' AS Billing_Date, 700 AS Total_Amount, 'Pending' AS Payment_Status FROM dual) s
ON (t.Appointment_ID = s.Appointment_ID AND t.Invoice_No = s.Invoice_No)
WHEN NOT MATCHED THEN INSERT (Appointment_ID,Invoice_No,Billing_Date,Total_Amount,Payment_Status)
VALUES (s.Appointment_ID, s.Invoice_No, s.Billing_Date, s.Total_Amount, s.Payment_Status);

MERGE INTO BILLING_INVOICE t
USING (SELECT 'APT-S16' AS Appointment_ID, 'INV-S16' AS Invoice_No, DATE '2026-10-05' AS Billing_Date, 730 AS Total_Amount, 'Paid' AS Payment_Status FROM dual) s
ON (t.Appointment_ID = s.Appointment_ID AND t.Invoice_No = s.Invoice_No)
WHEN NOT MATCHED THEN INSERT (Appointment_ID,Invoice_No,Billing_Date,Total_Amount,Payment_Status)
VALUES (s.Appointment_ID, s.Invoice_No, s.Billing_Date, s.Total_Amount, s.Payment_Status);

MERGE INTO BILLING_INVOICE t
USING (SELECT 'APT-S17' AS Appointment_ID, 'INV-S17' AS Invoice_No, DATE '2026-10-06' AS Billing_Date, 760 AS Total_Amount, 'Paid' AS Payment_Status FROM dual) s
ON (t.Appointment_ID = s.Appointment_ID AND t.Invoice_No = s.Invoice_No)
WHEN NOT MATCHED THEN INSERT (Appointment_ID,Invoice_No,Billing_Date,Total_Amount,Payment_Status)
VALUES (s.Appointment_ID, s.Invoice_No, s.Billing_Date, s.Total_Amount, s.Payment_Status);

DECLARE
    v_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count FROM INSURANCE_PROVIDER;
    IF v_count < 25 THEN
        RAISE_APPLICATION_ERROR(-20025, 'INSURANCE_PROVIDER has fewer than 25 records');
    END IF;
    SELECT COUNT(*) INTO v_count FROM DEPARTMENT;
    IF v_count < 25 THEN
        RAISE_APPLICATION_ERROR(-20025, 'DEPARTMENT has fewer than 25 records');
    END IF;
    SELECT COUNT(*) INTO v_count FROM PHARMACY;
    IF v_count < 25 THEN
        RAISE_APPLICATION_ERROR(-20025, 'PHARMACY has fewer than 25 records');
    END IF;
    SELECT COUNT(*) INTO v_count FROM MEDICINE;
    IF v_count < 25 THEN
        RAISE_APPLICATION_ERROR(-20025, 'MEDICINE has fewer than 25 records');
    END IF;
    SELECT COUNT(*) INTO v_count FROM LAB_TEST_CATALOG;
    IF v_count < 25 THEN
        RAISE_APPLICATION_ERROR(-20025, 'LAB_TEST_CATALOG has fewer than 25 records');
    END IF;
    SELECT COUNT(*) INTO v_count FROM PATIENT;
    IF v_count < 25 THEN
        RAISE_APPLICATION_ERROR(-20025, 'PATIENT has fewer than 25 records');
    END IF;
    SELECT COUNT(*) INTO v_count FROM DOCTOR;
    IF v_count < 25 THEN
        RAISE_APPLICATION_ERROR(-20025, 'DOCTOR has fewer than 25 records');
    END IF;
    SELECT COUNT(*) INTO v_count FROM PATIENT_PHONE;
    IF v_count < 25 THEN
        RAISE_APPLICATION_ERROR(-20025, 'PATIENT_PHONE has fewer than 25 records');
    END IF;
    SELECT COUNT(*) INTO v_count FROM DOCTOR_QUALIFICATION;
    IF v_count < 25 THEN
        RAISE_APPLICATION_ERROR(-20025, 'DOCTOR_QUALIFICATION has fewer than 25 records');
    END IF;
    SELECT COUNT(*) INTO v_count FROM MEDICAL_LOG;
    IF v_count < 25 THEN
        RAISE_APPLICATION_ERROR(-20025, 'MEDICAL_LOG has fewer than 25 records');
    END IF;
    SELECT COUNT(*) INTO v_count FROM LOG_ALLERGIES;
    IF v_count < 25 THEN
        RAISE_APPLICATION_ERROR(-20025, 'LOG_ALLERGIES has fewer than 25 records');
    END IF;
    SELECT COUNT(*) INTO v_count FROM APPOINTMENT;
    IF v_count < 25 THEN
        RAISE_APPLICATION_ERROR(-20025, 'APPOINTMENT has fewer than 25 records');
    END IF;
    SELECT COUNT(*) INTO v_count FROM TELEMEDICINE_SESSION;
    IF v_count < 25 THEN
        RAISE_APPLICATION_ERROR(-20025, 'TELEMEDICINE_SESSION has fewer than 25 records');
    END IF;
    SELECT COUNT(*) INTO v_count FROM PRESCRIPTION;
    IF v_count < 25 THEN
        RAISE_APPLICATION_ERROR(-20025, 'PRESCRIPTION has fewer than 25 records');
    END IF;
    SELECT COUNT(*) INTO v_count FROM PRESCRIPTION_ITEM;
    IF v_count < 25 THEN
        RAISE_APPLICATION_ERROR(-20025, 'PRESCRIPTION_ITEM has fewer than 25 records');
    END IF;
    SELECT COUNT(*) INTO v_count FROM LAB_ORDER;
    IF v_count < 25 THEN
        RAISE_APPLICATION_ERROR(-20025, 'LAB_ORDER has fewer than 25 records');
    END IF;
    SELECT COUNT(*) INTO v_count FROM TEST_RESULT;
    IF v_count < 25 THEN
        RAISE_APPLICATION_ERROR(-20025, 'TEST_RESULT has fewer than 25 records');
    END IF;
    SELECT COUNT(*) INTO v_count FROM BILLING_INVOICE;
    IF v_count < 25 THEN
        RAISE_APPLICATION_ERROR(-20025, 'BILLING_INVOICE has fewer than 25 records');
    END IF;
END;
/

COMMIT;

SELECT 'INSURANCE_PROVIDER' AS Table_Name, COUNT(*) AS Total FROM INSURANCE_PROVIDER
UNION ALL SELECT 'DEPARTMENT' AS Table_Name, COUNT(*) AS Total FROM DEPARTMENT
UNION ALL SELECT 'PHARMACY' AS Table_Name, COUNT(*) AS Total FROM PHARMACY
UNION ALL SELECT 'MEDICINE' AS Table_Name, COUNT(*) AS Total FROM MEDICINE
UNION ALL SELECT 'LAB_TEST_CATALOG' AS Table_Name, COUNT(*) AS Total FROM LAB_TEST_CATALOG
UNION ALL SELECT 'PATIENT' AS Table_Name, COUNT(*) AS Total FROM PATIENT
UNION ALL SELECT 'DOCTOR' AS Table_Name, COUNT(*) AS Total FROM DOCTOR
UNION ALL SELECT 'PATIENT_PHONE' AS Table_Name, COUNT(*) AS Total FROM PATIENT_PHONE
UNION ALL SELECT 'DOCTOR_QUALIFICATION' AS Table_Name, COUNT(*) AS Total FROM DOCTOR_QUALIFICATION
UNION ALL SELECT 'MEDICAL_LOG' AS Table_Name, COUNT(*) AS Total FROM MEDICAL_LOG
UNION ALL SELECT 'LOG_ALLERGIES' AS Table_Name, COUNT(*) AS Total FROM LOG_ALLERGIES
UNION ALL SELECT 'APPOINTMENT' AS Table_Name, COUNT(*) AS Total FROM APPOINTMENT
UNION ALL SELECT 'TELEMEDICINE_SESSION' AS Table_Name, COUNT(*) AS Total FROM TELEMEDICINE_SESSION
UNION ALL SELECT 'PRESCRIPTION' AS Table_Name, COUNT(*) AS Total FROM PRESCRIPTION
UNION ALL SELECT 'PRESCRIPTION_ITEM' AS Table_Name, COUNT(*) AS Total FROM PRESCRIPTION_ITEM
UNION ALL SELECT 'LAB_ORDER' AS Table_Name, COUNT(*) AS Total FROM LAB_ORDER
UNION ALL SELECT 'TEST_RESULT' AS Table_Name, COUNT(*) AS Total FROM TEST_RESULT
UNION ALL SELECT 'BILLING_INVOICE' AS Table_Name, COUNT(*) AS Total FROM BILLING_INVOICE
ORDER BY Table_Name;
