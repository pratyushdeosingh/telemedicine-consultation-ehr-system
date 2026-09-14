# Care Continuum Frontend

The React/Vite interface for the Telemedicine Consultation and EHR System.

The complete architecture, API contract, setup order, branch workflow, known limitations, troubleshooting notes and viva explanation are maintained in the [project README](../README.md).

## Start locally

```bash
pnpm install
pnpm dev
```

Copy `.env.example` to `.env.local` and select a data mode:

```env
VITE_API_URL=/api
VITE_USE_DEMO_DATA=true
```

Use `true` for standalone UI preview or `false` to call the Express/Oracle API. Restart Vite after changing environment variables.

## Verify before committing

```bash
pnpm lint
pnpm run build
```

Never commit `.env.local`, API/database credentials, `node_modules` or `dist`.
