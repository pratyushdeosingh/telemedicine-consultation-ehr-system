# Oracle database scripts

| File | Purpose |
| --- | --- |
| `telemedicine_ehr.sql` | Complete fresh-schema setup: 18 tables, keys/checks/indexes, base and extended synthetic sample data, sequences, procedures, function and two triggers. |
| `academic_seed.sql` | Idempotent extended sample-data load for an existing schema. Adds reserved `-S01` through `-S17` records and validates at least 25 rows per table. |
| `queries.sql` | 14 labelled SQL/PLSQL examples: selection, joins, aggregation, subqueries, set operations, composite keys and calculations. |
| `trigger_demo.sql` | Attempts an allergy-conflicting medicine and checks rejection by ORA-20002. |
| `da2_upgrade.sql` | Adds allergy metadata/rule to an existing compatible schema without recreating its records. |
| `telemedicine_session_trigger.sql` | Installs the automatic virtual-session trigger on an existing schema. |

Schema and sample data are combined in `telemedicine_ehr.sql`. The creation order is significant: base/sample rows load before triggers are installed. Splitting/reordering those statements could generate unwanted duplicate session rows. The setup runner uses this existing file directly.

## Fresh setup

Configure `backend/.env` for a new project schema. From `backend/`:

```powershell
npm ci
npm run db:setup
```

**This drops and recreates project tables. Use a new/disposable schema, never a database whose existing records must be retained.** The schema needs privileges to create tables, indexes, sequences, procedures/functions and triggers. The runner prints record counts and the PL/SQL objects it installs. SQLcl/SQL Developer can also run the file as a script.

## Existing schema

Apply only relevant upgrades from `backend/`:

```powershell
npm run db:upgrade-da2
npm run db:telemedicine-trigger
npm run db:seed-academic
```

The sample expansion preserves existing rows, reuses reserved keys on repeated runs, checks the 25-row minimum and commits after validation. Fresh setup already includes this expansion. It contains 25 rows per table, except MEDICINE and PRESCRIPTION_ITEM with 26; existing databases can have more.

## Queries and verification

```powershell
npm run db:queries
npm run db:verify-workflows
```

The workflow verifier checks live Oracle constraints, allergy rejection/rollback, virtual-session creation, laboratory workflows and invoice transitions, then rolls back its synthetic changes. It does not recreate the schema. `db:test-trigger` runs the standalone allergy example; DBMS Output is directly visible in SQLcl/SQL Developer with server output enabled.

`npm run db:generate-academic-seed` deterministically regenerates the standalone seed and its matching block in the combined setup script; it does not connect to Oracle. Cassandra DDL and seeds are in [cassandra/](../cassandra/README.md).

See [relational schema](../docs/relational-schema.md), [normalization](../docs/normalization.md), [tests](../tests/README.md) and [screenshots](../screenshots/README.md).
