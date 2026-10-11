# D.A. 3 implementation plan

Status: local Cassandra setup, schema, eight synthetic records, CQL demonstrations, and restart-persistence verification completed on 11 October 2026. Oracle import and the authenticated API/website timeline are implemented and verified locally and with Astra DB Free. The release is deployed on Vercel, where timeline records, month switching, empty months, authentication protection, and existing Oracle laboratory/billing pages were verified. No deadline is used to size or prioritize this work.

## 1. Objective

Extend Care Continuum with Apache Cassandra while retaining Oracle for the existing clinical and billing workflows. Add a patient record timeline that the website actually reads from Cassandra, and provide reproducible CQL schema, dataset, operations, verification, and report material.

The aim is a small implementation that the student can explain confidently. A working query and its explanation are both part of completion.

## 2. Agreed boundaries

### Core deliverables

- Actual Apache Cassandra running locally through Docker.
- One application keyspace and one query-specific timeline table.
- A small synthetic sample dataset.
- Basic CQL creation, insertion, retrieval, update, and deletion demonstrations.
- A repeatable import of selected Oracle records into Cassandra.
- A protected backend timeline API and a website view.
- Oracle/Cassandra comparison, query explanations, and demonstration instructions.
- Integration checks and data-preserving release instructions.

### Deferred unless needed

- Automatic real-time synchronization and a durable event queue.
- A second query-specific Cassandra table.
- A multi-node replication or scale-in/scale-out demonstration.
- Full cluster backup/recovery administration.
- Replacing Oracle, moving billing/allergy enforcement to Cassandra, or rebuilding the existing schema.

The provided D.A. guidelines require a model, implementation, sample data, operations, technology-specific queries, comparison, handwritten report, and demonstration. The syllabus additionally includes scale-in/scale-out, replication, backup/restore, and cloud integration. Confirm whether these need practical evidence for this particular assignment before expanding the core scope. A one-node demonstration must not be presented as proof of replicated failover.

## 3. Architecture and ownership

```text
React interface
      |
Express API
      |
      +-- Oracle: authoritative patients, history/allergies, appointments,
      |           prescriptions, lab orders/results, invoices
      |
      +-- Cassandra: imported patient record timeline
```

Oracle-backed writes remain unchanged. Cassandra reads have a separate health/error state. If Cassandra is unavailable, the existing Oracle pages must continue working.

The first version uses an explicit import command. Creating a new Oracle record does not immediately update Cassandra: run the import again. The UI and report must state this clearly. Do not report the import as a shared transaction across the two databases.

This is a chronological view of dated records, not an immutable audit log. For example, the current invoice status can appear in an invoice summary, but the Oracle schema does not provide a payment-event timestamp. Do not invent one.

## 4. Query-first Cassandra model

Required read: "Show this patient's records for this month, newest first."

Proposed table:

```cql
CREATE TABLE IF NOT EXISTS clinical_events_by_patient_month (
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
```

Explanation:

- `(patient_id, event_month)` is the partition key: one patient's records for one month belong together.
- `event_time` sorts records chronologically within that partition.
- `event_id` distinguishes records with the same date/time.
- `event_month` uses `YYYY-MM`, derived consistently from the source record's calendar date.
- Names and summaries are stored with the event so the Cassandra read does not need an Oracle join.
- Stable source-derived IDs make repeated imports update the same rows instead of creating duplicates.
- Month partitions bound the growth of one patient's timeline; they are not a measured scalability result from this small dataset.

Use familiar types (`text`, `timestamp`) rather than introducing `timeuuid` unnecessarily. The local keyspace uses a replication factor appropriate to its actual node count. A hosted provider may manage keyspace creation and replication itself.

## 5. Source data and import behaviour

| Source | Event content | Stable source identity |
| --- | --- | --- |
| Medical logs | Dated diagnosis/history and recorded allergy summary | Patient ID + log sequence |
| Appointments | Consultation date, doctor, mode, and current status | Appointment ID |
| Prescriptions | Issue date and medicine summary | Appointment ID + prescription number |
| Lab orders | Ordered test and priority | Order ID |
| Test results | Reported result and remarks | Order ID + result sequence |
| Invoices | Invoice date, stored amount, and current payment status | Appointment ID + invoice number |

Implementation rules:

1. Read source records using short, bound Oracle queries and straightforward joins.
2. Convert them into a consistent event structure in Node.js.
3. Use the source record date, not the time when the import runs.
4. Use prepared CQL inserts with stable primary keys.
5. Import sequentially or with bounded concurrency for the small dataset.
6. Report attempted/successful/failed writes. A partial failure must be visible and retryable.
7. Run the import twice and verify that unchanged records are not duplicated.
8. Restrict update/delete teaching examples to a clearly labelled demonstration patient partition.

An import updates existing summaries and adds new records. It is not a complete reconciliation engine: if a source record is deleted or its key date changes, stale Cassandra rows may remain. Document that limit; only add cleanup logic if the demonstration needs it. No bulk deletion of real application partitions.

