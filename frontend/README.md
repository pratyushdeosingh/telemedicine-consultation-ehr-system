# Care Continuum Frontend

React interface for the Telemedicine Consultation and EHR System.

## Run locally

```bash
pnpm install
pnpm dev
```

Vite proxies `/api` requests to `http://localhost:3000` during development. To use another API host, copy `.env.example` to `.env` and set `VITE_API_URL`.

## Commands

- `pnpm dev` starts the development server.
- `pnpm build` creates a production build.
- `pnpm lint` runs the source-code checks.
