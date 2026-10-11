# D.A. 3 study and presentation guide

## Explain the project in one minute

Care Continuum is the same telemedicine project continued from D.A. 1 and D.A. 2. Oracle stores the operational patient, appointment, prescription, laboratory, and billing records. For D.A. 3, Apache Cassandra adds a patient timeline organized by patient and calendar month. Actual Apache Cassandra 5.0.9 runs locally in Docker; the hosted website uses Astra DB Free, a managed service powered by Cassandra.

The website has a dedicated Cassandra Timeline page. Its Refresh from Oracle button reads a consistent Oracle snapshot and copies mapped events into Cassandra. Reading the timeline then uses a simple query containing the complete partition key. Oracle remains the source for allergy checks, billing calculations, and other business rules.

## Learn these files in this order

1. `cassandra/schema.cql`: keyspace, columns, primary key, and ordering.
2. `cassandra/seed.cql`: eight independent teaching records.
3. `cassandra/queries.cql` and [the query guide](DA3_QUERY_GUIDE.md): runnable CRUD, patient/month reads, date ranges, and LIMIT examples.
4. `backend/timelineImport.js`: familiar Oracle SELECT/JOIN statements and one prepared Cassandra INSERT.
5. `backend/timelineModel.js`: converting six kinds of clinical records into events with stable identities.
6. `backend/timelineRefresh.js`: orchestration, closing the Oracle snapshot, limits, and result counts.
7. `backend/timelineRoutes.js`: health, refresh, and paged timeline endpoints.
8. [The comparison](DA3_COMPARISON.md) and [demonstration checklist](DA3_DEMO_CHECKLIST.md).

React, CSS, Express routing, secure connection bundles, and deployment helpers are supporting application code. You can describe them briefly as the interface/backend/hosting layers and acknowledge AI-assisted implementation. Spend the detailed explanation on the database model, SQL/CQL, transactions, and the comparison.

## Understand the Cassandra primary key

```cql
PRIMARY KEY ((patient_id, event_month), event_time, event_id)
```

| Part | Explanation |
| --- | --- |
| `(patient_id, event_month)` | The composite partition key: one patient's records for one month are grouped together. |
| `event_time` | First clustering column, ordered newest first. |
| `event_id` | Second clustering column, distinguishing different events with the same date/time. |
| Full primary key | Identifies a row: partition values plus both clustering values. |

A keyspace is Cassandra's namespace for related tables and replication configuration. It is comparable to a database/schema container, but it is not exactly the same concept as an Oracle schema.

An event represents medical history, an appointment, a prescription, a lab order, a lab result, or an invoice. Its `summary` is already prepared for display. This deliberate denormalization avoids assembling the timeline through Cassandra joins.

## A simple read you should explain

```cql
SELECT event_time, event_type, summary
FROM care_continuum.clinical_events_by_patient_month
WHERE patient_id = 'PAT-01'
  AND event_month = '2026-09'
LIMIT 5;
```

Both partition-key values are supplied, so the query identifies one patient/month group. The table's clustering order gives newest records first. LIMIT restricts the number returned. In the application, values use placeholders and prepared queries rather than string concatenation.

Do not assume arbitrary SQL-style filters or joins work in Cassandra. The model was designed around this specific read pattern. The teaching examples also demonstrate bounded date ranges within a partition.

## What happens when Refresh from Oracle is clicked?

1. The backend checks the signed-in session and permitted request origin.
2. It opens a Cassandra connection and an Oracle connection.
3. Oracle starts `SET TRANSACTION READ ONLY`; SELECT queries read one consistent snapshot.
4. JavaScript maps Oracle rows into timeline events. A prescription's medicine items become one event summary.
5. The Oracle transaction ends and its connection closes.
6. Prepared CQL INSERT statements copy the events to Cassandra. Four independent writes can run at once.
7. The response reports how many records were refreshed and whether any failed. The page reloads its timeline and rechecks both connections.

No Oracle INSERT, UPDATE, or DELETE is performed by refresh. The two databases do not share one distributed transaction. If Cassandra fails after some inserts, those successful rows remain; the result is partial and can be retried.

The usual maintenance CLI calls the same service. The website has a dataset and time budget so a request cannot run indefinitely. Its overlap guard applies within one backend instance; it is not a distributed lock across all Vercel instances.

## Why do repeated refreshes not duplicate events?

Every source event has a stable identity, for example `medical_history:PAT-01:1` or `invoice:APT-01:INV-01`. The original date, patient, and month also remain stable. Cassandra INSERT with that same complete primary key updates the row. This is called an upsert and makes retrying the same import idempotent.

This is not a complete mirror. If an Oracle source date changes, a new primary key can be produced while the old row remains. Source deletion likewise does not delete the imported event. The current website's refresh adds or updates records; it does not reconcile removals or create an immutable audit history.

## Connection and freshness are different

Oracle connected means its database check succeeded. Cassandra connected means a prepared read against the Cassandra timeline table succeeded. Neither badge means every Oracle change has been imported. After adding or changing an Oracle record, click Refresh from Oracle.

The completion time shown belongs to the current request on this page. It is not a persistent system-wide last-refresh timestamp and disappears on a full reload.

