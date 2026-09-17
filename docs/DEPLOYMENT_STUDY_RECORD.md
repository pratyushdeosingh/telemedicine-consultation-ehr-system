# Deployment record and oral-exam notes

Updated: 17 September 2026. This records the **academic demonstration** setup. It contains no passwords, wallet material, or patient information. Add dated evidence here as the Vercel deployment continues.

## What has been completed

Before choosing this path, we considered Azure App Service and an Azure VM. App Service's free tier has usage and reliability limits, while a VM would require us to administer the operating system, firewall, reverse proxy, TLS, patches, and uptime ourselves. **Caddy** was a possible reverse proxy for that VM approach; it is not part of the chosen Vercel deployment. We selected Vercel Hobby plus Oracle Always Free for this small, noncommercial class demo, accepting both services' free-tier limits.

| Step | Decision and reason | Evidence/status |
| --- | --- | --- |
| Hosting choice | Use Vercel Hobby for the React frontend and Node API; use Oracle Autonomous AI Database Always Free for Oracle SQL and PL/SQL. This keeps the existing Oracle design while staying within free-tier limits for a small noncommercial demo. | Repository has `vercel.json`; no Vercel deployment yet. |
| Oracle region | Created the database in India South (Hyderabad), the region in the console. Always Free must be created in the tenancy home region. | Database details showed **Always Free** and **Available**. |
| Workload/version | Chose **Transaction Processing** and Oracle AI Database **26ai**. The app performs relational reads and writes, transactions, and PL/SQL; it does not need the Lakehouse workload. | Database details showed Transaction Processing. |
| Network | Chose **Secure access from everywhere** with wallet-based mutual TLS (mTLS). Vercel Hobby functions do not provide a fixed outbound IP for a simple allowlist. Database username/password and wallet are still required. | Oracle connection panel provided an instance wallet. |
| Database account | Created `TELEMEDICINE_APP` separately from Oracle's `ADMIN` account with a 1 GB quota on `DATA`. The website uses this account, never `ADMIN`. | Account visible in Database Actions. |
| Temporary setup privileges | Granted `CREATE SESSION`, `CREATE TABLE`, `CREATE SEQUENCE`, `CREATE PROCEDURE`, and `CREATE TRIGGER` to build the schema. | Oracle SQL output: **Grant succeeded**. |
| Schema initialization | Ran `npm run db:setup` once against the fresh `TELEMEDICINE_APP` schema. It executed 182 statements and seeded linked synthetic records. | Script reported 8 patients, 8 appointments, 8 prescriptions, and 8 invoices. Later read-only check found 18 tables, 3 sequences, 2 procedures, 1 function, and 1 trigger. |
| Least-privilege hardening | Revoked the four object-creation privileges, then revoked the default `RESOURCE` role assigned by Database Actions. The latter mattered because a role can grant privileges even after direct grants are removed. | Oracle SQL output: **Revoke succeeded** for both statements. Read-only query as the app account showed only `CONNECT` role and direct `CREATE SESSION`; a read of `PATIENT` still worked. |
| Git | Fast-forwarded `main` from `frontend` and pushed both branches. Earlier `backend` and `database` branch commits are ancestors of this combined branch. | `main`, `frontend`, `origin/main`, and `origin/frontend` all resolved to `bcacee3` at this checkpoint. |
| Local checks | Checked backend syntax and auth tests, frontend lint and production build, Git secret filenames, and dependency advisories. | 2 backend tests passed; Oxlint and Vite build passed; no wallet or `.env` tracked in Git history; npm and pnpm production audits reported zero known advisories at the time. |

The user downloaded an **instance wallet ZIP** and entered the database-user and wallet passwords privately into `deploy/setup-oracle-local.ps1`. The helper created ignored `backend/.env` and backed up the prior local file. The secrets must stay out of Git, screenshots, reports, and chat.

## Deployment architecture

```text
Browser over HTTPS
  -> Vercel static React/Vite files
  -> same-origin /api request to a Vercel Node.js function
  -> Express route using bound SQL values and Oracle PL/SQL
  -> Oracle Autonomous AI Database over mTLS using the instance wallet
```

The database is the source of truth. On local development, Vite proxies `/api` to Express; on Vercel, `vercel.json` routes `/api` to the Express function. Writes commit on success and roll back on failure. The allergy trigger protects prescription inserts even if a client bypasses the frontend.

## Security decisions to explain

