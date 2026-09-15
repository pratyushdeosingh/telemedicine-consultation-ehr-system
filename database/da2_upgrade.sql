-- Non-destructive upgrade for a database created with an earlier project script.
-- Safe to rerun: the column is added only when absent and the trigger is replaced.
DECLARE
    v_column_count NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO v_column_count
    FROM USER_TAB_COLUMNS
    WHERE TABLE_NAME = 'MEDICINE'
      AND COLUMN_NAME = 'ALLERGEN_CLASS';

    IF v_column_count = 0 THEN
        EXECUTE IMMEDIATE 'ALTER TABLE MEDICINE ADD Allergen_Class VARCHAR2(50)';
    END IF;
END;
/

UPDATE MEDICINE
SET Allergen_Class = CASE Medicine_ID
    WHEN 'MED-01' THEN 'Penicillin'
    WHEN 'MED-08' THEN 'NSAID'
    ELSE NULL
END;

-- Remove the historical seed conflict before enabling future enforcement.
UPDATE PRESCRIPTION_ITEM
SET Medicine_ID = 'MED-02',
    Dosage = '650mg As needed'
WHERE Appointment_ID = 'APT-01'
  AND Prescription_No = 'RX-01'
  AND Item_Seq_No = 1
  AND Medicine_ID = 'MED-01';

UPDATE BILLING_INVOICE
SET Total_Amount = 1560.00
WHERE Appointment_ID = 'APT-01'
  AND Invoice_No = 'INV-01';

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

COMMIT;
