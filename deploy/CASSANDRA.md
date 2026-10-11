# Cassandra cloud deployment

Status: Astra DB Free is Active and its connection, 55-event import, repeat-import idempotency, source parity, and real API paging/validation/health checks passed on 11 October 2026. Vercel production rollout remains pending. The existing deployed D.A. 2 site remains the baseline.

## Student steps for Astra DB

If Astra is accepted for the hosted demonstration:

1. Sign in or create an account at [Astra](https://astra.datastax.com/). Complete account verification and accept any terms yourself.
2. Keep the Free plan. Create a **Serverless (non-vector)** database named `care-continuum-da3`, with the first keyspace named `care_continuum`.
3. Select an unlocked Free-plan region near your application/users. If a region requires payment or an upgrade, use an available Free region instead.
4. Wait for the database to become Active.
5. Generate an application token scoped to this database with the table creation, read, and write permissions needed for initial setup/import. A suitable database-scoped role can be selected in the portal; avoid an organization-wide administrator token.
6. Download its **Secure Connect Bundle ZIP**. Keep the token and ZIP private; do not paste credentials into chat or commit them.

The managed provider controls the server/replication configuration. It is accurately described as Astra DB, powered by Cassandra, rather than a self-administered Apache Cassandra VM.

The current account offered AWS Ohio (`us-east-2`) as its unlocked Free region for the non-vector database. The initial custom role, `care-continuum-da3-import`, grants only **Describe Keyspace**, **Select Table**, **Modify Table**, **Describe Table**, **Create Table**, and **Access CQL**, scoped to this database's `care_continuum` keyspace. Modify Table includes record deletion; the import code only upserts mapped synthetic records. Its token expires on **9 January 2027** and must be replaced before that date if still used. Tokens and connection bundles are never part of the repository.

Official instructions: [database creation](https://docs.datastax.com/en/astra-db-serverless/databases/create-database.html), [application tokens](https://docs.datastax.com/en/astra-db-serverless/administration/manage-application-tokens.html), [driver connections](https://docs.datastax.com/en/astra-db-serverless/drivers/nodejs-driver.html).

## Configure locally without printing credentials

From the repository root, replace the ZIP path with your actual downloaded bundle:

```powershell
./deploy/setup-cassandra-cloud.ps1 -SecureBundleZip 'C:\path\to\secure-connect-care-continuum-da3.zip'
```

The helper asks for the token with hidden input and saves the cloud settings to ignored `backend/.env`, preserving Oracle configuration. Restart the backend after configuration changes. These cloud settings take precedence over local contact points; the local Docker data is not deleted.

From `backend/`:

```powershell
npm run timeline:setup
npm run timeline:import
npm run timeline:verify
```

`timeline:setup` creates only the timeline table in the existing keyspace; it does not recreate Oracle tables. `timeline:verify -- --outage` is restricted to local Docker configuration and must not be used for cloud verification.

## Vercel configuration

After local cloud verification succeeds:

```powershell
node deploy/prepare-cassandra-vercel-env.js
```

This creates ignored `.env.cassandra-vercel-import` with four server-side keys:

| Key | Purpose |
| --- | --- |
| `CASSANDRA_ENABLED` | `true` to enable the timeline |
| `CASSANDRA_KEYSPACE` | `care_continuum` |
| `CASSANDRA_TOKEN` | Scoped application token |
| `CASSANDRA_SECURE_BUNDLE_B64` | Encoded connection bundle |

Import those keys into Vercel **Production**, retaining all existing Oracle/authentication settings, then delete the temporary import file. For runtime-only access, a separately scoped read-only token can replace `CASSANDRA_TOKEN` in Vercel while the local import token retains write permission.

The function reconstructs the bundle in its temporary directory and reuses a driver client. No credentials enter frontend code or `VITE_` variables. Missing Cassandra configuration produces a timeline-only unavailable state; it does not prevent the Oracle application from starting.

Merge the verified D.A. 3 branch into `main` only when the hosted release is ready. Vercel builds the code; it does not create the Cassandra table or execute the import. Import source data separately, then verify authenticated timeline reads, paging, direct-page refreshes, and existing Oracle workflows in production.

## Free-plan limits and fallback

Astra's Free plan provides monthly credits and restricted regions; databases are suspended if those credits are exhausted. Check the current account allowance and usage before the demonstration. No paid upgrade is part of this setup.

To disable only the hosted timeline, set `CASSANDRA_ENABLED=false` in Vercel and redeploy. Existing Oracle functionality remains available. Do not remove the Oracle environment variables or run `db:setup` to troubleshoot Cassandra.
