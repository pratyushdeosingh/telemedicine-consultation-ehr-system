# D.A. 3 Oracle and Cassandra comparison

Care Continuum uses Oracle for authoritative clinical and billing workflows and Cassandra for an imported patient timeline. Neither database is presented as universally better.

| Topic | Oracle in this application | Cassandra in this application |
| --- | --- | --- |
| Model | Related, normalized tables | One denormalized table designed for a known query |
| Main read | Joins across patients, consultations, medicines, tests, and invoices | One patient's records for one calendar month |
| Integrity | Foreign keys, constraints, procedures, and triggers | Application validates and maps source records before insertion |
| Writes | Related statements commit together or roll back | Prepared inserts upsert stable timeline keys; an import can partially fail and be retried |
| Ordering | SQL `ORDER BY` | Clustering columns order records within a partition |
| Duplicate identity | Duplicate primary-key insert is rejected | An insert at the same primary key updates the row |
| Current deployment | Oracle Autonomous Database accessed from Vercel | Actual Apache Cassandra 5.0.9 locally; hosted setup pending |
| Suitable role | Prescription rejection and billing transactions | Chronological reads over repeated, dated patient records |

## Why this table fits

The application asks: "Show this patient's records for this month." Partitioning by `(patient_id, event_month)` groups that answer. Clustering by descending `event_time` returns newest records first. `event_id` preserves two distinct records dated on the same day.

Names and summaries are copied into each event. This trades some duplication for a read that does not require an Oracle join. A monthly bucket limits growth of a single patient's partition. The small demonstration dataset is not a scalability benchmark.

## Why retain Oracle

Prescription creation needs a header and medicine items to succeed or fail together, and an allergy trigger must reject the conflict against authoritative records. Billing uses a PL/SQL calculation and controlled payment-status transitions. Those existing relational and transactional rules remain in Oracle.

The Cassandra timeline is not used to approve prescriptions, calculate payments, or infer medical relationships.

## Distributed database topics

- Local Cassandra currently has one node and replication factor one. It has not demonstrated multi-node replication, failover, or scale-out.
- With a real replicated cluster, consistency levels determine how many replica acknowledgements a request requires. Cassandra is not explained as having one fixed consistency setting for every deployment.
- CAP concerns behaviour during a network partition; it is not a rule that every database can freely select any two properties in all circumstances.
- Cassandra's commit log, memtable, and SSTables connect to the syllabus's LSM-tree topic. These are storage-engine concepts, not extra CQL queries the student wrote.

## Synchronization and limits

`npm run timeline:import` reads a consistent, read-only Oracle snapshot and inserts its dated records into Cassandra. Re-running it updates the same source-derived keys. There is no automatic cross-database transaction or live synchronization.

A partial import reports failed identities and returns a failing exit status. Re-running retries those inserts safely. Source deletion or changing a record's key date can leave an old Cassandra row; this version does not perform destructive reconciliation.

Source dates are read using Oracle `TO_CHAR(..., 'YYYY-MM-DD')`. The import represents that calendar date at UTC midnight; the UI renders the source date in UTC. This avoids shifting a record into the preceding month because of a server/browser timezone. It does not invent a clinical event's exact time.

Invoice events use the original billing date and the current imported status. There is no payment-history timestamp or immutable audit-log claim.

Timeline staleness in this implementation comes from manual imports; it should not be described as proof of Cassandra replica-consistency behaviour.

The application driver requests LOCAL_QUORUM, which is supported for the Astra write path. With one local replica, the quorum requires that one replica; this does not demonstrate multi-node quorum behaviour.
