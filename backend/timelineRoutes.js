const crypto = require('node:crypto');
const config = require('./cassandraConfig');
const { validatePartition } = require('./timelineModel');
const { refreshTimeline } = require('./timelineRefresh');

const cursorSecret = process.env.SESSION_SECRET || crypto.randomBytes(32).toString('hex');

function signCursor(state, patient, month, limit) {
    if (!state) return null;
    const payload = Buffer.from(JSON.stringify({ state, patient, month, limit })).toString('base64url');
    return `${payload}.${crypto.createHmac('sha256', cursorSecret).update(payload).digest('hex')}`;
}

function readCursor(cursor, patient, month, limit) {
    if (!cursor) return undefined;
    if (typeof cursor !== 'string' || cursor.length > 8192) throw new Error('Invalid timeline cursor');
    const parts = cursor.split('.');
    if (parts.length !== 2) throw new Error('Invalid timeline cursor');
    const signature = crypto.createHmac('sha256', cursorSecret).update(parts[0]).digest('hex');
    if (!/^[a-f0-9]{64}$/.test(parts[1]) || !crypto.timingSafeEqual(Buffer.from(signature), Buffer.from(parts[1]))) throw new Error('Invalid timeline cursor');
    const value = JSON.parse(Buffer.from(parts[0], 'base64url').toString());
    if (value.patient !== patient || value.month !== month || value.limit !== limit || typeof value.state !== 'string') throw new Error('Cursor belongs to a different timeline query');
    return value.state;
}

function registerTimelineRoutes(app, dependencies = {}) {
    const getClient = dependencies.getClient || config.getClient;
    const isEnabled = dependencies.enabled || config.enabled;
    app.post('/api/timeline/import', async (req, res) => {
        if (!isEnabled()) return res.status(503).json({ error: 'Cassandra is not configured. Oracle records remain available.' });
        try {
            const result = await (dependencies.refreshTimeline || refreshTimeline)();
            res.status(result.failed ? 207 : 200).json(result);
        } catch (error) {
            const expected = [409, 413, 408].includes(error.status);
            res.status(expected ? error.status : 503).json({ error: expected ? error.message : 'Refresh could not complete. Check both database connections and retry. Some Cassandra records may have been updated; retrying is safe.' });
        }
    });
    app.get('/api/timeline/health', async (req, res) => {
        if (!isEnabled()) return res.json({ enabled: false, connected: false });
        try {
            const client = await getClient();
            await client.execute(`SELECT patient_id FROM ${config.keyspace()}.clinical_events_by_patient_month WHERE patient_id = ? AND event_month = ? LIMIT 1`, ['DEMO-HEALTH', '2000-01'], { prepare: true });
            res.json({ enabled: true, connected: true });
        } catch { res.status(503).json({ error: 'Cassandra timeline unavailable', enabled: true, connected: false }); }
    });
    app.get('/api/timeline/:patient_id', async (req, res) => {
        let patient, month, limit, pageState;
        try {
            ({ patient, month } = validatePartition(req.params.patient_id, req.query.month));
            if (req.query.limit !== undefined && (typeof req.query.limit !== 'string' || !/^\d+$/.test(req.query.limit))) throw new Error('Invalid page size');
            limit = Number(req.query.limit || 25);
            if (!Number.isInteger(limit) || limit < 1 || limit > 100) throw new Error('Page size must be between 1 and 100');
            pageState = readCursor(req.query.cursor, patient, month, limit);
        } catch (error) { return res.status(400).json({ error: error.message }); }
        if (!isEnabled()) return res.status(503).json({ error: 'Cassandra timeline is not configured. Oracle medical history remains available.' });
        try {
            const client = await getClient();
            const result = await client.execute(`SELECT event_time, event_id, event_type, patient_name, appointment_id, summary, source_record_id
                FROM ${config.keyspace()}.clinical_events_by_patient_month WHERE patient_id = ? AND event_month = ?`,
            [patient, month], { prepare: true, fetchSize: limit, pageState });
            const events = result.rows.map((row) => ({ patient_id: patient, event_month: month,
                event_time: row.event_time.toISOString(), event_id: row.event_id, event_type: row.event_type,
                patient_name: row.patient_name, appointment_id: row.appointment_id, summary: row.summary, source_record_id: row.source_record_id }));
            res.json({ events, next_cursor: signCursor(result.pageState, patient, month, limit), source: 'cassandra', sync_mode: 'manual-import' });
        } catch { res.status(503).json({ error: 'Cassandra timeline unavailable. Retry when the database is connected; Oracle medical history remains available.' }); }
    });
}

module.exports = { registerTimelineRoutes, signCursor, readCursor };
