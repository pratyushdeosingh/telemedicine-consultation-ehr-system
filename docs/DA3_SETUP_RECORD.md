# D.A. 3 local setup verification

Verified: 11 October 2026 (Asia/Calcutta).

## Environment

- Development branch: `da3/cassandra-local`.
- Docker Desktop Linux engine started successfully through its CLI.
- Image: official `cassandra:5.0.9`.
- Cassandra reported release `5.0.9` and data center `datacenter1`.
- Compose project: `care-continuum-da3`.
- Endpoint: `127.0.0.1:9042`, published only on loopback.
- One node; replication factor one.
- Named data volume: `care-continuum-da3_cassandra-data`.
- Container memory limit 3 GB; Java heap 1 GB.

## Created objects and data

- Keyspace: `care_continuum`.
- Table: `clinical_events_by_patient_month`.
- Eight synthetic teaching records:
  - `DEMO-01` / `2026-08`: 2 rows.
  - `DEMO-01` / `2026-09`: 4 rows.
  - `DEMO-02` / `2026-09`: 2 rows.

These are clearly labelled demonstration records, not imported Oracle data.

## Commands exercised

```powershell
./cassandra/setup.ps1 -Seed
./cassandra/verify.ps1 -Restart
docker compose -f cassandra/compose.yaml cp cassandra/queries.cql cassandra:/tmp/da3-queries.cql
docker compose -f cassandra/compose.yaml exec -T cassandra cqlsh -f /tmp/da3-queries.cql
```

## Results

| Check | Result |
| --- | --- |
| Compose configuration and PowerShell syntax | Passed |
| Schema creation and sample inserts | Passed |
| Patient/month partition separation | Passed |
| Same-date records distinguished by event ID | Passed |
| Date-range query | Passed |
| Newest-first clustering order and LIMIT | Passed |
| Repeated seed does not duplicate records | Passed |
| Insert/read/update/delete of disposable test record | Passed |
| Data survives container restart | Passed |
| Every explained query in `queries.cql` executes | Passed |
| Container healthy after verification | Passed |

The temporary `DEMO-VERIFY` and `DEMO-CRUD` test rows were deleted. The eight seed records remain available for learning.

## Remaining work

Oracle import, backend Cassandra driver/API, website timeline, hosted database, and production verification have not been implemented yet. Oracle was not accessed or modified by this stage. The existing Vercel application remains unchanged. A single-node local setup is not evidence of replication, scale-out, or failover.