## 6. CQL demonstrations

Prepare roughly 8-10 short examples, each with purpose, output, and a plain-language explanation:

1. Create the local keyspace.
2. Create/describe the timeline table.
3. Insert a demonstration event.
4. Retrieve a selected patient/month partition.
5. Retrieve a bounded date range within that partition.
6. Limit the result to a few recent records in a partition.
7. Update one demonstration summary using the full primary key.
8. Delete that demonstration record using the full primary key.
9. Export/import a small demonstration dataset if backup/restore evidence is needed.

Example read:

```cql
SELECT event_time, event_type, summary
FROM clinical_events_by_patient_month
WHERE patient_id = 'PAT-01'
  AND event_month = '2026-09'
LIMIT 10;
```

Avoid `ALLOW FILTERING`, joins, secondary-index demonstrations, materialized views, TTL, and lightweight transactions unless a confirmed requirement calls for them. Filtering event types can happen in the UI over the selected partition's returned rows; explain where that filtering occurs.

Cassandra inserts are upserts: writing the same primary key updates that row. Explain this difference from an Oracle insert that violates an existing primary key.

## 7. Implementation stages and acceptance checks

| Stage | Agent work | Student involvement | Completion check |
| --- | --- | --- | --- |
| 1. Model and learning | Finalize schema, key explanation, and query examples | Understand a partition and clustering key; confirm extra faculty requirements | Student can explain one example row and the read query |
| 2. Local Cassandra | Add Docker configuration with a pinned image and persistent volume; initialize keyspace/table | Start Docker Desktop and complete any OS/WSL prompts | Cassandra starts, accepts CQL, and retains data after restart |
| 3. Sample operations | Add synthetic seed records and demonstration queries | Run examples and inspect their output | CRUD and date-range queries produce expected results |
| 4. Oracle import | Add connection configuration and repeatable import command | Confirm source data is synthetic; learn when to re-import | Multiple patients/months imported; second run adds no duplicates |
| 5. Website integration | Add authenticated API, month/patient controls, timeline rendering, paging, and connection states | Review labels and manually explore example patients/months | Data is read from Cassandra, with useful empty/error states |
| 6. Verification and explanation | Test mapping, queries, failures, and unchanged Oracle workflows; write comparison/evidence guide | Rehearse each operation and capture required evidence | Core tests pass; student can explain all database commands |
| 7. Hosted release | Configure chosen remote Cassandra endpoint, secrets, environment settings, and production smoke checks | Create the cloud account/resource and enter credentials privately | Vercel reads the hosted timeline and Oracle workflows still work |

Stages 1-6 complete the local Cassandra extension. Stage 7 makes it available on the existing live website. Do not mark the hosted integration complete merely because the frontend build succeeds.

## 8. Website behaviour

Add the Cassandra timeline as a labelled section/tab in the existing medical-history area rather than a developer architecture page.

- Select patient and calendar month.
- Display event date, category, summary, and related appointment/source reference.
- Use the table's clustering order for newest-first results.
- Include paging so a query does not silently hide records beyond a limit.
- Distinguish Oracle medical-history records from the imported Cassandra timeline.
- Explain "Imported records; run the import again after Oracle changes."
- Show no-records, loading, retry, and unavailable-service states.
- Keep synthetic/offline preview clearly distinct from real Cassandra reads.

The display should not suggest that missing timeline rows mean there are no Oracle records.

## 9. Proposed files

```text
cassandra/
    compose.yaml          Local Apache Cassandra service and persistent volume
    schema.cql            Keyspace/table definition
    seed.cql              Synthetic demonstration rows
    queries.cql           Explained CQL examples
    README.md             Setup, commands, and limits
backend/
    cassandraConfig.js    Local/hosted connection settings
    timelineRoutes.js     Protected patient/month reads and health check
    scripts/
        importTimeline.js Oracle-to-Cassandra import
        verifyTimeline.js Real database verification with safe demo records
    tests/                Mapping/validation tests where meaningful
frontend/src/             Timeline view and API client integration
docs/
    DA3_IMPLEMENTATION_PLAN.md
    DA3_QUERY_GUIDE.md
    DA3_COMPARISON.md
    DA3_DEMO_CHECKLIST.md
```

Names can change during implementation. Root/backend dependency manifests must both support the driver where necessary for Vercel packaging. Use a reusable driver client, prepared statements, bounded connection timeouts, and no browser-side database credentials.

## 10. Hosting decision

Docker is already installed on this computer. At planning time its Linux-engine pipe was unavailable, so the engine is not currently ready. Start Docker Desktop before local setup; do not install another copy unnecessarily.

Vercel runs the application, not the Cassandra server. A laptop-local container is not reachable from the deployed Vercel API.

For the hosted stage, choose one of:

