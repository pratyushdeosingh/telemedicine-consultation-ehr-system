# Telemedicine Consultation and EHR System

An academic full-stack implementation of a telemedicine and Electronic Health Record workflow. Oracle stores the relational data and PL/SQL business rules, Express exposes the database through JSON APIs, and React renders the dashboard and write forms.

This repository contains the complete DA2 implementation, local run instructions, database evidence scripts, and report preparation material. It uses synthetic demonstration data only.

## 1. Implemented features

| Area | Implemented behaviour |
| --- | --- |
| Patients | Search and list patients; register a patient through the Oracle procedure |
| Appointments | List joined patient/doctor/department details; book appointments; update appointment status through PL/SQL |
| Prescriptions | Group medicine rows into prescriptions; calculate item costs; create a prescription and medicine item |
| Allergy safety | Oracle trigger rejects a medicine when its allergen class matches a recorded patient allergy |
| Laboratory data | APIs return lab orders, catalog information, results, remarks, dates, and document metadata |
| Telemedicine | API returns session timing, network quality, meeting, and transcript metadata |
| Billing | Compares stored invoice totals with totals calculated by a PL/SQL function |
| Dashboard | Summarises patient, appointment, prescription, and billing data |
| Data states | Loading, empty, error, retry, preview-data, and Oracle-connection states |
| DA2 evidence | Reproducible schema, 14 SQL demonstrations, trigger proof, checklist, and report draft |

The current web interface has six routes: Overview, Patients, Appointments, Prescriptions, Billing, and System Flow. Laboratory, medical-log, and telemedicine data are available through the backend but do not currently have dedicated frontend pages.

## 2. Architecture and request flow

```text
Browser
  ↓
React 19 + Vite frontend
  ↓ fetch('/api/...')
Vite development proxy
  ↓
Express 5 REST API
  ↓ parameterized SQL / PL/SQL through node-oracledb Thin mode
Oracle Database
```

1. A page calls an operation in `frontend/src/api/client.js`.
2. In local development, Vite forwards `/api` to Express on port `3000`.
3. Express obtains an Oracle connection, executes SQL or PL/SQL, and maps rows to JSON.
4. Write routes explicitly commit successful transactions and roll back failures.
5. `useApiResource` tracks loading, success, error, and retry state.
6. React renders the returned records. Oracle remains the authoritative data store.

The Vite proxy is only for local development. A deployed frontend must use the public HTTPS backend URL in `VITE_API_URL`.

## 3. Technology stack

| Layer | Technology | Project role |
| --- | --- | --- |
| Database | Oracle Database | Tables, relationships, constraints, sequences, sample data, SQL, and PL/SQL |
| Database driver | `node-oracledb` 7 | Executes Oracle SQL and PL/SQL from Node.js in Thin mode |
| Backend | Node.js + Express 5 | Validation, REST routes, transactions, CORS, and JSON responses |
| Frontend | React 19 | Routed dashboard pages, forms, filters, and data presentation |
| Development/build | Vite 8 | Frontend development server, `/api` proxy, and production build |
| Routing | React Router 7 | Client-side navigation and fallback route |
| Icons | Lucide React | Interface icons |
| Frontend checks | Oxlint | JavaScript and React linting |

## 4. Oracle database design

The schema contains exactly 18 project tables.

