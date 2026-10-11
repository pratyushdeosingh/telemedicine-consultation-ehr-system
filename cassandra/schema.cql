-- A keyspace is Cassandra's namespace for tables.
-- This local deployment has one node, so it uses one replica in datacenter1.
CREATE KEYSPACE IF NOT EXISTS care_continuum
WITH replication = {'class': 'NetworkTopologyStrategy', 'datacenter1': 1};

-- Query: retrieve one patient's dated records for one calendar month.
CREATE TABLE IF NOT EXISTS care_continuum.clinical_events_by_patient_month (
    patient_id text,
    event_month text,
    event_time timestamp,
    event_id text,
    event_type text,
    patient_name text,
    appointment_id text,
    summary text,
    source_record_id text,
    PRIMARY KEY ((patient_id, event_month), event_time, event_id)
) WITH CLUSTERING ORDER BY (event_time DESC, event_id ASC);
