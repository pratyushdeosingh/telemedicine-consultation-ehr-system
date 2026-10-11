# D.A. 3 website enhancement plan

Status: implemented and verified locally on 11 October 2026. Thirteen backend tests, real Oracle/Astra refresh with a disposable fixture, repeated refresh, independent disabled/recovery states, desktop/mobile layouts, frontend lint/build, and Oracle regressions passed. Production rollout and final browser checks follow before this change is marked deployed.

## Intended experience

Add a dedicated **Cassandra Timeline** navigation item on desktop and mobile. Its page presents patient/month selection, imported clinical events, and a **Refresh from Oracle** button. Identify the hosted service as **Astra DB, powered by Cassandra**. Medical history retains Oracle history/allergy entry functions and gains a patient-specific link to the timeline page instead of embedding the full timeline.

Show independent Oracle and Cassandra connection indicators. Cassandra status comes from the existing authenticated `/api/timeline/health` endpoint, which executes a prepared table read. Distinguish checking, connected, unavailable, not configured, and preview mode. Clicking a status retries its check. Availability is separate from whether an import has been run after an Oracle change; avoid continuous frequent polling.

## Refresh behavior

1. A signed-in user clicks **Refresh from Oracle**. Explain that this imports records for all patients, not only the selected patient/month.
2. Disable repeat clicks while the request runs and display a loading state. Do not display a fabricated percentage.
3. A protected `POST /api/timeline/import` reuses the existing Oracle read-only snapshot, source mapping, and prepared Cassandra upserts. Authentication and production origin checks apply before the route.
4. Return attempted, written, failed, and partition counts. Display the result and completion time for this request. Do not imply a durable global last-import timestamp when only the current page knows the time.
5. On full success, reload the selected timeline, patient options, and database status. Keep patient/month selection where possible.
6. On a connection failure or partial import, display an honest outcome and retry action. Successfully written rows may remain; retry uses stable record keys and does not add duplicate events. Oracle records are never changed by this endpoint.

The importer is an add/update operation, not a complete mirror: deleting a source row or moving its source date does not remove the old Cassandra row. The current website creates dated records and updates summaries/statuses; destructive reconciliation is outside this change. Document this limitation clearly.

## Backend and deployment decisions

- Extract reusable import orchestration so HTTP and terminal imports share the same code. HTTP closes its Oracle connection but retains the shared Cassandra client; the terminal command can still shut its own client down when finished.
- Guard overlapping imports within each backend instance and disable repeat submissions in the browser. Stable keys make retrying safe; an in-memory guard does not claim to coordinate separate Vercel instances or different clients globally.
- Keep schema creation out of the web refresh route. The button works with the existing table and approved database-scoped token.
- Keep credentials server-side. Return useful summaries without raw database errors, credentials, or connection bundles.
- Bound import size/time and verify against the project's actual Vercel function duration. Finish work within the request; do not launch a background promise that may be terminated after the response. A timeout must not be presented as a completed or rolled-back Cassandra import.
- Preserve the CLI command for maintenance and classroom demonstrations. The normal website workflow no longer requires it.
- Use the existing simple Oracle SELECT/JOIN queries and Cassandra INSERT/SELECT statements; no message broker, scheduler, or complex synchronization system is introduced.

## Implementation order

1. Shared import service, authenticated endpoint, limits, and result/error contract.
2. Client methods and independent database status indicators.
3. Dedicated route/navigation, patient/month selection, refresh states, and medical-history link.
4. Local/backend/browser checks with both configured Astra and controlled failure cases.
5. Update README, API/query guides, and demonstration instructions.
6. Push the verified changes to main, verify Vercel completes deployment, and perform production smoke checks.

## Required verification

- Logged-out import requests return 401; production requests from a foreign origin are rejected.
- One refresh imports the source snapshot; a repeated refresh produces no duplicate events.
- A controlled synthetic Oracle change appears in Cassandra only after refresh. Use a disposable transaction/fixture and clean up all verification rows; do not alter existing demonstration records to test this.
- Partial Cassandra writes report their counts and can be retried. Oracle-read failure, unavailable Cassandra, disabled configuration, request limits, and overlapping submissions behave honestly.
- Connection indicators remain independent; Cassandra failure does not break Oracle pages.
- Patient/month changes, empty months, paging, loading/error/retry states, direct-route refresh, and medical-history links work.
- Desktop and mobile layouts remain usable with the added navigation item and two connection indicators.
- Run backend tests, frontend lint/build, and the real Oracle workflow regression with test writes rolled back.
- In production, verify an authenticated refresh, its result, timeline reads, repeated refresh, and original Oracle laboratory/billing/history behavior.

## User involvement

No database account, Docker installation, or new token should be needed: the existing Astra role already permits these table reads/writes. A website or Vercel sign-in may be needed if the session expires. The user retains the handwritten report and demonstration rehearsal.