| Table | Significance |
| --- | --- |
| `INSURANCE_PROVIDER` | Stores policy provider and coverage-limit master data |
| `DEPARTMENT` | Stores hospital departments and locations |
| `PHARMACY` | Stores pharmacies used to dispense prescriptions |
| `MEDICINE` | Stores medicine, dosage form, price, and allergen classification |
| `LAB_TEST_CATALOG` | Stores test names, categories, and standard costs |
| `PATIENT` | Stores patient identity, address, demographics, emergency contact, and optional policy |
| `DOCTOR` | Stores doctor contact, specialization, and department relationship |
| `PATIENT_PHONE` | Represents the patient's multivalued phone numbers |
| `DOCTOR_QUALIFICATION` | Represents the doctor's multivalued qualifications |
| `MEDICAL_LOG` | Stores sequenced diagnoses and attachment metadata for a patient |
| `LOG_ALLERGIES` | Stores allergies associated with patient medical logs |
| `APPOINTMENT` | Connects a patient and doctor for a dated in-person or virtual consultation |
| `TELEMEDICINE_SESSION` | Stores session timestamps, network state, and transcript metadata for virtual care |
| `PRESCRIPTION` | Stores the prescription header, pharmacy, issue date, and notes |
| `PRESCRIPTION_ITEM` | Stores each medicine, dosage, duration, and quantity in a prescription |
| `LAB_ORDER` | Connects an appointment to an ordered catalog test and priority |
| `TEST_RESULT` | Stores one or more reported results for a lab order |
| `BILLING_INVOICE` | Stores invoice totals and payment status for an appointment |

Integrity is enforced with primary keys, composite keys, foreign keys, `NOT NULL`, `UNIQUE`, and domain `CHECK` constraints. Composition-style children use cascading deletes where appropriate; optional insurance and pharmacy relationships use `ON DELETE SET NULL`. Six indexes support common foreign-key lookups.

### PL/SQL and generated identifiers

| Object | Type | Purpose |
| --- | --- | --- |
| `SEQ_PATIENT_ID` | Sequence | Generates the numeric portion of new patient IDs |
| `SEQ_APPOINTMENT_ID` | Sequence | Generates the numeric portion of appointment IDs |
| `SEQ_INVOICE_ID` | Sequence | Reserved for generated invoice IDs |
| `CALCULATE_INVOICE_TOTAL` | Function | Adds prescription-item costs and lab catalog costs for an appointment |
| `REGISTER_NEW_PATIENT` | Procedure | Creates the next patient ID and inserts a patient |
| `UPDATE_APPOINTMENT_STATUS` | Procedure | Updates status and raises an error for an unknown appointment |
| `PREVENT_ALLERGIC_PRESCRIPTION` | Trigger | Rejects an inserted or changed prescription item that conflicts with a recorded allergy |

## 5. REST API contract

The API runs at `http://localhost:3000` by default.

| Method | Route | Database operation |
| --- | --- | --- |
| `GET` | `/` | Confirms that Express is running; does not query Oracle |
| `GET` | `/api/test-db` | Executes a small Oracle connectivity query |
| `GET` | `/api/patients` | Reads patients |
| `GET` | `/api/doctors` | Joins doctors with departments |
| `GET` | `/api/medicines` | Reads medicine and allergen reference data |
| `GET` | `/api/pharmacies` | Reads pharmacy reference data |
| `GET` | `/api/medical-logs` | Joins medical logs with patients and allergies |
| `GET` | `/api/lab-orders` | Joins lab orders, appointments, patients, and test catalog |
| `GET` | `/api/test-results` | Joins test results to orders, catalog entries, and patients |
| `GET` | `/api/telemedicine-sessions` | Joins virtual sessions with appointment participants |
| `GET` | `/api/appointments` | Joins appointments with patients, doctors, and departments |
| `GET` | `/api/prescriptions` | Joins prescription headers, items, medicines, patients, doctors, and pharmacies |
| `GET` | `/api/billing` | Returns stored totals and `CALCULATE_INVOICE_TOTAL` results |
| `POST` | `/api/patients` | Calls `REGISTER_NEW_PATIENT` and commits the patient |
| `POST` | `/api/appointments` | Inserts and commits an appointment |
| `POST` | `/api/prescriptions` | Inserts one header and its items as a single transaction |
| `PUT` | `/api/appointments/:appointment_id/status` | Calls `UPDATE_APPOINTMENT_STATUS` and commits the change |

Missing required request fields return HTTP `400`. An allergy conflict returns HTTP `409` and the complete prescription transaction is rolled back. The database health route returns HTTP `503` when required database configuration is missing. Other Oracle failures return HTTP `500`.

## 6. Maintained project files

Generated directories such as `.git`, `node_modules`, and `frontend/dist` are intentionally excluded because they are not maintained source files.

### Repository root

