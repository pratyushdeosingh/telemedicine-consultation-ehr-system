const test = require('node:test');
const assert = require('node:assert/strict');
const express = require('express');
const { calendarDate, mapSourceRecords, validatePartition } = require('../timelineModel');
const { signCursor, readCursor, registerTimelineRoutes } = require('../timelineRoutes');
const { buildOptions } = require('../cassandraConfig');
const { importEvents } = require('../timelineImport');

test('source dates preserve calendar month across host time zones', () => {
    assert.equal(calendarDate('2026-09-01').event_time.toISOString(), '2026-09-01T00:00:00.000Z');
    assert.equal(calendarDate('2026-09-01').event_month, '2026-09');
    assert.throws(() => calendarDate('2026-02-30'));
    assert.throws(() => calendarDate('2026-09-01T00:00:00Z'));
});

test('mapping keeps composite source identities and groups medicine rows', () => {
    const base = { PATIENT_ID: 'PAT-01', PATIENT_NAME: 'Synthetic Patient', EVENT_DATE: '2026-09-01', APPOINTMENT_ID: 'APT-01' };
    const source = { allergies: [{ PATIENT_ID: 'PAT-01', LOG_SEQ_NO: 1, ALLERGY_NAME: 'Penicillin' }],
        logs: [{ ...base, LOG_SEQ_NO: 1, DIAGNOSIS: 'Synthetic history' }], appointments: [],
        prescriptions: [{ ...base, PRESCRIPTION_NO: 'RX-01', MEDICINE_NAME: 'Medicine A', DOSAGE: 'Dose A' },
            { ...base, PRESCRIPTION_NO: 'RX-01', MEDICINE_NAME: 'Medicine B', DOSAGE: 'Dose B' },
            { ...base, APPOINTMENT_ID: 'APT-02', PRESCRIPTION_NO: 'RX-01', MEDICINE_NAME: 'Medicine C', DOSAGE: 'Dose C' }],
        orders: [], results: [], invoices: [{ ...base, INVOICE_NO: 'INV-01', TOTAL_AMOUNT: 50, PAYMENT_STATUS: 'Paid' }] };
    const events = mapSourceRecords(source);
    assert.equal(events.length, 4);
    assert.match(events[0].summary, /Penicillin/);
    assert.equal(events.filter((e) => e.event_type === 'PRESCRIPTION').length, 2);
    assert.match(events[1].summary, /Medicine A.*Medicine B/);
    assert.equal(new Set(events.map((e) => e.event_id)).size, 4);
    assert.equal(events.at(-1).event_time.toISOString(), '2026-09-01T00:00:00.000Z');
    assert.match(events.at(-1).summary, /Current status: Paid/);
});

test('partition and cursor validation reject forged or cross-query paging', () => {
    assert.throws(() => validatePartition('PAT-01', '2026-13'));
    assert.throws(() => validatePartition("PAT';--", '2026-09'));
    assert.throws(() => validatePartition('PAT-01', ['2026-09']));
    const cursor = signCursor('aabbcc', 'PAT-01', '2026-09', 2);
    assert.equal(readCursor(cursor, 'PAT-01', '2026-09', 2), 'aabbcc');
    assert.throws(() => readCursor(cursor, 'PAT-02', '2026-09', 2));
    assert.throws(() => readCursor(cursor, 'PAT-01', '2026-08', 2));
    assert.throws(() => readCursor(cursor, 'PAT-01', '2026-09', 3));
    assert.throws(() => readCursor(cursor + '0', 'PAT-01', '2026-09', 2));
});

test('Vercel configuration never falls back to laptop-local Cassandra', () => {
    assert.throws(() => buildOptions({ VERCEL: '1' }), /Hosted Cassandra/);
    assert.equal(buildOptions({}).contactPoints[0], '127.0.0.1');
    assert.equal(buildOptions({}).queryOptions.consistency, require('cassandra-driver').types.consistencies.localQuorum);
    assert.throws(() => buildOptions({ CASSANDRA_PORT: 'invalid' }));
});

test('partial import reports a retryable failure without losing successful writes', async () => {
    const events = [1, 2].map((id) => ({ patient_id: 'PAT-01', event_id: `history:${id}` }));
    const client = { execute: async (sql, params, options) => {
        assert.equal(options.prepare, true);
        assert.match(sql, /VALUES \(\?,/);
        if (params[3] === 'history:2') throw new Error('Synthetic outage');
    } };
    const result = await importEvents(client, events);
    assert.deepEqual(result, { attempted: 2, written: 1, failed: 1, failures: [{ patient_id: 'PAT-01', event_id: 'history:2' }] });
});

test('timeline failure remains isolated and invalid input does not query Cassandra', async () => {
    const app = express();
    let reads = 0;
    registerTimelineRoutes(app, { enabled: () => true, getClient: async () => { reads++; throw new Error('Unavailable'); } });
    app.get('/oracle-page', (req, res) => res.json({ available: true }));
    const server = app.listen(0, '127.0.0.1');
    await new Promise((resolve) => server.once('listening', resolve));
    const base = `http://127.0.0.1:${server.address().port}`;
    try {
        assert.equal((await fetch(base + '/api/timeline/PAT-01?month=2026-13')).status, 400);
        assert.equal(reads, 0);
        assert.equal((await fetch(base + '/api/timeline/PAT-01?month=2026-09')).status, 503);
        assert.equal((await fetch(base + '/oracle-page')).status, 200);
    } finally { server.closeAllConnections(); await new Promise((resolve) => server.close(resolve)); }
});
