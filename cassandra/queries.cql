-- Run with cqlsh after schema.cql and seed.cql.
USE care_continuum;

-- 1. Inspect the model. DESCRIBE is a cqlsh command.
DESCRIBE TABLE clinical_events_by_patient_month;

-- 2. Retrieve one partition. No join or ALLOW FILTERING is needed.
SELECT event_time, event_id, event_type, summary
FROM clinical_events_by_patient_month
WHERE patient_id = 'DEMO-01' AND event_month = '2026-09';

-- 3. Date range within the selected partition. End boundary is exclusive.
SELECT event_time, event_type, summary
FROM clinical_events_by_patient_month
WHERE patient_id = 'DEMO-01' AND event_month = '2026-09'
AND event_time >= '2026-09-11T00:00:00Z'
AND event_time < '2026-09-13T00:00:00Z';

-- 4. Latest two records within this partition, using its clustering order.
SELECT event_time, event_type, summary
FROM clinical_events_by_patient_month
WHERE patient_id = 'DEMO-01' AND event_month = '2026-09'
LIMIT 2;

-- 5. A different month is a different partition.
SELECT event_time, summary FROM clinical_events_by_patient_month
WHERE patient_id = 'DEMO-01' AND event_month = '2026-08';

-- 6. A different patient's records are retrieved separately.
SELECT event_time, summary FROM clinical_events_by_patient_month
WHERE patient_id = 'DEMO-02' AND event_month = '2026-09';

-- 7. Create a disposable teaching row in its own patient partition.
INSERT INTO clinical_events_by_patient_month (patient_id, event_month, event_time, event_id, event_type, summary)
VALUES ('DEMO-CRUD', '2026-09', '2026-09-01T00:00:00Z', 'crud:1', 'DEMONSTRATION', 'Initial demonstration summary');

-- 8. UPDATE identifies the complete primary key.
UPDATE clinical_events_by_patient_month SET summary = 'Updated demonstration summary'
WHERE patient_id = 'DEMO-CRUD' AND event_month = '2026-09'
AND event_time = '2026-09-01T00:00:00Z' AND event_id = 'crud:1';

SELECT summary FROM clinical_events_by_patient_month
WHERE patient_id = 'DEMO-CRUD' AND event_month = '2026-09';

-- 9. DELETE removes only that teaching row, leaving the seed records intact.
DELETE FROM clinical_events_by_patient_month
WHERE patient_id = 'DEMO-CRUD' AND event_month = '2026-09'
AND event_time = '2026-09-01T00:00:00Z' AND event_id = 'crud:1';

SELECT summary FROM clinical_events_by_patient_month
WHERE patient_id = 'DEMO-CRUD' AND event_month = '2026-09';
