# Azure App Service deployment path

This is the simpler hosted option for the academic demo. One Azure App Service web app runs Express and serves the built React frontend at the same `azurewebsites.net` HTTPS address. Oracle Autonomous Database remains the data store. No VM, Caddy, or custom domain is required.

**Availability and cost limit:** Free F1 is for experiments, has no SLA, and provides 60 CPU minutes per day, 1 GB memory, and 1 GB storage. Azure stops an app when its CPU or bandwidth quota is exhausted until the quota resets. It is unsuitable if the demo must remain reliably available. Before creating any resource, confirm the exact plan and price on Azure's Review + create page; optional Azure resources may have separate costs. The separate Oracle Always Free database also stops automatically after seven days of inactivity. See [Azure F1 pricing](https://azure.microsoft.com/en-in/pricing/details/app-service/linux/), [quota behavior](https://learn.microsoft.com/en-us/azure/app-service/web-sites-monitor), and [Oracle Always Free behavior](https://docs.oracle.com/en-us/iaas/autonomous-database-serverless/doc/autonomous-always-free.html).

## Azure setup

1. Confirm the **Azure for Students** subscription is active in the Azure portal.
2. Search **App Services**, select **Create** → **Web App**.
3. On Basics, choose the student subscription, make a new resource group (for example `telemedicine-demo-rg`), select **Code**, **Node 24 LTS**, and **Linux**. Choose a region where **Free F1** is available. Enter a unique app name. Review the pricing summary before creation; select **Free F1**, not a paid plan.
4. Under the created app's **Settings → Environment variables**, set `NODE_ENV=production`, `HOST=0.0.0.0`, `SERVE_FRONTEND=true`, `EXTERNAL_AUTH=true`, `PUBLIC_ORIGIN=https://<the-actual-Azure-hostname>`, `ORACLE_USER`, `ORACLE_PASSWORD`, and the Oracle **TLS low** `ORACLE_CONNECT_STRING`. Keep passwords only in Azure app settings. Use the hostname actually shown on the app Overview page. Set `EXTERNAL_AUTH=true` only after enabling Azure's built-in authentication in step 5.
5. Under **Settings → Authentication**, add Microsoft Entra ID, require authentication for all requests, and reject/redirect unauthenticated requests. Limit allowed users to the intended demo audience. Do this **before** deploying application data.
6. Under **Settings → Configuration**, enable **HTTPS Only** and minimum TLS 1.2 or newer.
7. On the app's **Networking** page, copy its outbound IP addresses. Add the current addresses to the Oracle Autonomous Database access control list for walletless TLS. Recheck this list if the App Service plan or region changes.

The source deploy package must include `backend/`, a production `frontend/dist/` built with `VITE_API_URL=/api` and `VITE_USE_DEMO_DATA=false`, and Linux-installed backend dependencies. Set the App Service startup command to `node backend/server.js`. A repeatable deployment package and exact upload procedure will be prepared once the web app exists and its platform settings can be verified.

Never run `npm run db:setup` against a schema containing records you need. Use synthetic patient data only; Azure sign-in is a demo access gate, not clinical authorization.
