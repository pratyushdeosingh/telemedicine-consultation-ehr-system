# Test cases and results

**Recorded:** 1 November 2026, Asia/Kolkata. Browser checks used the local React/Express application with its configured Oracle and Cassandra services. Backend unit/HTTP tests use controlled dependencies; they do not independently prove live database connectivity. All application data is synthetic.

## Run the checks

| Working directory | Command | Scope and data effects |
| --- | --- | --- |
| `backend/` | `npm test` | Syntax checks plus 13 unit/HTTP tests. Does not require production databases; uses local sockets. |
| `backend/` | `npm run db:verify-workflows` | Live Oracle checks for validation, triggers, rollback, laboratory and billing. Synthetic verification records are rolled back; Oracle sequences can advance. |
| Repository root | `node tests/evidence/collect-database-evidence.cjs` | Read-only Oracle/Cassandra checks and local API paging/validation. Saves dated JSON/results under `tests/results/`. Requires running API and the PAT-01/2026-09 screenshot fixture. |
| `frontend/` | `corepack pnpm lint` | Frontend source lint. |
| `frontend/` | `corepack pnpm build` | Production frontend compilation. |
| `backend/` | `npm run timeline:verify` | Imports source events, compares summaries/dates, repeats import and checks real paging. Oracle is read-only; Cassandra upserts are retained. |
| `backend/` | `npm run timeline:verify-refresh` | Commits a uniquely marked temporary Oracle fixture to test website refresh, then removes it from both databases. Run without concurrent imports. |
| Repository root | `./cassandra/verify.ps1` | Local Docker CQL seed/CRUD/partition checks. Reapplies demo seeds and cleans its verification row. `-Restart` adds a persistence check. |

The read-only collector accepts an optional output directory and `EVIDENCE_API_URL`; its default is `http://127.0.0.1:3000/api`. It is intended for the locally configured API, not production authentication. To test an outage, `npm run timeline:verify -- --outage` is restricted to a **local Docker Cassandra** configuration, stops/restarts that service and must not be used with Astra.

## Recorded checks

All cases below passed in the captured session. “Visible guard” refers to an observed disabled UI action, not a new server-side write test.

| ID | Action/input | Expected outcome | Actual outcome | Evidence |
| --- | --- | --- | --- | --- |
| UI-01 | Open overview | Load connected dashboard | 38 patients, 38 prescriptions, 10 scheduled appointments; Oracle and Cassandra connected | Screenshot 1 |
| UI-02 | Search PAT-01 | One matching record | Raman Nathan, PAT-01 | Screenshot 3 |
| UI-03 | Search ZZZ-NO-SUCH-PATIENT | Clear empty state | Zero records; “No records found” | Screenshot 4 |
| UI-04 | Select history for PAT-01 | Patient-only entries and allergies | Two dated entries; Penicillin class and Peanuts allergy shown separately | Screenshot 5 |
| UI-05 | PAT-01 / September 2026 timeline | Return selected partition | Five events, descending dates | Screenshot 6 |
| UI-06 | Open laboratory | Display orders and results | Reported values, dates and remarks displayed | Screenshot 7 |
| UI-07 | Open appointments | Display consultation records | 39 appointments: 26 virtual, 13 in-person | Screenshot 8 |
| UI-08 | Open prescriptions | Display grouped medicine items | 38 prescriptions, 39 items, ₹6,430.50 medicine value | Screenshot 9 |
| UI-09 | Filter Pending invoices | Show pending records and reconciliation guard | 11 pending invoices; INV-02 variance ₹154; “Mark paid” disabled (visible guard) | Screenshot 11 |
| UI-10 | Expand INV-02 charges | Components equal current total | ₹30 + ₹154 + ₹4,500 = ₹4,684 | Screenshot 12 |
| TR-01 | Read USER_TRIGGERS / USER_OBJECTS | Both project triggers enabled/valid | Both ENABLED / VALID | Screenshots 15–16; database JSON |
| TR-02 | Integration request: Amoxicillin for Penicillin-allergic patient | Oracle rejection; HTTP 409 | ORA-20002 raised; API returned 409 | Screenshot 15; clinical output |
| TR-03 | Safe medicine followed by conflicting item in same prescription | No partial prescription | Header and earlier item counts both zero after rollback | Screenshot 15; clinical output |
| TR-04 | Browser request: Ibuprofen for NSAID-allergic patient | Warning then rejected prescription | Application error shown; RPT-ALG-1101 prescription count zero | Screenshots 13–15 |
| TR-05 | Virtual booking inside integration transaction | Trigger creates session | Session found, NULL start time, automatic note; records rolled back | Screenshot 16; clinical output |
| TR-06 | Expand existing APT-24 session | Display related session metadata | SES-24, “Session created automatically” | Screenshot 19 |
| CQ-01 | Inspect Cassandra key metadata and read PAT-01/2026-09 | Correct key model and ordered events | Composite patient/month partition; timestamp DESC, event ID ASC; five events | Screenshot 17; database JSON |
| CQ-02 | Read with limit=2 and returned cursors | Complete, distinct results | Three pages of 2, 2 and 1; five distinct identities | Screenshot 18; database JSON |
| CQ-03 | Request month 2026-13 | Invalid input rejected | HTTP 400, “Choose a valid month (YYYY-MM)” | Screenshot 18 |
| CQ-04 | Read EMPTY-DEMO/2026-09 | Empty partition handled | HTTP 200 with zero events | Screenshot 18 |
| IN-01 | Invalid date 2026-02-30 and invalid allergy classes | HTTP 400 | Rejected; valid history/allergies saved only inside verifier transaction | Clinical output |
| IN-02 | Duplicate invoice and changed charges | HTTP 409; reconciliation required | Duplicate/mismatched payment rejected; recalculation and status transitions verified | Clinical output |
| IN-03 | Add charges to paid/refunded appointment | HTTP 409 | New prescription/lab charges rejected | Clinical output |

Screenshots are indexed with captions in [screenshots/README.md](../screenshots/README.md). Figures 15–18 are labelled captures of formatted actual verification transcripts, not SQL-terminal screenshots. Screenshot 20 is a separate **11 October 2026** hosted refresh result; its 55-record count is historical.

## Recorded output

- [Backend tests](results/2026-11-01/backend-tests.txt): **13 passed, 0 failed, 0 skipped**. Covers authentication/origin checks, deployment routing, date mapping, composite identities, cursors, partial imports, limits, deadlines, overlap and failure isolation.
- [Clinical integration](results/2026-11-01/clinical-workflows.txt): live Oracle verification results and expected allergy error; local stack paths were omitted for readability.
- [Database checks](results/2026-11-01/database-checks.txt): successful read-only checks and actual Oracle service version.
- [Database evidence JSON](results/2026-11-01/database-evidence.json): trigger states, rejected-prescription count, automatic-session records, Cassandra schema/results, paging and invalid/empty responses.
- [Cleanup validation](results/2026-11-01/repository-validation.txt): backend suite, frontend lint/build and repository checks.

Counts and states describe the captured snapshot. The read-only collector deliberately checks the same five-event fixture; it may fail after legitimate changes to that partition. No Cassandra outage, refresh-idempotency or load test was rerun in the 1 November capture/cleanup session. These results do not establish multi-node replication, failover, scalability or clinical safety beyond the implemented class-matching rule.