| File | Significance |
| --- | --- |
| `README.md` | Authoritative project architecture, inventory, setup, operation, and troubleshooting guide |
| `.gitignore` | Excludes dependencies, secrets, generated output, logs, editor files, and local Oracle runtime files from Git |

### `database/`

| File | Significance |
| --- | --- |
| `telemedicine_ehr.sql` | Destructive, reproducible creation of all 18 tables, constraints, indexes, seed records, sequences, function, procedures, trigger, and verification queries |
| `da2_upgrade.sql` | Idempotent, non-destructive upgrade for an older local schema; adds allergen metadata and the safety trigger while retaining user-created records |
| `queries.sql` | Fourteen labelled DA2 SQL demonstrations covering filtering, joins, outer joins, grouping, `HAVING`, subqueries, arithmetic, `LISTAGG`, timestamps, function use, set operations, safety, and all-table counts |
| `trigger_demo.sql` | Attempts the known Penicillin/Amoxicillin conflict, expects Oracle error `-20002`, and proves that no rejected row persists |
| `README.md` | Database-specific execution order and warnings |

### `backend/`

| File | Significance |
| --- | --- |
| `.env.example` | Names the required Oracle, server-port, and CORS settings without containing secrets |
| `package.json` | Backend dependencies and start, test, schema, upgrade, query, and trigger-test commands |
| `package-lock.json` | Locks the exact npm dependency graph for reproducible installation |
| `server.js` | Express application, all 17 routes, Oracle queries, validation, commit/rollback handling, and response mapping |
| `scripts/setupDatabase.js` | Parses and executes the complete destructive schema script; ignores only expected missing-object cleanup errors |
| `scripts/runSqlFile.js` | Executes a specified SQL/PLSQL evidence file and prints query rows without rebuilding the database |
| `README.md` | Backend-only setup and API reference |

### `frontend/`

| File | Significance |
| --- | --- |
| `.env.example` | Documents the API base URL and preview/live data switch |
| `.gitignore` | Excludes frontend dependencies, builds, local environment files, logs, and editor metadata |
| `.oxlintrc.json` | Enables React/Oxc lint plugins, enforces Rules of Hooks, and warns about unsafe component exports |
| `index.html` | Vite HTML entry document containing the React mount element |
| `package.json` | Frontend dependencies and development, lint, build, and preview scripts |
| `pnpm-lock.yaml` | Locks the exact pnpm dependency graph |
| `vite.config.js` | Enables React and proxies local `/api` requests to Express on port `3000` |
| `README.md` | Frontend-only startup summary |

### `frontend/src/`

| File | Significance |
| --- | --- |
| `main.jsx` | Mounts React, enables browser routing, and loads global styles |
| `App.jsx` | Defines the six page routes inside the common application shell and redirects unknown routes |
| `index.css` | Complete visual system, responsive layout, forms, tables, states, and reduced-motion handling |
| `api/client.js` | Central fetch wrapper, endpoint operations, JSON error handling, demo/live switching, and write protection in preview mode |
| `api/demoData.js` | Synthetic frontend-only records used when the Oracle API is deliberately disabled |
| `hooks/useApiResource.js` | Reusable loading, result, error, unmount-safety, reload, and retry lifecycle |
| `utils/formatters.js` | Shared date, initials, Indian currency, and status-tone formatting |

### `frontend/src/components/`

| File | Significance |
| --- | --- |
| `ActionFeedback.jsx` | Renders success or failure feedback after form actions |
| `AppShell.jsx` | Provides navigation, responsive sidebar, header, connection status, and nested-page outlet |
| `CareContinuum.jsx` | Displays patient-to-billing stage counts on the overview |
| `ConnectionStatus.jsx` | Checks `/api/test-db` and distinguishes preview, checking, connected, and offline states |
| `DataState.jsx` | Supplies consistent loading, error/retry, and empty-record components |
| `PageHeader.jsx` | Standard page title, description, eyebrow, and action layout |
| `SearchField.jsx` | Accessible reusable search input |
| `SectionPlaceholder.jsx` | Currently unused reusable placeholder for a section that is intentionally unavailable |
| `StatusBadge.jsx` | Maps semantic status tones to a shared badge presentation |
| `Surface.jsx` | Shared card/surface wrapper with selectable HTML element |

