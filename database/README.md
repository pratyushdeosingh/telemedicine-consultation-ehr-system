# Oracle database

`telemedicine_ehr.sql` contains the complete reproducible schema, constraints, indexes, sample records, sequences, invoice calculation function, patient-registration procedure, appointment-status procedure, allergy-conflict trigger, and virtual-session creation trigger.

The DA2 evidence scripts are:

- `queries.sql`: 14 labelled SQL demonstrations covering selection, joins, outer joins, aggregation, subqueries, composite keys, `LISTAGG`, timestamps, a PL/SQL function, a set operation, safety auditing, and all 18 project tables.
- `telemedicine_session_trigger.sql`: installs the teammate's trigger on an existing schema without dropping tables. A new Virtual appointment gets a placeholder telemedicine session in the same transaction. Run it as the schema owner after temporarily granting `CREATE TRIGGER`, then revoke that privilege again.
- `trigger_demo.sql`: safely attempts a conflicting Amoxicillin prescription for a patient with a recorded Penicillin allergy and prints a PASS message when the trigger rejects it.

Recommended SQL Developer demonstration order:

1. Run `telemedicine_ehr.sql` in a disposable project schema.
2. Run `queries.sql` one labelled query at a time and capture the useful result grids.
3. Enable DBMS Output and run `trigger_demo.sql`.
4. Show that `PREVENT_ALLERGIC_PRESCRIPTION`, `TRG_CREATE_TELEMEDICINE_SESSION`, the two procedures, and the function are valid in the schema object browser.

From the backend directory, configure `.env` and run:

```bash
npm run db:setup
```

This command recreates the project tables and sample data. Use it only with a local or disposable demonstration schema because existing tables with the same names are dropped first.

For an existing local database that may contain newly entered website records, use the non-destructive path instead:

```bash
npm run db:upgrade-da2
npm run db:queries
npm run db:test-trigger
```

The upgrade retains existing patients and appointments while adding the allergen metadata and safety trigger.

## Academic record minimum

Run `npm run db:seed-academic` from `backend` to add 17 linked synthetic teaching
examples to each of the 18 Oracle tables without removing existing records.
Starting from the original seed, each table has 25 rows (26 for medicine and
prescription items). Existing databases can have higher totals. The script
validates all 18 tables have at least 25 rows before committing and prints every
table's count. Run it through the supplied npm command for rollback on failure.

Synthetic IDs use the reserved `-S01` through `-S17` suffixes. Repeating the seed
does not duplicate these records. Virtual appointments reuse the session created
by the existing trigger. New invoice totals match their medicine and lab costs;
synthetic medicines, doses, and results are labelled teaching examples.
No real report files or working meeting rooms are implied by these examples.

The full `telemedicine_ehr.sql` setup includes the same expansion, so fresh setups
also satisfy the minimum. `npm run db:generate-academic-seed` regenerates both SQL
copies from `scripts/generateAcademicSeed.js`. After seeding, use
`npm run timeline:import` to refresh the Cassandra timeline from Oracle.