- **Managed Cassandra-compatible service:** Astra DB supports Cassandra drivers/CQL and secure connection bundles. Confirm faculty acceptance for the hosted demonstration and inspect the current free-plan conditions before creating resources. Describe the provider honestly; the local implementation remains actual Apache Cassandra.
- **Self-hosted Apache Cassandra:** a suitable VM/provider gives direct control but adds server setup, networking, TLS/authentication, monitoring, and potential cost. Choose this only if actual Apache Cassandra is required for the hosted endpoint.

Do not open an unauthenticated Cassandra port to the public internet. Account creation, legal terms, billing choices, and credential entry belong to the student. The agent prepares the configuration and verifies the result after access is set up.

No hosted resource or paid service will be created during the planning phase.

## 11. Optional syllabus demonstrations

Only expand after the core works and practical requirements are confirmed:

- **Replication:** use an actual multi-node local cluster with an appropriate replication factor, show the nodes, and demonstrate a read with a node unavailable under the chosen consistency level.
- **Scale out/in:** add a node, observe membership, then remove it correctly. Do not label replication-factor changes as adding/removing nodes.
- **Export/restore:** use a small logical CSV export/import into a separate demonstration table. Explain that this is data export/restore, not full cluster disaster recovery.
- **LSM trees:** explain commit log, memtable, and SSTables at syllabus level without implementing a storage engine.
- **CAP and ACID/BASE:** explain Cassandra's consistency choices and contrast them with Oracle transactions. Avoid the oversimplification that Cassandra always has one fixed consistency level.

A multi-node cluster is materially more work and needs more memory than the one-node core. Assess the laptop's available resources before promising it. Team members can own cluster evidence/report rehearsal if needed; every member should understand the whole project.

## 12. Test and release checklist

- Local schema and seed scripts are reproducible.
- Same patient in two months reads from distinct partitions.
- Events with equal timestamps remain distinct through `event_id`.
- Patient/month validation rejects invalid requests.
- Date boundaries use a consistent source-calendar convention.
- Repeated imports do not duplicate unchanged events.
- Import failures are reported and can be retried.
- Update/delete examples affect only labelled demo records.
- Timeline paging is exercised.
- Cassandra outage produces a timeline error without breaking Oracle pages.
- Production timeline APIs require login and do not expose secrets.
- Frontend lint/build and relevant backend checks pass.
- Existing Oracle patient, allergy, laboratory, and billing workflows still pass.
- Hosted Cassandra contains the intended synthetic dataset.
- Production shows the new timeline and direct-page routing works.
- The report claims only features actually demonstrated.

Work on a D.A. 3 branch; keep `main` as the working D.A. 2 baseline until checks pass and the extension is ready to release. Schema/data setup runs separately from the Vercel build. No Oracle schema reset is part of this plan.

## 13. Student action list

### Before implementation

1. Open Docker Desktop and wait for the Linux engine to report running. If it requests WSL/virtualization setup or a restart, complete those steps.
2. Confirm whether faculty requires practical replication, scale-in/scale-out, or backup/restore demonstrations for D.A. 3.
3. Decide whether the final Cassandra feature must work on Vercel; if yes, confirm whether Astra is acceptable or actual self-hosted Apache Cassandra is required.

### During implementation

4. Learn the small schema and run the CQL examples with the agent's explanations.
5. Inspect the patient timeline and confirm that the record types are useful and understandable.
6. Keep cloud tokens/bundles/passwords private. Enter them locally or into Vercel/provider settings when instructed, not in chat or Git.
7. Complete any account creation, terms acceptance, billing decision, or OS setup that needs your interaction.

### Before evaluation

8. Prepare the handwritten report using the schema, explained queries, comparison, and verified screenshots.
9. Capture CQL output and the website showing Cassandra-backed data.
10. Rehearse: why two databases, why this partition key, what a repeated insert does, how imports work, and what is not synchronized automatically.
11. Make sure teammates participate and can explain the database design and operations.

The agent handles repository changes, scripts, driver integration, tests, debugging, and documentation. The student does not need to install Cassandra manually if the Docker path works, rewrite Oracle, or replace the frontend stack.

## 14. References

- [Apache Cassandra quickstart](https://cassandra.apache.org/doc/latest/cassandra/getting-started/cassandra-quickstart.html): official Docker setup path.
- [Cassandra logical data modeling](https://cassandra.apache.org/doc/latest/cassandra/developing/data-modeling/data-modeling_logical.html): query-specific tables, partition keys, and clustering columns.
- [CQL data definition](https://cassandra.apache.org/doc/latest/cassandra/developing/cql/ddl.html): schema and key syntax.
- [cqlsh](https://cassandra.apache.org/doc/stable/cassandra/managing/tools/cqlsh.html): CQL shell and small CSV import/export operations.
- [Astra Node.js driver setup](https://docs.datastax.com/en/astra-db-serverless/drivers/nodejs-driver.html): hosted connection using a token and secure connect bundle.

Scope is based on the supplied BACSE202 theory/lab syllabus and D.A. guidelines, with the user's preference for understandable queries and no deadline-driven planning.
