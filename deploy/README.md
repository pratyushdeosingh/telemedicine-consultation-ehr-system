# Deploy the academic demo on Oracle Cloud

This setup runs the React build and Express API on one Ubuntu VM behind Caddy. Caddy obtains HTTPS certificates, asks for a demo username/password, and sends `/api/*` to Express bound to loopback. Oracle Autonomous Database stores the data. Use **synthetic data only**. This is a single shared demo account, not clinical authentication or a compliant EHR.

## 1. What you need

- An [Oracle Cloud Free Tier account](https://www.oracle.com/cloud/free/) and an Ubuntu compute VM with a reserved public IP. Create the account first; keep account and payment details inside Oracle's site.
- A domain or subdomain with an A record pointing to that IP.
- An Autonomous AI Database (Always Free is sufficient for a small demo).
- SSH access to the VM.

In Oracle Cloud, [create an Ubuntu compute instance](https://docs.oracle.com/en-us/iaas/Content/Compute/Tasks/launchinginstance.htm) in your home region using an **Always Free eligible** shape and a reserved public IP. In the VM subnet security list or network security group, allow inbound TCP **22 from your own IP** and TCP **80 and 443 from the internet**. Do not allow inbound 3000 or 1521. Apply OS updates and enable unattended security updates. Keep the VM's public IP stable, since you will allowlist it for database access. If no Always Free capacity is available, try another availability domain or wait; check pricing before selecting a paid shape.

## 2. Database

Create an Autonomous AI Database and a dedicated application schema user. Do not use `ADMIN` as `ORACLE_USER`. In Database Actions as `ADMIN`, create the user and grant the minimum rights needed to create the project schema:

```sql
CREATE USER TELEMEDICINE_APP IDENTIFIED BY "choose-a-unique-long-password";
GRANT CREATE SESSION, CREATE TABLE, CREATE SEQUENCE, CREATE PROCEDURE, CREATE TRIGGER TO TELEMEDICINE_APP;
ALTER USER TELEMEDICINE_APP QUOTA UNLIMITED ON DATA;
```

Use the actual default tablespace name if it is not `DATA`. For a [walletless TLS connection](https://node-oracledb.readthedocs.io/en/latest/user_guide/connection_handling.html#one-way-tls-connection-to-oracle-autonomous-database), set database network access to allow TLS, then put only the VM's public IP in the database access control list. In the database's **Database connection** panel, copy its **TLS** connection string for the `low` service into `ORACLE_CONNECT_STRING`. Do not use a plain TCP string. Do not put the database password in Git, the frontend, or a browser variable.

The schema setup script **drops and recreates** project tables. Run it once in a fresh, disposable `TELEMEDICINE_APP` schema. Never rerun it after keeping records you need.

## 3. Install on the VM

Install Node.js 24 and [Caddy](https://caddyserver.com/docs/install) using their official Ubuntu instructions. Verify `node --version`, `npm --version`, and `caddy version`. Install Git if you will clone the repository. Use the repository's `frontend/pnpm-lock.yaml` with Corepack.

```bash
sudo useradd --system --home /srv/telemedicine-ehr --shell /usr/sbin/nologin telemedicine
sudo mkdir -p /srv/telemedicine-ehr /etc/telemedicine-ehr
sudo chown telemedicine:telemedicine /srv/telemedicine-ehr
sudo chmod 750 /etc/telemedicine-ehr
# Copy or clone this repository into /srv/telemedicine-ehr.
cd /srv/telemedicine-ehr/backend
sudo -u telemedicine npm ci --omit=dev
cd ../frontend
sudo -u telemedicine corepack pnpm install --frozen-lockfile
sudo -u telemedicine env VITE_API_URL=/api VITE_USE_DEMO_DATA=false corepack pnpm build
```

Keep `/srv/telemedicine-ehr` owned by `telemedicine` and readable by the `caddy` user for `frontend/dist` (for example, grant read and traverse permissions using an ACL). Do not make backend `.env` or credentials readable by Caddy.

Create `/etc/telemedicine-ehr/api.env` as root, mode `600`, with:

```env
HOST=127.0.0.1
PORT=3000
EXTERNAL_AUTH=true
PUBLIC_ORIGIN=https://your-domain.example
ORACLE_USER=TELEMEDICINE_APP
ORACLE_PASSWORD=your-long-database-password
ORACLE_CONNECT_STRING=your-copied-TLS-low-service-string
```

If a password or connection string contains shell special characters, use systemd `EnvironmentFile` quoting rules. Run `sudo systemd-analyze verify /etc/systemd/system/telemedicine-api.service` before starting. Never paste the actual secret into issue trackers or chat.

## 4. Start the API

Copy `deploy/telemedicine-api.service` to `/etc/systemd/system/telemedicine-api.service`. Then:

```bash
sudo systemctl daemon-reload
sudo systemctl enable --now telemedicine-api
sudo systemctl status telemedicine-api
curl --fail http://127.0.0.1:3000/api/test-db
```

For the fresh demo schema, run the destructive setup **only after reviewing the script and confirming that the schema is empty**:

```bash
sudo systemd-run --wait --collect --pty \
  -p User=telemedicine \
  -p WorkingDirectory=/srv/telemedicine-ehr/backend \
  -p EnvironmentFile=/etc/telemedicine-ehr/api.env \
  /usr/bin/npm run db:setup
```

Verify `/api/test-db` again after setup.

## 5. Start HTTPS and the access gate

Generate a long random demo password and its bcrypt hash with `caddy hash-password`. Save the clear password in your password manager. Create `/etc/telemedicine-ehr/caddy.env` (root owned, mode `600`):

```env
SITE_DOMAIN=your-domain.example
DEMO_USER=your-demo-username
DEMO_PASSWORD_HASH=the-output-of-caddy-hash-password
```

Copy `deploy/Caddyfile` to `/etc/caddy/Caddyfile`. Add this systemd drop-in at `/etc/systemd/system/caddy.service.d/telemedicine.conf`:

```ini
[Service]
EnvironmentFile=/etc/telemedicine-ehr/caddy.env
```

Then:

```bash
sudo systemctl daemon-reload
sudo caddy validate --config /etc/caddy/Caddyfile
sudo systemctl enable --now caddy
sudo systemctl reload caddy
```

Check `https://your-domain.example`: it should demand credentials before showing any page or API response. Check `/patients` by direct navigation and `/api/test-db` after authenticating. From another machine, `http://VM_IP:3000` must be unreachable. The browser should show **Oracle connected** and be able to create a synthetic patient.

## 6. Operations

- Deploy updates by copying new source, running `npm ci --omit=dev` and the locked frontend install/build, then restarting the API and reloading Caddy only when its config changes.
- Keep the OS, Node.js, Caddy, and dependencies updated. Review `npm audit --omit=dev` and `pnpm audit` before releases.
- Back up data with Oracle's database backup/export features. Test restoring a copy before relying on it. A code checkout is not a database backup.
- Rotate the demo password and Oracle password if disclosed. Give each person an individual account before any use beyond a small academic demo.
- Check `journalctl -u telemedicine-api -n 100` and `journalctl -u caddy -n 100` for startup failures. Do not publish logs containing patient data.

The deployment is complete only after the live HTTPS, authentication, API, and database checks above pass. Until then, the app is prepared for deployment but is not hosted.