### `frontend/src/pages/`

| File | Significance |
| --- | --- |
| `OverviewPage.jsx` | Loads the four principal resources together and derives dashboard summaries |
| `PatientsPage.jsx` | Searches patients and submits the registration form |
| `AppointmentsPage.jsx` | Filters, lists, creates, and updates appointments using doctor and patient reference data |
| `PrescriptionsPage.jsx` | Groups medicine-level API rows and creates a prescription with its first item |
| `BillingPage.jsx` | Filters invoices and highlights differences between stored and calculated totals |
| `SystemFlowPage.jsx` | Explains the application layers and principal API routes for demonstration |

### `docs/`

| File | Significance |
| --- | --- |
| `DA2_CHECKLIST.md` | Tracks implemented requirements and the remaining screenshot, report, and rehearsal work |
| `DA2_REPORT_DRAFT.md` | Accurate technical content to transfer into the required handwritten DA2 report |
| `README.md` | Explains what project evidence belongs in the documentation directory |

## 7. Environment configuration

Never commit `.env`, `.env.local`, passwords, wallets, or connection strings.

### Backend: `backend/.env`

Create it from `backend/.env.example`:

```env
ORACLE_USER=your_project_schema_user
ORACLE_PASSWORD=your_password
ORACLE_CONNECT_STRING=localhost:1521/FREEPDB1
PORT=3000
CORS_ORIGIN=http://localhost:5173
```

`ORACLE_CONNECT_STRING` must match the service configured on the machine. Common local services include `FREEPDB1` and `XEPDB1`; use the actual service rather than copying either value blindly.

### Frontend: `frontend/.env.local`

Live Oracle-backed mode:

```env
VITE_API_URL=/api
VITE_USE_DEMO_DATA=false
```

Frontend-only preview mode:

```env
VITE_API_URL=/api
VITE_USE_DEMO_DATA=true
```

Preview mode never contacts Oracle and deliberately blocks write requests. Restart Vite after changing either variable.

## 8. First-time local setup

### Prerequisites

- Git
- Node.js 20 or newer
- npm for the backend
- pnpm through Corepack for the frontend
- Oracle Database with an accessible pluggable database/service
- A project schema that is safe to populate

### 1. Install dependencies

Open PowerShell in the repository root:

```powershell
cd backend
npm ci

cd ..\frontend
corepack enable
pnpm install
```

### 2. Create local environment files

```powershell
cd ..\backend
Copy-Item .env.example .env

cd ..\frontend
Copy-Item .env.example .env.local
```

Edit the copied files with the correct local settings. Credentials stay only in `backend/.env`.

### 3. Initialize a new disposable project schema

From `backend/`:

```powershell
npm run db:setup
```

**Warning:** `db:setup` drops and recreates the 18 project tables. Do not run it against a schema containing records you need to retain.

For an existing project database created before the allergy-safety enhancement, retain its records with:

```powershell
npm run db:upgrade-da2
```

## 9. Starting the complete application

Use two terminals and start the backend before the frontend.

### Terminal 1 — Express and Oracle

```powershell
cd "path\to\telemedicine-ehr-da2\backend"
npm start
```

Expected address: `http://localhost:3000`

Verify:

```powershell
Invoke-RestMethod http://localhost:3000/
Invoke-RestMethod http://localhost:3000/api/test-db
```

The second command must report `Oracle connection successful`.

### Terminal 2 — React and Vite

```powershell
cd "path\to\telemedicine-ehr-da2\frontend"
pnpm dev
```

Open `http://localhost:5173`. In live mode the sidebar badge must say **Oracle connected**.

To stop either development server, focus its terminal and press `Ctrl+C`.

## 10. Database evidence and verification commands

Run from `backend/` after the schema exists:

```powershell
# Executes all 14 labelled queries and prints their rows
npm run db:queries

# Proves that the allergy trigger rejects the conflict and persists zero rows
npm run db:test-trigger
```