- **Why a separate database account?** `ADMIN` can administer the whole database. The app account owns only its schema and retains just login permission after setup. Its 1 GB quota also limits storage use.
- **Why grant then revoke permissions?** Schema setup needed to create objects. Normal API reads and writes do not need to create tables, sequences, procedures, or triggers. Oracle's `RESOURCE` role also had to be removed because direct grants and role grants are separate.
- **Why a wallet and mTLS?** The wallet provides client credentials for the encrypted Oracle connection. The database password authenticates the schema user. The public endpoint is reachable from changing Vercel IPs, while mTLS and credentials gate access.
- **How is the web API protected?** Production routes require a shared demo password. The server stores a scrypt hash, signs a session cookie with a separate secret, and sets `HttpOnly`, `Secure`, and `SameSite=Strict`. Non-read API requests require the configured HTTPS origin. The keepalive route uses a separate `CRON_SECRET`.
- **How is SQL injection reduced?** The API sends user-supplied values as Oracle bind parameters instead of concatenating them into SQL text.
- **Why synthetic data only?** The login is shared, not individual, and the free tiers provide no uptime guarantee. This is an academic prototype, not a clinical service for real patient records.

## Commands and objects worth remembering

```sql
-- Temporary setup permissions, issued as ADMIN:
GRANT CREATE SESSION, CREATE TABLE, CREATE SEQUENCE, CREATE PROCEDURE, CREATE TRIGGER
TO TELEMEDICINE_APP;

-- After schema setup, also issued as ADMIN:
REVOKE CREATE TABLE, CREATE SEQUENCE, CREATE PROCEDURE, CREATE TRIGGER
FROM TELEMEDICINE_APP;
REVOKE RESOURCE FROM TELEMEDICINE_APP;
```

`backend/scripts/setupDatabase.js` reads `database/telemedicine_ehr.sql`. **Do not rerun** `npm run db:setup` after preserving any new records: it drops and recreates project tables. The database script defines 18 project tables, sample data, indexes, sequences, two procedures, one function, and an allergy-safety trigger. `database/queries.sql` contains labelled evidence queries; `database/trigger_demo.sql` demonstrates the allergy rejection.

## Questions an examiner might ask

**Why Transaction Processing instead of Lakehouse?** The app has short relational CRUD transactions and constraints. Transaction Processing matches that pattern.

**Is an Always Free database the same as a Free Trial database?** No. The OCI account showed a Free Trial banner, but the database itself had the **Always Free** badge. Always Free has separate fixed limits and can continue after trial credits end, subject to Oracle's terms.

**Why can a database with a public endpoint still require mTLS?** Network reachability and authentication are different. The endpoint can be reached from the internet, but a database client needs the wallet plus a valid schema account.

**Why not connect the website as `ADMIN`?** If the app credential leaks or the API is compromised, an `ADMIN` connection would grant far broader control. The dedicated account limits that impact.

**What does `REVOKE RESOURCE` change?** The `RESOURCE` role can confer object-creation rights. Removing direct `CREATE` grants alone did not remove that role. A read-only check afterward showed only `CONNECT` and direct `CREATE SESSION` for the app account.

**How do transactions work?** Each write uses one Oracle connection, commits after all related statements succeed, and rolls back on an error. For example, a prescription header and its items must succeed together.

**What happens if the allergy trigger rejects an item?** Oracle raises an application error. The API rolls back the transaction and returns a conflict response, so a partial prescription is not kept.

**Is the free deployment always available?** No. Oracle may stop an Always Free database after seven inactive days, and Vercel Hobby cron timing is not guaranteed. The keepalive is a mitigation, not an uptime guarantee. Check the database before a presentation.

## Still to do

- [ ] Create a Vercel Hobby project from GitHub `main` with the repository root as the Vercel root directory.
- [ ] Generate and privately store the demo password hash, session secret, and cron secret.
- [ ] Add the Oracle connection and auth values to **Production** environment variables in Vercel; never use `VITE_` for secrets.
- [ ] Deploy and verify unauthenticated `401`, login, Oracle-backed reads, a synthetic write, direct-page refresh, and cron logs.
- [ ] Capture sanitized screenshots of the live system and SQL evidence for the report.
- [ ] Recheck both free-tier usage and database status before the oral exam.

Related files: `deploy/VERCEL.md` is the operational checklist; `database/README.md` explains the schema evidence; `docs/DA2_CHECKLIST.md` tracks course deliverables.

Official references: [Oracle Always Free database](https://docs.oracle.com/en-us/iaas/autonomous-database-serverless/doc/autonomous-always-free.html), [Oracle database user creation](https://docs.oracle.com/en-us/iaas/autonomous-database-serverless/doc/manage-users-create.html), [Vercel Git production branches](https://vercel.com/docs/git), [Vercel environment variables](https://vercel.com/docs/environment-variables), and [Vercel cron limits](https://vercel.com/docs/cron-jobs/usage-and-pricing).
