# Express + Oracle backend

## Local setup

```bash
npm ci
copy .env.example .env
npm start
```

Edit `.env` with the Oracle account and connect string for your machine. The API runs on `http://localhost:3000` by default. Real credentials and `.env` must never be committed.

Use these checks before integration:

```bash
npm test
curl http://localhost:3000/
curl http://localhost:3000/api/test-db
```

`GET /` proves Express is running. `GET /api/test-db` additionally proves that the configured Oracle database can be reached.

## API routes

| Method | Route | Purpose |
| --- | --- | --- |
| GET | `/api/test-db` | Check the Oracle connection |
| GET | `/api/patients` | List patients |
| GET | `/api/doctors` | List doctors and departments |
| GET | `/api/medicines` | List medicine reference data |
| GET | `/api/pharmacies` | List pharmacies |
| GET | `/api/medical-logs` | List patient medical logs |
| GET | `/api/lab-orders` | List laboratory orders |
| GET | `/api/test-results` | List laboratory test results |
| GET | `/api/telemedicine-sessions` | List virtual consultation sessions |
| GET | `/api/appointments` | List joined appointment details |
| GET | `/api/prescriptions` | List prescription medicine rows |
| GET | `/api/billing` | List stored and PL/SQL-calculated invoice totals |
| POST | `/api/patients` | Register a patient through `Register_New_Patient` |
| POST | `/api/appointments` | Book an appointment |
| POST | `/api/prescriptions` | Create a prescription and its items |
| PUT | `/api/appointments/:appointment_id/status` | Update status through `Update_Appointment_Status` |

POST and PUT requests use JSON. Validation errors return HTTP 400, missing database configuration returns HTTP 503 from the health route, and database failures return HTTP 500.
