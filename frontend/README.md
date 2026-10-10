# Frontend

React/Vite interface for Care Continuum, with seven pages: Overview, Patients, Medical History, Laboratory, Appointments, Prescriptions, and Billing.

See the [project README](../README.md#run-locally) for full setup. From this directory:

```powershell
corepack pnpm install --frozen-lockfile
corepack pnpm dev
```

Copy `.env.example` to `.env.local` if that file does not exist. The default configuration calls the real Express API through Vite's `/api` proxy. Set `VITE_USE_DEMO_DATA=true` for a read-only offline preview, then restart Vite.

## Checks

```powershell
corepack pnpm lint
corepack pnpm build
```

Database and authentication credentials belong on the server. Do not place secrets in frontend files or `VITE_` variables.
