const path = require('node:path');
const assert = require('node:assert/strict');
const { promisify } = require('node:util');
const execFile = promisify(require('node:child_process').execFile);
require('dotenv').config({ path: path.join(__dirname, '..', '.env'), quiet: true });
const oracle = require('oracledb');
const dbConfig = require('../dbConfig');
const cassandra = require('../cassandraConfig');
const { readSource, mapSourceRecords, importEvents } = require('../timelineImport');

async function main() {
    let connection;
    let server;
    let stopped = false;
    const compose = ['compose', '-f', path.join(__dirname, '../../cassandra/compose.yaml')];
    const outage = process.argv.includes('--outage');
    if (outage && (process.env.CASSANDRA_TOKEN || process.env.CASSANDRA_SECURE_BUNDLE_PATH || process.env.CASSANDRA_SECURE_BUNDLE_B64
        || (process.env.CASSANDRA_CONTACT_POINTS && process.env.CASSANDRA_CONTACT_POINTS !== '127.0.0.1'))) throw new Error('Outage test is local-only');
    try {
        let client = await cassandra.getClient();
        connection = await oracle.getConnection({ ...dbConfig, connectTimeout: 10, transportConnectTimeout: 10, retryCount: 0 });
        connection.callTimeout = 15000;
        const events = mapSourceRecords(await readSource(connection));
        assert.ok(events.length, 'Need synthetic Oracle source records');
        const partitions = new Map();
        for (const event of events) {
            const key = `${event.patient_id}:${event.event_month}`;
            if (!partitions.has(key)) partitions.set(key, { patient: event.patient_id, month: event.event_month, events: [] });
            partitions.get(key).events.push(event);
        }
        const first = await importEvents(client, events);
        assert.equal(first.failed, 0);
        const counts = new Map();
        for (const [id, partition] of partitions) {
            const result = await client.execute(`SELECT event_id, event_time, summary FROM ${cassandra.keyspace()}.clinical_events_by_patient_month
                WHERE patient_id = ? AND event_month = ?`, [partition.patient, partition.month], { prepare: true });
            const rows = [];
            for await (const row of result) rows.push(row);
            counts.set(id, rows.length);
            for (const event of partition.events) assert.ok(rows.some((row) => row.event_id === event.event_id
                && row.event_time.getTime() === event.event_time.getTime() && row.summary === event.summary));
        }
        const second = await importEvents(client, events);
        assert.equal(second.failed, 0);
        for (const [id, partition] of partitions) {
            const result = await client.execute(`SELECT COUNT(*) AS total FROM ${cassandra.keyspace()}.clinical_events_by_patient_month
                WHERE patient_id = ? AND event_month = ?`, [partition.patient, partition.month], { prepare: true });
            assert.equal(Number(result.rows[0].total), counts.get(id));
        }
        console.log(`PASS: ${events.length} source events imported into ${partitions.size} patient/month partitions; all summaries/dates match; repeat import creates no duplicates`);
        const app = require('../server');
        server = app.listen(0, '127.0.0.1');
        await new Promise((resolve) => server.once('listening', resolve));
        const base = `http://127.0.0.1:${server.address().port}/api`;
        const partition = [...partitions.values()].find((p) => p.events.length > 2) || [...partitions.values()][0];
        let cursor;
        const paged = [];
        do {
            const query = new URLSearchParams({ month: partition.month, limit: '2' });
            if (cursor) query.set('cursor', cursor);
            const response = await fetch(`${base}/timeline/${partition.patient}?${query}`, { signal: AbortSignal.timeout(15000) });
            assert.equal(response.status, 200);
            const page = await response.json();
            assert.ok(page.events.length <= 2);
            paged.push(...page.events);
            cursor = page.next_cursor;
        } while (cursor);
        assert.equal(paged.length, counts.get(`${partition.patient}:${partition.month}`));
        assert.equal(new Set(paged.map((e) => `${e.event_time}:${e.event_id}`)).size, paged.length);
        for (let i = 1; i < paged.length; i++) assert.ok(paged[i - 1].event_time >= paged[i].event_time);
        assert.equal((await fetch(`${base}/timeline/${partition.patient}?month=2026-13`)).status, 400);
        const empty = await (await fetch(`${base}/timeline/EMPTY-DEMO?month=2026-09`)).json();
        assert.deepEqual(empty.events, []);
        assert.equal((await (await fetch(`${base}/timeline/health`)).json()).connected, true);
        console.log('PASS: real timeline API, multi-page reads without missing/duplicate rows, date order, validation, empty partition and health');
        if (outage) {
            await cassandra.shutdown();
            stopped = true;
            await execFile('docker', [...compose, 'stop', 'cassandra'], { timeout: 60000 });
            assert.equal((await fetch(`${base}/timeline/${partition.patient}?month=${partition.month}`, { signal: AbortSignal.timeout(20000) })).status, 503);
            assert.equal((await fetch(`${base}/patients`, { signal: AbortSignal.timeout(20000) })).status, 200);
            console.log('PASS: real Cassandra outage returns 503 while Oracle patient reads still succeed');
            await execFile('docker', [...compose, 'up', '-d', '--wait', '--wait-timeout', '240'], { timeout: 260000 });
            stopped = false;
            client = await cassandra.getClient();
            assert.equal((await (await fetch(`${base}/timeline/health`)).json()).connected, true);
            console.log('PASS: Cassandra recovery and reconnection');
        }
        console.log('Timeline verification completed. Oracle was read-only; imported Cassandra records retained.');
    } finally {
        if (server) { server.closeAllConnections(); await new Promise((resolve) => server.close(resolve)); }
        if (connection) { await connection.rollback(); await connection.close(); }
        await cassandra.shutdown();
        if (stopped) await execFile('docker', [...compose, 'up', '-d', '--wait', '--wait-timeout', '240'], { timeout: 260000 });
    }
}

main().catch((error) => {
    console.error(`Timeline verification failed: ${error.name === 'AssertionError' ? error.message : error.code || error.name}`);
    process.exitCode = 1;
});
