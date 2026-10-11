# Backend

Express API for the Care Continuum application. Oracle access uses bound SQL values and explicit commit/rollback handling through `node-oracledb`.

See the [project README](../README.md#run-locally) for installation, environment configuration, and startup. Configure `.env` before running `npm start`. Database initialization is separate and destructive; never run `db:setup` against records you need to retain.

## API reference

All routes below use the `/api` prefix. Production data routes require a signed session cookie. JSON write requests must originate from the configured application origin.

| Method | Path | Operation |
| --- | --- | --- |
| GET | `/session` | Check login state |
| POST | `/login` | Sign in with the demo password |
| POST | `/logout` | Clear the session cookie |
| GET | `/test-db` | Check Oracle connectivity |
| GET | `/patients` | List patients |
| GET | `/doctors` | List doctors and departments |
| GET | `/medicines` | List medicines, prices, and allergen classes |
| GET | `/pharmacies` | List pharmacies |
| GET | `/medical-logs` | List patient medical history |
| GET | `/allergies` | List allergies by patient and log entry |
| GET | `/appointments` | List joined appointment details |
| GET | `/prescriptions` | List prescription medicine items |
| GET | `/lab-catalog` | List available lab tests and costs |
| GET | `/lab-orders` | List lab orders |
| GET | `/test-results` | List reported results |
| GET | `/telemedicine-sessions` | List virtual-session metadata |
| GET | `/timeline/health` | Check timeline configuration and Cassandra access |
| GET | `/timeline/:patient_id?month=YYYY-MM` | Read a Cassandra partition; optional `limit` and signed `cursor` |
| GET | `/billing` | List stored and calculated invoice totals |
| GET | `/billing/:appointment_id/items` | List current medicine and lab charges |
| POST | `/patients` | Register a patient through PL/SQL |
| POST | `/appointments` | Book an appointment |
| POST | `/prescriptions` | Create a prescription and its items together |
| POST | `/medical-logs` | Record history and allergies together |
| POST | `/lab-orders` | Order a catalog test |
| POST | `/test-results` | Record a result for an order |
| POST | `/billing` | Generate a calculated pending invoice |
| PUT | `/appointments/:appointment_id/status` | Update status through PL/SQL |
| PUT | `/billing/:appointment_id/:invoice_no` | Recalculate, pay, or refund an invoice |

`GET /` is a local API liveness check. `/api/cron/keepalive` is a Vercel-only endpoint protected by a separate bearer secret; it is not a browser operation.

## History and billing requests

History creation accepts `patient_id`, `log_date`, `diagnosis`, optional `attachment_path`, and arrays `known_allergies` and `other_allergies`. Known classes are validated against the medicine catalog. The original `allergies` array remains supported for existing API clients.

Invoice creation accepts `appointment_id` and `billing_date`. The server calculates the amount; a client-supplied amount is not used. Invoice updates accept an `action` of `recalculate`, `pay`, or `refund`.

See the [workflow guide](../docs/DA2_COMPLETION.md) for transaction behaviour and business rules.

## Response status

| Status | Meaning |
| --- | --- |
| 400 | Invalid or incomplete input |
| 401 | Login or cron authorization required |
| 403 | Write request from an untrusted production origin |
| 404 | Record not found in the applicable workflow |
| 409 | Allergy conflict, duplicate invoice, or prohibited billing transition |
| 500 | Unexpected database/service failure |
| 503 | Missing database configuration on the health route, or unavailable cron database |

## Verification

```powershell
npm test
npm run db:verify-workflows
```

The workflow check requires Oracle and uses a temporary server with rolled-back synthetic changes. Schema/evidence commands are documented in [database/README.md](../database/README.md).

## Cassandra commands

`npm run timeline:setup` creates the table in an existing keyspace. `npm run timeline:import` reads Oracle and upserts timeline records. `npm run timeline:verify` checks both databases and paging; add `-- --outage` only for local Docker failure/recovery verification. See [cloud setup](../deploy/CASSANDRA.md) and the [comparison](../docs/DA3_COMPARISON.md).
