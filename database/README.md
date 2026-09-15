# Oracle database

`telemedicine_ehr.sql` contains the complete reproducible schema, constraints, indexes, sample records, sequences, invoice calculation function, patient-registration procedure, appointment-status procedure, and allergy-conflict trigger.

The DA2 evidence scripts are:

- `queries.sql`: 14 labelled SQL demonstrations covering selection, joins, outer joins, aggregation, subqueries, composite keys, `LISTAGG`, timestamps, a PL/SQL function, a set operation, safety auditing, and all 18 project tables.
- `trigger_demo.sql`: safely attempts a conflicting Amoxicillin prescription for a patient with a recorded Penicillin allergy and prints a PASS message when the trigger rejects it.

Recommended SQL Developer demonstration order:

1. Run `telemedicine_ehr.sql` in a disposable project schema.
2. Run `queries.sql` one labelled query at a time and capture the useful result grids.
3. Enable DBMS Output and run `trigger_demo.sql`.
4. Show that `PREVENT_ALLERGIC_PRESCRIPTION`, the two procedures, and the function are valid in the schema object browser.

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
