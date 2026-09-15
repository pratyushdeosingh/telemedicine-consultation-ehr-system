# Telemedicine Consultation and EHR System

A full-stack academic project that demonstrates how a telemedicine dashboard can read Electronic Health Record (EHR) data from an Oracle database through an Express REST API.

This README is both the setup guide and the revision handbook for the project.

## 1. What the project does

The current frontend provides six views and live write controls:

| View | Purpose | API data used |
| --- | --- | --- |
| Overview | Summarises the care journey, upcoming appointments and pending invoices | All endpoints |
| Patients | Searches and displays patient and insurance information | `GET /api/patients` |
| Appointments | Shows appointment time, patient, doctor, department, mode and status | `GET /api/appointments` |
| Prescriptions | Groups prescribed medicines and calculates medicine totals | `GET /api/prescriptions` |
| Billing | Compares stored invoice amounts with calculated medical costs | `GET /api/billing` |
| System Flow | Visually explains the React-to-Oracle architecture | Static explanation |

The Patients page can register patients, the Appointments page can book consultations and update their status, and the Prescriptions page can create a prescription with its first medicine item. These controls call the Express POST/PUT routes and refresh their Oracle-backed lists after success.

The interface is responsive and includes loading, empty, error and retry states. It uses restrained motion and also respects the operating system's reduced-motion preference.

## 2. How it works

```text
User
  ↓
React dashboard
  ↓  fetch('/api/...')
Vite development proxy
  ↓
Express REST API
  ↓  SQL through node-oracledb
Oracle Database
  ↓
Rows → JSON response → React state → dashboard cards and tables
```

1. A page calls a function from `frontend/src/api/client.js`.
2. The browser requests an endpoint such as `/api/appointments`.
3. During local development, Vite forwards `/api` requests to `http://localhost:3000`.
4. Express runs the relevant Oracle query and returns JSON.
5. `useApiResource` stores the loading, success or error state.
6. React transforms the response where required and renders the result.

The Vite proxy is only a development convenience. In deployment, the frontend must be configured with the deployed API URL or both applications must be served behind the same domain.

## 3. Preview data versus live Oracle data

The frontend supports two modes so interface work does not stop while the backend is unavailable.

Create `frontend/.env.local` from `frontend/.env.example` and choose one mode:

```env
# Live Express/Oracle API
VITE_API_URL=/api
VITE_USE_DEMO_DATA=false
```

```env
# Local frontend preview without Express or Oracle
VITE_API_URL=/api
VITE_USE_DEMO_DATA=true
```

The connection badge means:

| Badge | Meaning |
| --- | --- |
| Preview data | Records come from `demoData.js`; Oracle was not contacted |
| Checking API | The frontend is calling `/api/test-db` |
| Oracle connected | The API database health check succeeded |
| API offline | The backend or database could not be reached |

Demo records are for UI development only and must not be presented as live database proof.

## 4. “Demo workspace / Academic prototype”

This text in the sidebar is a project-status label. It tells the evaluator that the interface is a student demonstration environment.

It does **not** mean that authentication, authorisation, encryption, audit logging, consent handling, secure deployment or healthcare-regulation compliance has been implemented. The earlier wording, “Protected workspace / Academic demonstration,” was renamed because “protected” could incorrectly imply real security controls.

Only synthetic demonstration data should be used until proper security and privacy controls are added.

## 5. Integrated API contract

| Method and endpoint | Expected information |
| --- | --- |
| `GET /api/test-db` | Oracle connection/health status |
| `GET /api/patients` | Patient identity, contact, demographics and insurance details |
| `GET /api/appointments` | Appointment, patient, doctor, department, date/time, status and consultation mode |
| `GET /api/prescriptions` | Prescription medicines, dosage, frequency, duration, quantity and calculated cost |
| `GET /api/billing` | Invoice/payment information and calculated medical cost |
| `GET /api/test-results` | Laboratory results and report metadata |
| `POST /api/patients` | Register a new patient |
| `POST /api/appointments` | Book a new appointment |
| `POST /api/prescriptions` | Create a prescription with medicine items |
| `PUT /api/appointments/:appointment_id/status` | Change an appointment status |

The five dashboard GET responses have been compared with the fields consumed by the React pages and match. The frontend API client also exposes the write operations and lab-result endpoint for the next UI workflow phase. A final live check still requires local Oracle credentials.

## 6. Important frontend calculations

### Prescription grouping

An API may return one row per prescribed medicine. The prescriptions page groups repeated rows with a `Map`, using the appointment/prescription identity as a key, and displays all medicines under one prescription. Medicine cost is calculated from quantity and unit price when available.

### Billing reconciliation

The billing page shows both the stored invoice amount and the amount calculated from medicine/lab data. Any future variance is highlighted rather than hidden. The committed sample invoices are reconciled with the PL/SQL calculation.

### Dashboard aggregation

The overview loads patients, appointments, prescriptions and billing together with `Promise.all`, then derives summary counts and the care-continuum display.

## 7. Repository and team workflow

| Branch | Member role | Main responsibility |
| --- | --- | --- |
| `database` | Member 1 | Oracle schema, sample data, queries and PL/SQL |
| `backend` | Member 2 | Express server, Oracle connection and REST endpoints |
| `frontend` | Member 3 | React dashboard, data states and API integration |
| `main` | Integrated submission | Reviewed, working combination of all three roles |

