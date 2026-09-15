-- Automatically create a telemedicine session for every new Virtual appointment.

CREATE OR REPLACE TRIGGER trg_create_telemedicine_session
AFTER INSERT ON APPOINTMENT
FOR EACH ROW
WHEN (NEW.Consultation_Mode = 'Virtual')
BEGIN
    INSERT INTO TELEMEDICINE_SESSION (
        Appointment_ID,
        Session_ID,
        Start_Time,
        End_Time,
        Network_Quality_Log,
        Chat_Transcript_URL
    )
    VALUES (
        :NEW.Appointment_ID,
        'SES-' || SUBSTR(:NEW.Appointment_ID, 5),
        NULL,
        NULL,
        'Session created automatically',
        NULL
    );
END;
/
