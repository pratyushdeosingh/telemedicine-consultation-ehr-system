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

## Cloud and production verification

Astra DB Free was selected on 11 October 2026. The Serverless (non-vector) database `care-continuum-da3` is Active in AWS Ohio (`us-east-2`) with keyspace `care_continuum`. A custom role limits CQL connection, schema description, table creation, and record selection/modification to this keyspace. Its token expires on 9 January 2027; credentials are stored in ignored backend configuration and Vercel Production secrets, never in Git or frontend code.

The existing keyspace's timeline table was created without removing rows. All 55 Oracle source events imported into 18 cloud partitions with zero failures. The verification script confirmed matching source dates/summaries, repeat imports without duplicates, real API paging without missing/duplicate records, ordering, invalid-month rejection, empty partitions, and successful health checks. All eight backend tests passed with loopback network access enabled.

The verified branch was fast-forwarded to `main` and pushed at commit `197cdcb`. Vercel deployment `3Xzm1ogehUyuJeeVmzD8EWZPMCvV` reached Ready and serves the production domain. The live Oracle patients endpoint and both timeline endpoints returned 401 without a session. Authenticated browser checks confirmed PAT-01's two August history entries, five September events (result, appointment, invoice, order, prescription), and December's empty state. Oracle remained connected; nine lab orders/results and eight invoices loaded with their existing controls. Screenshot evidence is stored in `screenshots/da3-production-timeline.png`.

The final Oracle workflow regression again passed, including the real allergy conflict/rollback and billing protections; all verification writes were rolled back. Production verification used reads only. Cloud API paging was tested through the local backend connected to Astra; the browser smoke test checked production timeline reads and month behavior.

## Website refresh enhancement verification (11 October 2026)

The dedicated Cassandra Timeline route, desktop/mobile navigation, separate Oracle/Cassandra indicators, patient-specific medical-history link, and Refresh from Oracle button are implemented. The HTTP endpoint shares import orchestration with the CLI, keeps the shared Cassandra client alive, closes its read-only Oracle snapshot, limits website datasets, bounds dispatch time, and reports partial completion honestly.

Thirteen backend tests passed, including import authentication/origin checks, source truncation rejection, deadlines, constrained write concurrency, instance overlap rejection, and sanitized partial/unavailable outcomes. Frontend lint and production build passed. Real source-parity and paging verification again confirmed the 55-event, 18-partition snapshot.

The new real HTTP verifier inserted one uniquely marked disposable Oracle history entry. Before refresh it was absent in Cassandra; refresh imported 56 source events including the fixture. Repeated refresh did not create duplicates. The verifier removed its fixture from both Oracle and Cassandra, restoring the 55-event snapshot. No existing demonstration record was changed by that verifier.

Browser checks confirmed a 55-record refresh result, five PAT-01 September entries, month selection preserved in the URL, December's empty state, and the medical-history link. A controlled local `CASSANDRA_ENABLED=false` run showed Oracle connected and Cassandra not configured. Refresh displayed the failure; restoring configuration and clicking Retry completed the import and restored both connected indicators. The 390-pixel phone layout fits all eight navigation items without horizontal overflow. Original Oracle workflow regressions passed with test writes rolled back.

Local browser evidence is stored in `screenshots/da3-refresh-local.png`. Production verification of this enhancement follows the deployment.

## Remaining academic deliverables

The handwritten report and demonstration rehearsal remain student work. Multi-node replication/scale demonstrations require a separate confirmed requirement and have not been claimed as tested.
