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

## Oracle import and application verification

On 11 October 2026, the driver/API/website stage was implemented and verified:

- Apache Cassandra Node.js driver 4.10.0 installed for local backend and Vercel packaging.
- 55 Oracle source events imported into 18 patient/month partitions using a read-only snapshot.
- All mapped dates and summaries matched the source; a second import created no duplicates.
- Real API paging, month validation, empty states, and authenticated-route protection passed.
- A real Docker Cassandra outage returned HTTP 503 for the timeline while Oracle patient reads remained available; recovery reconnected successfully.
- Original Oracle allergy, history, lab, and billing checks passed with all test writes rolled back.
- Eight backend tests, frontend lint, production build, and documentation link checks passed.
- Backend and root production dependency audit reported zero known vulnerabilities.
- Browser checks confirmed August/September month switching, five September record types for PAT-01, and the empty-month state.
- Screenshot evidence is stored in `screenshots/da3-local-timeline.png` and `screenshots/da3-timeline-detail.png`.

## Remaining work

Astra DB Free was selected on 11 October 2026. The Serverless (non-vector) database `care-continuum-da3` was created in AWS Ohio (`us-east-2`) with keyspace `care_continuum`. A custom role limits CQL connection, schema description, table creation, and record selection/modification to this keyspace; its import token expires on 9 January 2027 and is stored only in ignored backend configuration.

The database subsequently reached **Active**, with its Ohio region **Online**. The in-app browser could not save the Secure Connect Bundle: its download navigated to an expired signed URL, and the button does not expose a downloadable link to the browser's file-download API. A manual ZIP download was requested. Vercel account access was confirmed, and the existing production deployment still points to D.A. 2 commit `e4b4868` on `main`.

The ZIP was subsequently downloaded by the user and configured privately. The existing keyspace's timeline table was created without removing rows. All 55 Oracle source events imported into 18 cloud partitions with zero failures. The verification script confirmed matching source dates/summaries, repeat imports without duplicates, real API paging without missing/duplicate records, ordering, invalid-month rejection, empty partitions, and successful health checks. All eight backend tests also passed with loopback network access enabled.

Vercel release remains pending. No D.A. 3 changes have been merged into the deployed main branch. Multi-node replication/scale demonstrations require a separate confirmed requirement.