Each member works only on their feature branch. Changes should reach `main` through reviewed pull requests after integration testing. Avoid direct, unrelated edits to another member's branch.

Suggested merge order:

1. Merge and validate `database`.
2. Merge `backend` and test every endpoint against Oracle.
3. Update the frontend contract if necessary and test with preview mode disabled.
4. Merge `frontend`.
5. Run the complete demo from a clean checkout.

Useful frontend workflow:

```bash
git switch frontend
git pull origin frontend
git status

# after completing one understandable step
git add <changed-files>
git commit -m "type: describe the completed step"
git push origin frontend
```

Keep commits small and explainable. Do not commit `.env.local`, credentials, Oracle connection strings, `node_modules` or generated `dist` files.

## 8. Project structure

```text
telemedicine-ehr-da2/
├── database/      Oracle scripts and database notes
├── backend/       Express API (owned by the backend branch)
├── frontend/      React and Vite dashboard
├── docs/          Shared project documentation
└── README.md      Setup, architecture and revision handbook
```

Key frontend files:

| File | Responsibility |
| --- | --- |
| `src/App.jsx` | Defines routes |
| `src/components/AppShell.jsx` | Sidebar, top bar and shared layout |
| `src/api/client.js` | Endpoint definitions, fetch helper and mode selection |
| `src/api/demoData.js` | Synthetic preview records |
| `src/hooks/useApiResource.js` | Loading, success, error and retry lifecycle |
| `src/pages/` | Dashboard screens |
| `src/index.css` | Design system, responsive layout and motion |
| `vite.config.js` | React plugin and local `/api` proxy |

## 9. Running the frontend

Prerequisites:

- Node.js 20 or newer
- pnpm through Corepack
- Express backend on port `3000` for live mode
- A working Oracle instance configured by the database/backend members

Commands:

```bash
cd frontend
pnpm install
pnpm dev
```

Open the URL printed by Vite, normally `http://localhost:5173`.

Quality checks:

```bash
pnpm lint
pnpm run build
pnpm preview
```

## 10. Full live-demo run order

1. Run the database schema and sample-data script in Oracle.
2. Run the required PL/SQL objects and confirm they compile.
3. Configure the backend environment without committing secrets.
4. Start Express and open `GET /api/test-db`.
5. Open every GET endpoint and inspect its JSON response.
6. Set `VITE_USE_DEMO_DATA=false` in `frontend/.env.local`.
7. Start the frontend and confirm the badge says “Oracle connected.”
8. Check every page and compare at least one displayed record with Oracle.
9. Demonstrate any known billing variance honestly and explain its cause/resolution.

Local backend configuration:

```bash
cd backend
npm ci
copy .env.example .env
# Edit .env with local Oracle credentials. The next command resets demo tables:
npm run db:setup
npm start
```

## 11. Integration status and remaining live checks

The Express backend and React frontend are now integrated at the source and API-contract level. The backend starts without secrets, reports incomplete database configuration clearly, validates write requests, and uses explicit commit/rollback handling.

- Configure a local `.env` and test every endpoint against the actual Oracle instance.
- Add pages for medical logs, allergies, doctors, laboratories/results and telemedicine session links if those items are required by the DA rubric/schema.
- Capture database output, endpoint JSON and dashboard screenshots as submission evidence.
- Perform one clean end-to-end rehearsal with Oracle running.

Authentication and production security are out of the current implementation. If the application is extended beyond an academic demo, they become mandatory rather than optional polish.

## 12. Troubleshooting

### The badge says “API offline”

Confirm Express is running on port `3000`, `/api/test-db` works directly, Oracle credentials are configured, and `VITE_USE_DEMO_DATA` is `false`. Restart Vite after changing an environment variable.

### The page shows preview records

`VITE_USE_DEMO_DATA=true` is enabled. This is expected for standalone UI work but must be disabled for the integration demonstration.

### Data loads but fields are blank

The backend JSON field names or nesting do not match the frontend contract. Save one endpoint response and compare it with the normalisation code in `src/api/client.js` and the relevant page.

### Invoice values differ

Do not patch the number only in the UI. Check the database rows, PL/SQL calculation, SQL joins, duplicate rows, unit prices, quantities, lab totals and the stored invoice amount. Agree on one authoritative calculation.

### A teammate's invite or old repository link gives 404

For a private repository, the user must be signed into the invited GitHub account and must accept the current invitation. Repository renames normally redirect regular repository links, but expired invitation links should be replaced with a fresh invite.

## 13. Short viva explanation

> This is a three-layer telemedicine EHR system. Oracle stores the relational healthcare data, Express exposes selected joined data through REST endpoints, and React fetches the JSON and renders a responsive dashboard. The frontend can use synthetic preview data during development, but live mode calls the actual API. Prescriptions are grouped from medicine-level rows, and billing deliberately exposes any difference between stored and calculated totals so data inconsistencies are visible instead of concealed.

For the demonstration, start with the System Flow page, prove `/api/test-db`, open one real endpoint response, then trace the same record through the related dashboard page.
