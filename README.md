# Care Continuum

A telemedicine and electronic health record application built with React, Express, and Oracle Database. The project combines patient records, consultations, prescriptions, laboratory tests, and billing with SQL and PL/SQL business rules.

[Live demo](https://telemedicine-consultation-ehr-syste.vercel.app/) · [API reference](backend/README.md) · [Deployment guide](deploy/VERCEL.md)

The deployed application requires a shared demo password and uses synthetic records. The D.A. 2 implementation is complete. D.A. 3 development has started with [local Apache Cassandra setup](cassandra/README.md); Oracle import, the website timeline, and hosted Cassandra integration are subsequent stages.

## Features

| Area | Capabilities |
| --- | --- |
| Patients | Search the directory, register patients, and open their medical history |
| Medical history | Record dated diagnoses, select known medicine allergy classes, and retain other allergies separately |
| Appointments | Book virtual or in-person consultations and update appointment status |
| Prescriptions | Review medicine items, dosage, duration, quantity, and cost; create a prescription with an allergy warning |
| Laboratory | Search orders and results, order catalog tests, and record result values, remarks, and document references |
| Billing | Generate invoices, review charge breakdowns, recalculate pending totals, and record Paid or Refunded status |
| Dashboard | View patient and prescription counts, scheduled consultations, and outstanding invoices |

Oracle rejects prescription items whose medicine class matches a recorded patient allergy. Virtual appointment creation also generates a placeholder telemedicine session through a database trigger. Session metadata is available through the API; the application does not host video calls.

## Architecture

```text
React / Vite
    │ same-origin /api requests
    ▼
Express / node-oracledb
    │ bound SQL and PL/SQL calls
    ▼
Oracle Database
```

During local development, Vite proxies `/api` requests to Express on port 3000. On Vercel, the frontend is served as static files and `/api` routes run in a Node.js function connected to Oracle Autonomous Database over wallet-based mTLS.

Writes commit after all related statements succeed and roll back on failure. Oracle remains the authoritative data store.

## Technology

| Layer | Stack |
| --- | --- |
| Interface | React 19, React Router 7, CSS, Lucide icons |
| Frontend tooling | Vite 8, pnpm, Oxlint |
| API | Node.js 24, Express 5 |
| Database | Oracle Database, SQL, PL/SQL, node-oracledb 7 |
| Hosting | Vercel and Oracle Autonomous Database |

## Repository structure

```text
api/          Vercel function entry point
backend/      Express routes, Oracle configuration, tests, and verification scripts
database/     Oracle schema, sample data, upgrades, and SQL/PLSQL evidence
cassandra/    Local Cassandra service, CQL schema, sample records, and checks
deploy/       Deployment instructions and local configuration helpers
docs/         Workflow explanations, report material, and verification history
frontend/     React application and Vite configuration
vercel.json   Build commands, API routing, SPA fallback, and keepalive schedule
```

## Run locally

### Prerequisites

- Node.js 24 and npm
- pnpm through Corepack or an existing pnpm installation
- An accessible Oracle database and a project schema

Run these commands from the repository root using two terminals.

### 1. Configure and start the backend

```powershell
cd backend
npm ci
if (!(Test-Path -LiteralPath .env)) { Copy-Item .env.example .env }
```

Edit `backend/.env` with your Oracle connection settings:

```dotenv
ORACLE_USER=your_schema_user
ORACLE_PASSWORD=your_schema_password
ORACLE_CONNECT_STRING=localhost:1521/your_service
PORT=3000
HOST=127.0.0.1
CORS_ORIGIN=http://localhost:5173
```

For Autonomous Database, configure the wallet variables documented in [backend/.env.example](backend/.env.example) and the [deployment guide](deploy/VERCEL.md).

If the schema already exists, start the API directly:

```powershell
npm start
```

For a **new, disposable schema only**, initialize the database before starting the API:

```powershell
npm run db:setup
```

**`db:setup` drops and recreates the project tables. Do not run it against the deployed database or records you need to retain.** Existing schemas should use only the applicable non-destructive upgrade scripts described in [database/README.md](database/README.md).

### 2. Configure and start the frontend

In a second terminal, from the repository root:

```powershell
cd frontend
corepack pnpm install --frozen-lockfile
if (!(Test-Path -LiteralPath .env.local)) { Copy-Item .env.example .env.local }
corepack pnpm dev
```

The default frontend configuration uses the real API:

```dotenv
VITE_API_URL=/api
VITE_USE_DEMO_DATA=false
```

Open [localhost:5173](http://localhost:5173). The connection indicator should report **Oracle connected**. Local development does not require the production demo login.

To preview the interface without Oracle, set `VITE_USE_DEMO_DATA=true` and restart Vite. Preview mode uses synthetic frontend data and rejects write requests.

## Database design

The Oracle schema contains 18 related tables covering patients, doctors, departments, pharmacies, medicines, medical logs, allergies, appointments, virtual sessions, lab tests, results, insurance, and invoices. Primary keys, foreign keys, check constraints, and indexes enforce and support the relational design.

| PL/SQL object | Purpose |
| --- | --- |
| `REGISTER_NEW_PATIENT` | Register a patient with a generated identifier |
| `UPDATE_APPOINTMENT_STATUS` | Update status and reject unknown appointments |
| `CALCULATE_INVOICE_TOTAL` | Sum medicine quantities × current unit prices and ordered lab test costs |
| `PREVENT_ALLERGIC_PRESCRIPTION` | Reject a medicine-class allergy conflict |
| `TRG_CREATE_TELEMEDICINE_SESSION` | Create a placeholder session for a new virtual appointment |

Patient and appointment identifiers use Oracle sequences. New lab-order and invoice identifiers are generated by the API. Child history/result numbers are allocated under a parent-row lock.

The [database guide](database/README.md) explains initialization and upgrades. [queries.sql](database/queries.sql) contains 14 labelled database demonstrations.

## Verification

From `backend/`:

```powershell
npm test
npm run db:verify-workflows
```

`npm test` runs syntax and authentication checks. `db:verify-workflows` requires a working Oracle connection and exercises the real HTTP routes and database rules, including history/allergy validation, prescription rollback, lab operations, and invoice transitions. It rolls back all synthetic test changes.

From `frontend/`:

```powershell
corepack pnpm lint
corepack pnpm build
```

Additional database evidence commands are available from `backend/`:

```powershell
npm run db:queries
npm run db:test-trigger
```

## Deployment

The existing Vercel project is connected to GitHub `main`. A push to that branch triggers a production build. The root [vercel.json](vercel.json) defines the frontend build, API routing, and direct-page fallback.

Configure Oracle credentials, wallet material, the demo-password hash, session secret, and cron secret as server-side Vercel environment variables. Environment-variable changes require a new deployment. SQL scripts are **not** executed by the Vercel build; database migrations must be applied separately.

See [deploy/VERCEL.md](deploy/VERCEL.md) for the complete deployment procedure. Keep secrets out of Git and all `VITE_` variables.

## Behaviour and limitations

- Allergy checking uses exact medicine-class matches, ignoring case and surrounding whitespace. It does not infer ingredients, synonyms, or cross-reactivity. Other allergies are retained for review outside the current automatic match. Missing allergy/class data is not proof of safety.
- New API-generated invoices are limited to one per appointment. Pending invoices must be explicitly recalculated after charges change; payment is rejected while their totals differ.
- Paid or refunded appointments reject new prescription and lab charges through the API. Results for existing lab orders can still be recorded.
- Invoice breakdowns use current catalog prices. Historical price snapshots, partial payments, insurance claims, and payment processing are not implemented.
- Attachment and report fields store references; file upload and storage are not implemented.
- Production access uses a shared demo login, not individual accounts or role-based permissions. Use synthetic data only.

## Documentation

- [Workflow guide](docs/DA2_COMPLETION.md): query explanations, business rules, and demonstration steps
- [D.A. 2 checklist](docs/DA2_CHECKLIST.md): implementation and report evidence
- [Report draft](docs/DA2_REPORT_DRAFT.md): source material for the handwritten report
- [Deployment record](docs/DEPLOYMENT_STUDY_RECORD.md): dated setup decisions and verification history
