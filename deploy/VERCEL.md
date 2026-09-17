# Vercel Hobby deployment for the academic demo

The Vercel project serves the Vite frontend from its CDN and sends `/api/*` to an Express function. The API uses an Oracle Autonomous Database wallet for mutual TLS because Vercel Hobby does not provide a fixed outbound IP for database allowlisting. A shared demo password protects the API and only synthetic records may be stored. This is a student demonstration, not a clinical EHR or an uptime-guaranteed service.

Vercel Hobby is free for noncommercial personal projects within its usage limits. Oracle Always Free is free within its limits, but automatically stops a database after seven days without activity. The daily Vercel cron in `vercel.json` runs a tiny Oracle query to reduce that risk; cron invocations are not guaranteed or retried. Check the Oracle database state before a demonstration.

## 1. Oracle database

Create an Oracle Cloud Free Tier account and an **Always Free Autonomous AI Database**. Choose the mutual TLS access option (**Secure access from everywhere**) so a Vercel Function with changing outbound IPs can connect using the wallet. Download the wallet ZIP in Oracle's **Database connection** panel and remember its wallet password. Keep the ZIP private.

In Oracle Database Actions as `ADMIN`, create a dedicated schema user (replace the password with a unique one):

```sql
CREATE USER TELEMEDICINE_APP IDENTIFIED BY "choose-a-unique-long-password";
GRANT CREATE SESSION, CREATE TABLE, CREATE SEQUENCE, CREATE PROCEDURE, CREATE TRIGGER TO TELEMEDICINE_APP;
ALTER USER TELEMEDICINE_APP QUOTA UNLIMITED ON DATA;
```

`DATA` is the usual ADB default tablespace; use the actual tablespace if yours differs. Do not use `ADMIN` as the website's database user.

Unzip the wallet locally. Copy the full `low` service descriptor from `tnsnames.ora` for `ORACLE_CONNECT_STRING`; do not use only its alias. Encode `ewallet.pem` in base64 for `ORACLE_WALLET_B64`. In PowerShell:

```powershell
[Convert]::ToBase64String([IO.File]::ReadAllBytes('C:\path\to\wallet\ewallet.pem'))
```

Do not send the resulting value or any password in chat. On your own computer, put the schema username, password, descriptor, wallet base64, and wallet password in `backend/.env` (which Git ignores). From `backend/`, run `npm run db:setup` **once in the fresh empty schema**. This script drops existing project tables. Check `npm run db:queries` afterward. Do not rerun setup after keeping records you need.

On Windows, `deploy/setup-oracle-local.ps1` can create the ignored `backend/.env` from an instance wallet ZIP and two hidden password prompts. It defaults to `Downloads/Wallet_TELEMEHR.zip`; pass `-WalletZip` if your file has another name. It backs up an existing `backend/.env` before replacing it. Run it locally from the repository root, then run `npm run db:setup` from `backend/` on the fresh schema.

## 2. Demo password

From `backend/`, run `npm run auth:generate`. Save the printed demo password in your password manager. It also prints `DEMO_PASSWORD_SCRYPT`, `SESSION_SECRET`, and `CRON_SECRET`; put these only in Vercel's server-side environment settings. Never put them in `VITE_` variables or Git.

The application login uses a secure HttpOnly cookie valid for eight hours. The static shell is public, but Oracle API data and writes require this login. Give the demo password only to the people who need the demonstration.

## 3. Vercel project

Use the existing GitHub repository (or another repository under your personal account). Confirm that no `.env`, wallet, or secret is tracked. In Vercel, choose the **Hobby** plan, import the repository, and keep the Vercel **Root Directory** at the repository root (`telemedicine-ehr-da2`, where `vercel.json` lives). Choose the branch containing these deployment files as Vercel's production branch; the current working branch is `frontend` until it is merged into `main`. The committed `vercel.json` specifies the Vite build and API routing. Select Node.js 24 in project settings if it is not selected automatically.

Before the production deployment, enter these Vercel project environment variables for **Production**:

| Variable | Value |
| --- | --- |
| `NODE_ENV` | `production` |
| `DEPLOY_TARGET` | `vercel` |
| `PUBLIC_ORIGIN` | `https://<your-project>.vercel.app` using the actual production domain |
| `ORACLE_USER` | `TELEMEDICINE_APP` |
| `ORACLE_PASSWORD` | Dedicated schema password |
| `ORACLE_CONNECT_STRING` | Full wallet `low` TCPS descriptor |
| `ORACLE_WALLET_B64` | Base64 `ewallet.pem` |
| `ORACLE_WALLET_PASSWORD` | Wallet download password |
| `DEMO_PASSWORD_SCRYPT` | Generated `salt:hash` |
| `SESSION_SECRET` | Generated signing secret |
| `CRON_SECRET` | Generated cron secret |

Keep `VITE_USE_DEMO_DATA=false`; the build command sets this explicitly. Do not set `SERVE_FRONTEND=true` on Vercel. Vercel serves static files itself. Redeploy after changing environment variables. Limit sensitive variables to Production unless you intentionally want a protected preview connected to Oracle.

## 4. Verify before sharing

1. Open the production URL. It must show the demo password screen and no Oracle data.
2. An unauthenticated request to `/api/patients` must return `401`.
3. Sign in, then verify the app says **Oracle connected** and lists only synthetic seeded records.
4. Refresh `/patients` directly; it must still open the page.
5. Create one synthetic patient and verify it in Oracle.
6. In Vercel **Cron Jobs**, confirm the daily `/api/cron/keepalive` run succeeds. If it fails, investigate the logs and check the ADB status in Oracle Cloud.
7. Check Vercel **Usage** and Oracle **Always Free** status periodically, especially before a class demonstration. Keep an export of the schema and data; free tiers are not a backup plan.

If this requires guaranteed availability or real patient records, move to a paid, supported hosting and authentication design.
