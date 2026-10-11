# D.A. 3 demonstration and completion checklist

## Verified local implementation

- [x] Actual Apache Cassandra runs locally with persistent storage.
- [x] One keyspace/table, synthetic seeds, and explained CQL examples exist.
- [x] CRUD, month partitions, date ranges, ordering, and restart persistence passed local checks.
- [x] Oracle import reads a consistent source snapshot without writing to Oracle.
- [x] 55 source records imported into 18 patient/month partitions in the verification snapshot.
- [x] Source dates and summaries match the imported records.
- [x] Repeated import creates no duplicates.
- [x] Protected timeline API validates inputs and signs paging cursors.
- [x] Real paging returns the complete partition without repeated/missing rows.
- [x] Cassandra outage returns 503 while Oracle patient reads still succeed.
- [x] Cassandra reconnects after recovery.
- [x] Original allergy, history, laboratory, and billing regressions pass with test writes rolled back.
- [x] Eight backend tests pass; frontend source lint and production build pass.
- [x] Backend/root dependency audit reports no known production vulnerabilities.
- [x] Final hosted database connection, data import, and Vercel production verification.
- [ ] Handwritten report, sanitized screenshots, and team rehearsal.

The import counts describe the tested snapshot, not a permanent expected number. Newly added Oracle records increase the count after another import.

## Suggested demonstration

1. Open the existing Oracle medical-history page and select `PAT-01`.
2. Show the Cassandra timeline for August 2026, then September 2026.
3. Explain the partition key and clustering columns using `cassandra/schema.cql`.
4. Execute the short examples in `cassandra/queries.cql`: partition read, date range, LIMIT, then isolated CRUD.
5. From `backend`, run `npm run timeline:import` and explain the read-only Oracle snapshot and CQL upserts.
6. Run the import again and show that rows are not duplicated.
7. Explain why an Oracle change needs another import before it appears in Cassandra.
8. Show `npm run timeline:verify -- --outage` results: timeline fails gracefully, Oracle works, then Cassandra recovers.
9. Explain Oracle versus Cassandra using `DA3_COMPARISON.md`.
10. Demonstrate the hosted timeline only after cloud deployment is actually verified.

CRUD teaching rows are disposable demo records. Do not use direct Cassandra update/delete examples to edit imported clinical records, whose source remains Oracle.

## Report outline

- Existing project and the purpose of the Cassandra extension.
- Oracle/Express/React/Cassandra architecture.
- One table's columns, partition key, clustering columns, and sample rows.
- Explained CQL operations and their observed output.
- Oracle import procedure, stable identities, and manual synchronization.
- Website evidence, test results, and failure isolation.
- Technology comparison, limitations, and actual deployment status.
- Team contributions and references.

Every student should be able to explain the database model and queries. Replication, scale-in/scale-out, and backup/restore demonstrations remain optional additions until faculty confirms that practical evidence is required. Do not claim a one-node setup proves those properties.
