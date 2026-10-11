const test = require('node:test');
const assert = require('node:assert/strict');
const express = require('express');
const { createRefreshService } = require('../timelineRefresh');
const { readSource, importEvents } = require('../timelineImport');
const { registerTimelineRoutes } = require('../timelineRoutes');

test('refresh closes the read-only snapshot, reports partial results, and retains the shared Cassandra client', async () => {
    const actions = [];
    const connection = { rollback: async () => actions.push('rollback'), close: async () => actions.push('close') };
    const refresh = createRefreshService({ connect: async () => connection, getClient: async () => ({}),
        readSource: async () => { actions.push('read'); return {}; },
        mapSourceRecords: () => [{ patient_id: 'P', event_month: '2026-09' }, { patient_id: 'P', event_month: '2026-09' }],
        importEvents: async () => { actions.push('write'); return { attempted: 2, written: 1, failed: 1, failures: [{}] }; } });
    const result = await refresh();
    assert.deepEqual(actions, ['read', 'rollback', 'close', 'write']);
    assert.equal(result.status, 'partial');
    assert.equal(result.partitions, 1);
    assert.equal(result.failed, 1);
    assert.equal(result.failures, undefined);
    assert.ok(!Number.isNaN(Date.parse(result.completed_at)));
});

test('overlap is rejected, and read errors/size limits release the connection and running guard', async () => {
    let release;
    const blocked = new Promise(resolve => { release = resolve; });
    let closed = 0;
    let reads = 0;
    let writes = 0;
    const refresh = createRefreshService({ getClient: async () => ({}),
        connect: async () => ({ rollback: async () => {}, close: async () => { closed++; } }),
        readSource: async () => { if (++reads === 1) { await blocked; throw new Error('Secret database error'); } return {}; },
        mapSourceRecords: () => [1, 2], importEvents: async () => { writes++; return { attempted: 2, written: 2, failed: 0 }; } });
    const first = refresh();
    const failure = assert.rejects(first, /Secret database error/);
    await assert.rejects(refresh(), error => error.status === 409);
    release();
    await failure;
    await assert.rejects(refresh({ maxRecords: 1 }), error => error.status === 413);
    assert.equal(closed, 2);
    assert.equal(writes, 0);
    assert.equal((await refresh()).status, 'complete');
});

test('bounded Oracle reads reject truncation and expired deadlines', async () => {
    const connection = { execute: async (sql, params, options) => {
        if (sql === 'SET TRANSACTION READ ONLY') return {};
        assert.equal(options.maxRows, 3);
        return { rows: [1, 2, 3] };
    } };
    await assert.rejects(readSource(connection, { maxRows: 2 }), error => error.status === 413);
    await assert.rejects(readSource(connection, { deadline: 0 }), error => error.status === 408);
});

test('bounded writes stop new work after the deadline and constrain concurrent queries', async () => {
    const events = Array.from({ length: 7 }, (_, id) => ({ patient_id: 'P', event_id: `${id}` }));
    let active = 0, peak = 0, calls = 0;
    const client = { execute: async () => { calls++; active++; peak = Math.max(peak, active); await new Promise(resolve => setTimeout(resolve, 2)); active--; } };
    const result = await importEvents(client, events, { concurrency: 3 });
    assert.equal(result.written, 7);
    assert.equal(peak, 3);
    calls = 0;
    const expired = await importEvents(client, events, { deadline: 0 });
    assert.equal(calls, 0);
    assert.equal(expired.failed, 7);
    assert.equal(expired.timed_out, true);
});

test('HTTP import distinguishes partial, disabled, overlap, and sanitized connection failures', async () => {
    const app = express();
    let mode = 'partial';
    registerTimelineRoutes(app, { enabled: () => mode !== 'disabled', refreshTimeline: async () => {
        if (mode === 'partial') return { failed: 1, written: 2, status: 'partial' };
        throw Object.assign(new Error('Private driver connection string'), mode === 'busy' ? { status: 409, message: 'Refresh already running' } : {});
    } });
    const server = app.listen(0, '127.0.0.1');
    await new Promise(resolve => server.once('listening', resolve));
    try {
        const url = `http://127.0.0.1:${server.address().port}/api/timeline/import`;
        assert.equal((await fetch(url, { method: 'POST' })).status, 207);
        mode = 'disabled'; assert.equal((await fetch(url, { method: 'POST' })).status, 503);
        mode = 'busy'; assert.equal((await fetch(url, { method: 'POST' })).status, 409);
        mode = 'failure'; const failed = await fetch(url, { method: 'POST' });
        assert.equal(failed.status, 503);
        assert.doesNotMatch(await failed.text(), /Private driver/);
    } finally { server.closeAllConnections(); await new Promise(resolve => server.close(resolve)); }
});
