-- Synthetic demonstration records only; these are not Oracle imports.
-- Stable primary keys make re-running this seed update the same eight rows.
USE care_continuum;

INSERT INTO clinical_events_by_patient_month (patient_id, event_month, event_time, event_id, event_type, patient_name, summary, source_record_id)
VALUES ('DEMO-01', '2026-08', '2026-08-01T00:00:00Z', 'history:1', 'MEDICAL_HISTORY', 'Demo Patient One', 'Synthetic history entry; Penicillin allergy recorded', 'DEMO-LOG-1');

INSERT INTO clinical_events_by_patient_month (patient_id, event_month, event_time, event_id, event_type, patient_name, summary, source_record_id)
VALUES ('DEMO-01', '2026-08', '2026-08-20T00:00:00Z', 'history:2', 'MEDICAL_HISTORY', 'Demo Patient One', 'Synthetic follow-up history entry', 'DEMO-LOG-2');

INSERT INTO clinical_events_by_patient_month (patient_id, event_month, event_time, event_id, event_type, patient_name, appointment_id, summary, source_record_id)
VALUES ('DEMO-01', '2026-09', '2026-09-10T00:00:00Z', 'appointment:1', 'APPOINTMENT', 'Demo Patient One', 'DEMO-APT-1', 'Virtual consultation scheduled', 'DEMO-APT-1');

INSERT INTO clinical_events_by_patient_month (patient_id, event_month, event_time, event_id, event_type, patient_name, appointment_id, summary, source_record_id)
VALUES ('DEMO-01', '2026-09', '2026-09-10T00:00:00Z', 'prescription:1', 'PRESCRIPTION', 'Demo Patient One', 'DEMO-APT-1', 'Synthetic prescription recorded', 'DEMO-RX-1');

INSERT INTO clinical_events_by_patient_month (patient_id, event_month, event_time, event_id, event_type, patient_name, appointment_id, summary, source_record_id)
VALUES ('DEMO-01', '2026-09', '2026-09-11T00:00:00Z', 'result:1', 'LAB_RESULT', 'Demo Patient One', 'DEMO-APT-1', 'Synthetic laboratory result reported', 'DEMO-RESULT-1');

INSERT INTO clinical_events_by_patient_month (patient_id, event_month, event_time, event_id, event_type, patient_name, appointment_id, summary, source_record_id)
VALUES ('DEMO-01', '2026-09', '2026-09-12T00:00:00Z', 'invoice:1', 'INVOICE', 'Demo Patient One', 'DEMO-APT-1', 'Synthetic invoice generated; status Pending', 'DEMO-INV-1');

INSERT INTO clinical_events_by_patient_month (patient_id, event_month, event_time, event_id, event_type, patient_name, appointment_id, summary, source_record_id)
VALUES ('DEMO-02', '2026-09', '2026-09-15T00:00:00Z', 'appointment:2', 'APPOINTMENT', 'Demo Patient Two', 'DEMO-APT-2', 'In-person consultation scheduled', 'DEMO-APT-2');

INSERT INTO clinical_events_by_patient_month (patient_id, event_month, event_time, event_id, event_type, patient_name, appointment_id, summary, source_record_id)
VALUES ('DEMO-02', '2026-09', '2026-09-16T00:00:00Z', 'order:2', 'LAB_ORDER', 'Demo Patient Two', 'DEMO-APT-2', 'Synthetic lab test ordered', 'DEMO-ORDER-2');
