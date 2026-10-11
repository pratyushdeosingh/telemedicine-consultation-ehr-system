# D.A. 3 CQL query guide

This guide explains the local Cassandra examples in `cassandra/queries.cql`. The initial dataset has eight synthetic rows; Oracle import and website integration are now implemented; the original eight seed examples remain available.

## Keyspace and table

`care_continuum` is the keyspace: a namespace containing application tables. The local setup uses one replica in `datacenter1` because it has one Cassandra node.

`clinical_events_by_patient_month` stores dated patient records. Its key is:

```cql
PRIMARY KEY ((patient_id, event_month), event_time, event_id)
```

- The inner parentheses mark a combined partition key: patient plus month.
- `event_time` is a clustering column that sorts rows within a partition.
- `event_id` is another clustering column, distinguishing rows on the same date.
- `CLUSTERING ORDER BY (event_time DESC, event_id ASC)` places newest events first and gives equal-date rows a consistent order.

The key is chosen from the question we need to answer: "What records does this patient have for this month?"

## Read one patient and month

```cql
SELECT event_time, event_type, summary
FROM care_continuum.clinical_events_by_patient_month
WHERE patient_id = 'DEMO-01' AND event_month = '2026-09';
```

The two conditions identify one partition. Expected result: four rows, with the invoice dated September 12 first. The two September 10 rows both remain present because their event IDs differ.

Changing the month to `2026-08` returns two rows. Changing the patient to `DEMO-02` with September returns that patient's two rows. These are separate partitions, not SQL joins.

## Read a date range

```cql
SELECT event_time, event_type, summary
FROM care_continuum.clinical_events_by_patient_month
WHERE patient_id = 'DEMO-01' AND event_month = '2026-09'
AND event_time >= '2026-09-11T00:00:00Z'
AND event_time < '2026-09-13T00:00:00Z';
```

The partition is identified first; the clustering timestamp narrows the records within it. Expected result: the September 11 lab result and September 12 invoice. The exclusive end boundary avoids accidentally including September 13.

## Limit results

Add `LIMIT 2` to the patient/month query to return its two newest records. This does not return the newest two records across all patients: the query still addresses only the selected partition.

## Insert and upsert

`INSERT` supplies column names and values, including all primary-key columns. In Cassandra, an insert with the same primary key updates that row rather than creating a duplicate-key error. The seed uses stable keys, so re-running it retains the same eight rows.

Different `event_id` values permit more than one row with the same patient, month, and timestamp.

## Update a demonstration record

```cql
UPDATE care_continuum.clinical_events_by_patient_month
SET summary = 'Updated demonstration summary'
WHERE patient_id = 'DEMO-CRUD' AND event_month = '2026-09'
AND event_time = '2026-09-01T00:00:00Z' AND event_id = 'crud:1';
```

All key columns identify the row whose summary is changed. Cassandra updates can also create a row when its key does not exist; the demonstration intentionally inserts the row first.

## Delete that record

```cql
DELETE FROM care_continuum.clinical_events_by_patient_month
WHERE patient_id = 'DEMO-CRUD' AND event_month = '2026-09'
AND event_time = '2026-09-01T00:00:00Z' AND event_id = 'crud:1';
```

This removes only the teaching row. A subsequent select of the demonstration partition returns no rows. The main eight seed records remain.

## What to explain in the demonstration

1. Why the table is designed around a patient/month query.
2. The difference between the partition key and clustering columns.
3. Why the timestamp alone cannot uniquely identify a record.
4. Why names and summaries are stored in the same row instead of joined during the Cassandra read.
5. How re-running an insert differs from an Oracle duplicate-key insert.
6. Why one node with one replica does not prove multi-node replication or failover.
7. That these are synthetic teaching records, not automatically synchronized Oracle data.

The examples intentionally avoid `ALLOW FILTERING`, secondary indexes, and advanced transaction features. `DESCRIBE` is a shell command, and the commands in `setup.ps1` are Docker/PowerShell setup operations, not CQL database queries.

`DESCRIBE TABLE` also prints Cassandra-generated storage defaults. Those are not extra features we implemented; use `cassandra/schema.cql` for the short authored schema and explain the keys and ordering first.

## Application read query

The backend uses a prepared query with the same partition conditions:

```cql
SELECT event_time, event_id, event_type, patient_name, appointment_id, summary, source_record_id
FROM care_continuum.clinical_events_by_patient_month
WHERE patient_id = ? AND event_month = ?;
```

The question marks are bound values, not string-concatenated input. The driver fetches a page of rows; the API signs its continuation token and the website offers Load More when another page exists. This is application paging, not an additional database model.

The import uses `INSERT ... VALUES (?, ..., ?)` with the same complete primary key each run. Records are read from Oracle with familiar joins and `TO_CHAR` for calendar dates. Source records are not changed, and Cassandra inserts do not commit as part of an Oracle transaction.
