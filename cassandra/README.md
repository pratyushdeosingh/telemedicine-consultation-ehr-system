# Local Apache Cassandra

The local D.A. 3 setup runs actual Apache Cassandra 5.0.9 in Docker. It creates a single-node cluster, a persistent data volume, and a small synthetic timeline dataset. Oracle and the deployed website are unchanged by these commands.

The CQL port is published only at `127.0.0.1:9042`. This configuration is for local development and does not configure production authentication. The container has a 3 GB memory limit and a 1 GB Java heap. Docker Desktop's Linux engine must be running.

## Start and initialize

From the repository root, in PowerShell:

```powershell
docker desktop start
./cassandra/setup.ps1 -Seed
```

The setup script waits for Cassandra readiness, creates the keyspace/table if absent, and optionally loads eight synthetic events. Re-running `-Seed` overwrites those same demonstration keys rather than adding duplicates. Omit `-Seed` to apply only the non-destructive schema definition.

First startup downloads the official image and can take a few minutes. Subsequent starts reuse the image and persistent data volume.

## Explore with CQL

```powershell
docker compose -f cassandra/compose.yaml exec cassandra cqlsh
```

Inside the shell:

```cql
SELECT release_version FROM system.local;
DESCRIBE KEYSPACE care_continuum;

SELECT event_time, event_type, summary
FROM care_continuum.clinical_events_by_patient_month
WHERE patient_id = 'DEMO-01' AND event_month = '2026-09';
```

Enter `EXIT;` to leave the shell. `queries.cql` contains explained reads, date ranges, limits, and a disposable insert/update/delete demonstration:

```powershell
docker compose -f cassandra/compose.yaml cp cassandra/queries.cql cassandra:/tmp/da3-queries.cql
docker compose -f cassandra/compose.yaml exec -T cassandra cqlsh -f /tmp/da3-queries.cql
```

## Model explanation

| Column/key | Meaning |
| --- | --- |
| `patient_id`, `event_month` | Combined partition key: one patient's records for one month |
| `event_time` | First clustering column: sorts events newest first |
| `event_id` | Second clustering column: distinguishes events with the same date/time |
| `event_type`, `summary` | Information rendered in the future timeline |
| `source_record_id`, `appointment_id` | References to an eventual Oracle source record |

The eight seed records cover two synthetic patients and three patient/month partitions. They are not imported from Oracle. Timestamps use explicit UTC values in this teaching dataset; source-calendar handling will be addressed in the import stage.

`care_continuum` is the keyspace, or namespace, containing the table. Its local replication factor is one because this setup has one node. It does not demonstrate replicated failover or scale-out.

## Verification

```powershell
./cassandra/verify.ps1
./cassandra/verify.ps1 -Restart
```

Checks cover partition separation, equal-date records, date-range reads, clustering order, repeatable seed writes, basic CRUD, and optional persistence after restart. A uniquely identified verification row is removed in `finally`; the eight seed records remain. The script deliberately re-applies the synthetic seed.

## Stop and resume

```powershell
docker compose -f cassandra/compose.yaml stop
docker compose -f cassandra/compose.yaml up -d --wait --wait-timeout 240
docker compose -f cassandra/compose.yaml ps
```

Stopping preserves the data. `docker compose down` also preserves the named volume, but **do not use `down -v` unless you intend to delete Cassandra data**.

## Application integration

With the backend's local Cassandra settings enabled, run `npm run timeline:import` from `backend/` to import Oracle records. `npm run timeline:verify` checks source parity and paging; `npm run timeline:verify -- --outage` also verifies that stopping Cassandra does not break Oracle reads.

The Medical History page now includes the timeline. Select a patient and month (for example, PAT-01 and September 2026). The View timeline button re-reads Cassandra; it does not trigger an import.

The hosted site uses the verified Astra DB Free connection; see [the cloud guide](../deploy/CASSANDRA.md). Local demonstrations can use this persistent Apache Cassandra container. Vercel connects to Astra rather than the laptop-local container.
