const test = require('node:test');
const assert = require('node:assert/strict');
const crypto = require('node:crypto');
const http = require('node:http');

const password = 'synthetic-demo-password';
const salt = crypto.randomBytes(16);
delete process.env.NODE_ENV;
process.env.VERCEL = '1';
process.env.EXTERNAL_AUTH = 'true';
delete process.env.PUBLIC_ORIGIN;
process.env.VERCEL_PROJECT_PRODUCTION_URL = 'demo.vercel.app';
process.env.ORACLE_USER = 'unused';
process.env.ORACLE_PASSWORD = 'unused';
process.env.ORACLE_CONNECT_STRING = 'unused';
process.env.ORACLE_WALLET_B64 = Buffer.from('unused').toString('base64');
process.env.ORACLE_WALLET_PASSWORD = 'unused';
process.env.DEMO_PASSWORD_SCRYPT = `${salt.toString('hex')}:${crypto.scryptSync(password, salt, 64).toString('hex')}`;
process.env.SESSION_SECRET = 'a'.repeat(40);
process.env.CRON_SECRET = 'b'.repeat(40);

const app = require('../server');

test('demo API requires login and rejects a foreign origin', async () => {
    const server = app.listen(0, '127.0.0.1');
    await new Promise((resolve) => server.once('listening', resolve));
    const base = `http://127.0.0.1:${server.address().port}`;
    try {
        const blocked = await fetch(`${base}/api/patients`);
        assert.equal(blocked.status, 401);

        const foreign = await fetch(`${base}/api/login`, {
            method: 'POST',
            headers: { Origin: 'https://elsewhere.example', 'Content-Type': 'application/json' },
            body: JSON.stringify({ password })
        });
        assert.equal(foreign.status, 403);

        const login = await fetch(`${base}/api/login`, {
            method: 'POST',
            headers: { Origin: 'https://demo.vercel.app', 'Content-Type': 'application/json' },
            body: JSON.stringify({ password })
        });
        assert.equal(login.status, 200);
        const cookie = login.headers.get('set-cookie').split(';')[0];
        assert.match(login.headers.get('set-cookie'), /HttpOnly; Secure; SameSite=Strict/);

        const session = await fetch(`${base}/api/session`, { headers: { Cookie: cookie } });
        assert.deepEqual(await session.json(), { authenticated: true });
    } finally {
        server.closeAllConnections();
        await new Promise((resolve) => server.close(resolve));
    }
});

test('Vercel API wrapper routes the session endpoint', async () => {
    const handler = require('../../api/index');
    const server = http.createServer((req, res) => {
        req.query = Object.fromEntries(new URL(req.url, 'http://localhost').searchParams);
        handler(req, res);
    });
    await new Promise((resolve) => server.listen(0, '127.0.0.1', resolve));
    try {
        const response = await fetch(`http://127.0.0.1:${server.address().port}/api/index?path=session`);
        assert.equal(response.status, 200);
        assert.deepEqual(await response.json(), { authenticated: false });
    } finally {
        server.closeAllConnections();
        await new Promise((resolve) => server.close(resolve));
    }
});