For report screenshots, run `database/queries.sql` one query at a time in SQL Developer and enable DBMS Output before running `database/trigger_demo.sql`.

## 11. Quality checks

Backend:

```powershell
cd backend
npm test
```

Frontend:

```powershell
cd frontend
pnpm lint
pnpm run build
pnpm preview
```

Before the final demonstration, test every GET route, one successful write of each supported type, the rejected allergy-conflict prescription, transaction rollback, and invoice reconciliation.

## 12. DA2 demonstration order

1. Present the DA1 ER diagram and explain its mapping to the 18 tables.
2. Show keys, constraints, indexes, sequences, and valid PL/SQL objects in Oracle.
3. Execute selected reports from `database/queries.sql`.
4. Run `database/trigger_demo.sql` and show that the rejected row count is zero.
5. Start Express and prove `/api/test-db`.
6. Start Vite in live mode and confirm **Oracle connected**.
7. Trace one patient or appointment from Oracle to API JSON to the page.
8. Create a record on the website and verify it in Oracle.
9. Attempt the Penicillin/Amoxicillin conflict and explain HTTP `409` plus rollback.
10. Show zero billing variance.

The implementation status and remaining human evidence work are tracked in `docs/DA2_CHECKLIST.md`.

## 13. Branch workflow

| Branch | Responsibility |
| --- | --- |
| `database` | Original Oracle schema contribution |
| `backend` | Original Express and Oracle API contribution |
| `frontend` | Active integration and frontend work branch |
| `main` | Reviewed integrated project and deployment source |

Continue implementation on `frontend`. After tests and review, fast-forward or merge the approved commit into `main`. Do not rewrite teammate branches. At the time of this README update, `frontend` and `main` contain the same integrated DA2 implementation.

Do not commit `.env`, `.env.local`, Oracle credentials, wallets, `node_modules`, or generated `dist` files.

## 14. Troubleshooting

### The website says `API offline`

Confirm that Express is running on port `3000`, `backend/.env` contains correct credentials, Oracle is running, `/api/test-db` succeeds directly, and `VITE_USE_DEMO_DATA=false`. Restart Vite after editing environment variables.

### The website says `Preview data`

Set `VITE_USE_DEMO_DATA=false` in `frontend/.env.local` and restart Vite. Preview records are not valid proof of Oracle integration.

### Oracle returns a connection error

Check the listener, pluggable database state, username, password, host, port, and service name. `FREEPDB1` and `XEPDB1` are examples, not interchangeable defaults.

### A write reports an allergy conflict

This is expected when the selected medicine's `Allergen_Class` matches an allergy recorded for the appointment's patient. The database trigger rejects the item and Express rolls back the prescription transaction.

### Invoice totals differ

Compare prescription quantities and unit prices, lab catalog costs, duplicate joins, `CALCULATE_INVOICE_TOTAL`, and the stored invoice. The seeded dataset is expected to have zero variance.

### A route refresh returns 404 after deployment

The host needs a single-page-application fallback that sends unknown frontend paths to `index.html`. This is separate from the local React Router fallback.

## 15. Scope and security

This is an academic prototype, not a production healthcare system. The recommended student deployment is [Vercel Hobby with Oracle Autonomous Database](deploy/VERCEL.md). The [Oracle VM](deploy/README.md) and [Azure App Service](deploy/AZURE_APP_SERVICE.md) guides describe alternatives. Vercel mode adds a shared demo login, secure session cookie, wallet-based Oracle mTLS, and a daily database keepalive. The application does not provide individual accounts, role-based authorization, audit logging, consent management, or healthcare regulatory compliance. Do not store real patient information.

## 16. Short viva explanation

> This is a three-layer telemedicine EHR system. Oracle stores 18 normalized relational tables and enforces integrity and business rules with constraints and PL/SQL. Express exposes parameterized SQL and PL/SQL operations as REST endpoints with explicit commit and rollback handling. React consumes those endpoints to present and update selected healthcare workflows. The database also prevents a medicine from being prescribed when its allergen class conflicts with a patient's recorded allergy, and billing totals are independently recalculated for reconciliation.
