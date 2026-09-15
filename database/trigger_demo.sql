SET SERVEROUTPUT ON;

-- The schema stores PAT-01's Penicillin allergy and classifies Amoxicillin as
-- Penicillin. This block proves that Prevent_Allergic_Prescription rejects it.
DECLARE
    v_expected_error BOOLEAN := FALSE;
BEGIN
    BEGIN
        INSERT INTO PRESCRIPTION_ITEM (
            Appointment_ID, Prescription_No, Item_Seq_No, Medicine_ID,
            Dosage, Duration_Days, Quantity
        ) VALUES (
            'APT-01', 'RX-01', 99, 'MED-01',
            '500mg Twice Daily', 5, 10
        );
    EXCEPTION
        WHEN OTHERS THEN
            IF SQLCODE = -20002 THEN
                v_expected_error := TRUE;
                DBMS_OUTPUT.PUT_LINE('PASS: trigger blocked the allergy conflict.');
                DBMS_OUTPUT.PUT_LINE(SQLERRM);
            ELSE
                RAISE;
            END IF;
    END;

    IF NOT v_expected_error THEN
        RAISE_APPLICATION_ERROR(-20003, 'FAIL: allergy conflict was not blocked');
    END IF;
END;
/

-- Expected result: zero, proving the rejected row was not stored.
SELECT COUNT(*) AS Rejected_Row_Count
FROM PRESCRIPTION_ITEM
WHERE Appointment_ID = 'APT-01'
  AND Prescription_No = 'RX-01'
  AND Item_Seq_No = 99;
