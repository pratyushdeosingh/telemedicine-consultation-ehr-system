# Oracle database

`telemedicine_ehr.sql` contains the complete reproducible schema, constraints, indexes, sample records, sequences, invoice calculation function, patient-registration procedure, and appointment-status procedure.

From the backend directory, configure `.env` and run:

```bash
npm run db:setup
```

This command recreates the project tables and sample data. Use it only with a local or disposable demonstration schema because existing tables with the same names are dropped first.
