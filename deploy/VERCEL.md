# Vercel Hobby deployment for the academic demo

The Vercel project serves the Vite frontend from its CDN and sends `/api/*` to an Express function. The API uses an Oracle Autonomous Database wallet for mutual TLS because Vercel Hobby does not provide a fixed outbound IP for database allowlisting. A shared demo password protects the API and only synthetic records may be stored. This is a student demonstration, not a clinical EHR or an uptime-guaranteed service.

Vercel Hobby is free for noncommercial personal projects within its usage limits. Oracle Always Free is free within its limits, but automatically stops a database after seven days without activity. The daily Vercel cron in `vercel.json` runs a tiny Oracle query to reduce that risk; cron invocations are not guaranteed or retried. Check the Oracle database state before a demonstration.

## 1. Oracle database

Create an Oracle Cloud Free Tier account and an **Always Free Autonomous AI Database**. Choose the mutual TLS access option (**Secure access from everywhere**) so a Vercel Function with changing outbound IPs can connect using the wallet. Download the wallet ZIP in Oracle's **Database connection** panel and remember its wallet password. Keep the ZIP private.

In Oracle Database Actions as `ADMIN`, create a dedicated schema user (replace the password with a unique one):

```sql
CREATE USER TELEMEDICINE_APP IDENTIFIED BY "choose-a-unique-long-password";
GRANT CREATE SESSION, CREATE TABLE, CREATE SEQUENCE, CREATE PROCEDURE, CREATE TRIGGER TO TELEMEDICINE_APP;
ALTER USER TELEMEDICINE_APP QUOTA 1G ON DATA;
```

`DATA` is the usual ADB default tablespace; use the actual tablespace if yours differs. Do not use `ADMIN` as the website's database user.

Unzip the wallet locally. Copy the full `low` service descriptor from `tnsnames.ora` for `ORACLE_CONNECT_STRING`; do not use only its alias. Encode `ewallet.pem` in base64 for `ORACLE_WALLET_B64`. In PowerShell:

```powershell
[Convert]::ToBase64String([IO.File]::ReadAllBytes('C:\path\to\wallet\ewallet.pem'))
```

Do not send the resulting value or any password in chat. On your own computer, put the schema username, password, descriptor, wallet base64, and wallet password in `backend/.env` (which Git ignores). From `backend/`, run `npm run db:setup` **once in the fresh empty schema**. This script drops existing project tables. Check `npm run db:queries` afterward. Do not rerun setup after keeping records you need.

After setup succeeds, return to Oracle Database Actions SQL as `ADMIN` and revoke the schema-creation privileges from the website account. If the account was created through Database Actions, also revoke its default `RESOURCE` role, which grants object-creation privileges. Keep `CONNECT` and the direct `CREATE SESSION` privilege. The account can still read and write its own tables and execute its own stored routines. A future schema migration will require temporarily granting the needed creation privileges again.

```sql
REVOKE CREATE TABLE, CREATE SEQUENCE, CREATE PROCEDURE, CREATE TRIGGER
FROM TELEMEDICINE_APP;
REVOKE RESOURCE FROM TELEMEDICINE_APP;
```

On Windows, `deploy/setup-oracle-local.ps1` can create the ignored `backend/.env` from an instance wallet ZIP and two hidden password prompts. It defaults to `Downloads/Wallet_TELEMEHR.zip`; pass `-WalletZip` if your file has another name. It backs up an existing `backend/.env` before replacing it. Run it locally from the repository root, then run `npm run db:setup` from `backend/` on the fresh schema.

## 2. Demo password

The easiest setup is to run `node deploy/prepare-vercel-env.js` from the repository root after `backend/.env` works. It creates an ignored `.env.vercel-import` containing the Oracle connection values, the demo password hash, and fresh session and cron secrets. Save the printed demo password privately. In Vercel, select **Production only**, use **Import .env** to import that file, then delete the local `.env.vercel-import` after confirming the keys were added. Never send the file or a screenshot of its values in chat.

Alternatively, from `backend/`, run `npm run auth:generate` and add the printed values manually. Never put secrets in `VITE_` variables or Git.

The application login uses a secure HttpOnly cookie valid for eight hours. The static shell is public, but Oracle API data and writes require this login. Give the demo password only to the people who need the demonstration.

## 3. Vercel project

Use the existing GitHub repository (or another repository under your personal account). Confirm that no `.env`, wallet, or secret is tracked. In Vercel, choose the **Hobby** plan, import the repository, and keep the Vercel **Root Directory** at the repository root (`telemedicine-ehr-da2`, where `vercel.json` lives). Use `main` as Vercel's production branch once these deployment commits are merged there. The committed `vercel.json` specifies the Vite build and API routing. Select Node.js 24 in project settings if it is not selected automatically.

Before the production deployment, enter these Vercel project environment variables for **Production**:

| Variable | Value |
| --- | --- |
| `DEPLOY_TARGET` | `vercel` |
| `ORACLE_USER` | `TELEMEDICINE_APP` |
| `ORACLE_PASSWORD` | Dedicated schema password |
| `ORACLE_CONNECT_STRING` | Full wallet `low` TCPS descriptor |
| `ORACLE_WALLET_B64` | Base64 `ewallet.pem` |
| `ORACLE_WALLET_PASSWORD` | Wallet download password |
| `DEMO_PASSWORD_SCRYPT` | Generated `salt:hash` |
| `SESSION_SECRET` | Generated signing secret |
| `CRON_SECRET` | Generated cron secret |

Vercel provides `VERCEL_PROJECT_PRODUCTION_URL` for the production domain; the API uses it to check the origin of write requests. Confirm **Automatically expose System Environment Variables** is enabled in the project's environment settings (the default for new projects). If it is disabled, set `PUBLIC_ORIGIN` manually to the exact `https://` production URL and redeploy. The API enforces production authentication whenever it runs on Vercel, so a manual `NODE_ENV` variable is unnecessary.

Keep `VITE_USE_DEMO_DATA=false`; the build command sets this explicitly. Vercel serves static files itself. Redeploy after changing environment variables. Limit sensitive variables to Production unless you intentionally want a protected preview connected to Oracle.

## 4. Verify before sharing

1. Open the production URL. It must show the demo password screen and no Oracle data.
2. An unauthenticated request to `/api/patients` must return `401`.
3. Sign in, then verify the app says **Oracle connected** and lists only synthetic seeded records.
4. Refresh `/patients` directly; it must still open the page.
5. Create one synthetic patient and verify it in Oracle.
6. In Vercel **Cron Jobs**, confirm the daily `/api/cron/keepalive` run succeeds. If it fails, investigate the logs and check the ADB status in Oracle Cloud.
7. Check Vercel **Usage** and Oracle **Always Free** status periodically, especially before a class demonstration. Keep an export of the schema and data; free tiers are not a backup plan.

If this requires guaranteed availability or real patient records, move to a paid, supported hosting and authentication design.