## Oracle versus Cassandra: the justification

Oracle fits related operational records, foreign keys, joins, and transactional business rules. Its existing allergy trigger prevents conflicting prescriptions and rolls back the prescription transaction. Billing amounts and statuses remain controlled by Oracle workflows.

Cassandra fits the additional known patient/month read pattern and illustrates a wide-column model, denormalization, partitions, and ordered clustering. At this small dataset, we do not claim it is faster than Oracle or that another database is necessary for production. The extension demonstrates a modern database technique within the same project.

Both technologies have tradeoffs. The timeline duplicates source information and needs an explicit refresh; its schema is less flexible for arbitrary queries. The [comparison](DA3_COMPARISON.md) explains these boundaries.

## Map the work to your syllabus

| Syllabus concept | Project example |
| --- | --- |
| Relational keys and constraints | D.A. 2 Oracle primary/foreign keys and validation. |
| SQL joins and functions | Import SELECTs join patients, appointments, prescriptions, medicines, orders, results, and invoices; TO_CHAR retains source calendar dates. |
| Transactions and recovery | Oracle read-only snapshot; original workflow rollback tests; partial Cassandra writes and safe retries. |
| NoSQL models | Cassandra wide-column table and query-oriented denormalization. |
| Fragmentation/distribution | Patient/month partition key; distinguish this logical grouping from the actual distribution mechanism. |
| Replication/consistency | Local replication factor is one. Driver queries use LOCAL_QUORUM; with one local replica that requires that one replica. |
| Cloud integration | Astra connection bundle/token, server-side credentials, and Vercel application integration. |

CAP is about what can be guaranteed when a network partition happens, not simply whether a database is SQL or NoSQL. Cassandra supports configurable consistency levels. Our one-node demonstration is not evidence of multi-node availability or replicated failover. Do not claim that Oracle-to-Cassandra importing is Cassandra replication: it is an application-level copy between two different databases.

The lab syllabus also lists scale-in/out and backup/restore. The D.A. 3 guidelines specifically ask for model, implementation, sample data, operations, technology-specific queries, comparison, handwritten report, and demonstration. Local CRUD/persistence and cloud integration are implemented; multi-node scaling/replicated failover and backup/restore are not claimed as practical demonstrations here. If the faculty requires those lab experiments in this D.A., they need a separate demonstration.

## What was actually tested?

- Thirteen backend tests: authentication/origin checks, paging cursor integrity, source date mapping, partial outcomes, source limits, deadlines, overlap rejection, and failure isolation.
- Real Oracle/Astra HTTP refresh: a uniquely marked temporary Oracle history entry appeared only after refresh; a repeated refresh created no duplicates; the fixture was removed from both databases.
- Original Oracle history, allergy trigger, lab, and billing checks: passed with verification writes rolled back.
- Browser: dedicated page, 55-event result, five September PAT-01 records, empty month, connection badges, disabled configuration, recovery/retry, and desktop/mobile layout.
- Earlier local Docker evidence: CRUD, date-range queries, partitions, persistence after restart, and outage/recovery.

Keep the source snapshot counts distinct from permanent requirements: newly created records can increase the count. Read [the setup record](DA3_SETUP_RECORD.md) for production verification evidence.

## Handwritten report outline

The attached guidelines require a handwritten report. Use this outline to write your own explanation:

1. Project title, team details, and continuation from D.A. 1/D.A. 2.
2. Objective and why a patient timeline is the selected Cassandra extension.
3. Oracle/application/Cassandra architecture and each database's role.
4. Cassandra model: keyspace, table, columns, partition key, and clustering order.
5. Synthetic teaching dataset and imported source record types.
6. CQL table creation and selected INSERT, SELECT, UPDATE, DELETE, date-range, and LIMIT examples with explanations/output.
7. Website refresh flow and the read-only Oracle SELECT/JOIN queries.
8. Screenshots: connection indicators, dedicated timeline, refresh result, and selected month.
9. Verification results and partial-failure/retry explanation.
10. Comparison, suitability, and honest limitations.
11. Conclusion and references to the course materials and official documentation.

Explain actual contributions accurately. Each teammate should rehearse the database model, important queries, and the demonstration; the guidelines evaluate individual understanding and participation.

## Suggested demonstration sequence

1. Sign in and show Oracle and Cassandra connected.
2. Open Medical history, select PAT-01, and follow View Cassandra timeline.
3. Choose September 2026 and explain the five event types and original dates.
4. Click Refresh from Oracle; explain its count and the fact it reads Oracle without modifying it.
5. Refresh again and explain why primary keys prevent duplicates.
6. Show an empty month and explain partition-based selection.
7. Present the simple CQL queries and existing local verification evidence.
8. Finish with Oracle/Cassandra suitability and limitations.

If you demonstrate a newly created record, use clearly synthetic data and refresh afterward. Existing academic sample data must remain distinguishable from real patient records.

## Maintenance before your presentation

Check both connections and run one website refresh. Keep the demo password private. Astra uses the Free plan; the scoped application token expires on 9 January 2027 and must be replaced privately before that date if still needed. No paid add-on or plan upgrade is part of this implementation.
