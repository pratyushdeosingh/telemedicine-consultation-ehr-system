// Read-only checks against the configured Oracle/Cassandra services and local API.
// Usage from the repository root: node tests/evidence/collect-database-evidence.cjs
// Optional first argument: output directory (defaults to tests/results/YYYY-MM-DD in IST).
const fs = require('node:fs');
const path = require('node:path');
const assert = require('node:assert/strict');
const { createRequire } = require('node:module');
const root = path.resolve(__dirname, '../..');
const backend = path.join(root, 'backend');
const backendRequire = createRequire(path.join(backend, 'package.json'));
backendRequire('dotenv').config({ path: path.join(backend, '.env'), quiet: true });
const oracle = backendRequire('oracledb');
const dbConfig = require(path.join(backend, 'dbConfig'));
const cassandra = require(path.join(backend, 'cassandraConfig'));

async function main() {
    let connection;
    try {
        connection = await oracle.getConnection({ ...dbConfig, connectTimeout: 10, transportConnectTimeout: 10, retryCount: 0 });
        connection.callTimeout = 15000;
        const versions = await connection.execute('SELECT product, version_full FROM product_component_version');
        assert.ok(versions.rows.length, 'Oracle version metadata must be present');
        const triggers = await connection.execute(`SELECT t.TRIGGER_NAME, t.STATUS, o.STATUS FROM USER_TRIGGERS t
            JOIN USER_OBJECTS o ON o.OBJECT_NAME=t.TRIGGER_NAME AND o.OBJECT_TYPE='TRIGGER'
            WHERE t.TRIGGER_NAME IN ('PREVENT_ALLERGIC_PRESCRIPTION','TRG_CREATE_TELEMEDICINE_SESSION') ORDER BY t.TRIGGER_NAME`);
        assert.equal(triggers.rows.length, 2);
        triggers.rows.forEach(row => assert.deepEqual(row.slice(1), ['ENABLED', 'VALID']));
        const rejected = (await connection.execute("SELECT COUNT(*) FROM PRESCRIPTION WHERE Prescription_No = 'RPT-ALG-1101'")).rows[0][0];
        assert.equal(rejected, 0, 'Rejected screenshot-demonstration prescription must not be stored');
        const sessions = await connection.execute(`SELECT Appointment_ID, Session_ID, Network_Quality_Log FROM TELEMEDICINE_SESSION
            WHERE Network_Quality_Log = 'Session created automatically' ORDER BY Appointment_ID FETCH FIRST 4 ROWS ONLY`);
        const client = await cassandra.getClient();
        const keyspace = cassandra.keyspace();
        const schema = await client.execute('SELECT column_name,kind,position,type,clustering_order FROM system_schema.columns WHERE keyspace_name = ? AND table_name = ?',
            [keyspace, 'clinical_events_by_patient_month'], { prepare: true });
        const cql = `SELECT event_time,event_type,summary FROM ${keyspace}.clinical_events_by_patient_month WHERE patient_id = ? AND event_month = ? LIMIT 5`;
        const records = await client.execute(cql, ['PAT-01', '2026-09'], { prepare: true });
        assert.equal(records.rows.length, 5, 'PAT-01/2026-09 screenshot fixture expects five events');
        for (let i = 1; i < records.rows.length; i++) assert.ok(records.rows[i - 1].event_time >= records.rows[i].event_time);
        const base = process.env.EVIDENCE_API_URL || 'http://127.0.0.1:3000/api';
        async function get(route) {
            const response = await fetch(base + route, { signal: AbortSignal.timeout(15000) });
            return { status: response.status, body: await response.json() };
        }
        let cursor;
        const pages = [], identities = [];
        do {
            assert.ok(pages.length < 100, 'Paging must terminate');
            const query = new URLSearchParams({ month: '2026-09', limit: '2' });
            if (cursor) query.set('cursor', cursor);
            const response = await get(`/timeline/PAT-01?${query}`);
            assert.equal(response.status, 200);
            assert.ok(response.body.events.length <= 2);
            pages.push({ page: pages.length + 1, http_status: response.status, events: response.body.events.length, has_next_page: Boolean(response.body.next_cursor) });
            identities.push(...response.body.events.map(event => `${event.event_time}:${event.event_id}`));
            cursor = response.body.next_cursor;
        } while (cursor);
        assert.equal(identities.length, 5);
        assert.equal(new Set(identities).size, 5);
        const invalid = await get('/timeline/PAT-01?month=2026-13');
        assert.equal(invalid.status, 400);
        const empty = await get('/timeline/EMPTY-DEMO?month=2026-09');
        assert.equal(empty.status, 200);
        assert.equal(empty.body.events.length, 0);
        const date = new Intl.DateTimeFormat('en-CA', { timeZone: 'Asia/Kolkata', year: 'numeric', month: '2-digit', day: '2-digit' }).format(new Date());
        const output = path.resolve(root, process.argv[2] || `tests/results/${date}`);
        fs.mkdirSync(output, { recursive: true });
        const evidence = { captured_date: date, captured_at: new Date().toISOString(), oracle_versions: versions.rows,
            triggers: triggers.rows, browser_rejected_prescription_count: rejected, automatic_sessions: sessions.rows,
            schema: schema.rows, cql, query_parameters: ['PAT-01', '2026-09'], events: records.rows, pages,
            invalid_month: invalid, empty_partition: { status: empty.status, event_count: empty.body.events.length } };
        fs.writeFileSync(path.join(output, 'database-evidence.json'), JSON.stringify(evidence, null, 2) + '\n');
        const summary = [
            `Oracle: ${versions.rows.map(row => row.join(' ')).join('; ')}`,
            'PASS: both Oracle triggers ENABLED / VALID; rejected browser prescription count = 0.',
            'PASS: Cassandra five-event partition read, descending order, three-page read without duplicate identities.',
            'PASS: invalid month returns HTTP 400; empty partition returns HTTP 200 with zero events.',
            'Read-only verification completed; no import, schema changes or data writes performed.',
        ].join('\n') + '\n';
        fs.writeFileSync(path.join(output, 'database-checks.txt'), summary);
        console.log(summary);
    } finally {
        if (connection) { await connection.rollback(); await connection.close(); }
        await cassandra.shutdown();
    }
}
main().catch(error => {
    console.error(`Database evidence check failed: ${error.code || error.name}${error.name === 'AssertionError' ? ': ' + error.message : ''}`);
    process.exitCode = 1;
});
