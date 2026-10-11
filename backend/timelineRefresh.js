const oracle = require('oracledb');
const dbConfig = require('./dbConfig');
const cassandra = require('./cassandraConfig');
const { readSource, mapSourceRecords, importEvents } = require('./timelineImport');

function createRefreshService(dependencies = {}) {
    const connect = dependencies.connect || (() => oracle.getConnection({ ...dbConfig, connectTimeout: 10, transportConnectTimeout: 10, retryCount: 0 }));
    const getClient = dependencies.getClient || cassandra.getClient;
    const read = dependencies.readSource || readSource;
    const map = dependencies.mapSourceRecords || mapSourceRecords;
    const write = dependencies.importEvents || importEvents;
    let running = false;
    return async function refresh({ maxRecords = 2000, timeoutMs = 120000, concurrency = 4 } = {}) {
        if (running) throw Object.assign(new Error('A refresh is already running. Please try again shortly.'), { status: 409 });
        running = true;
        const deadline = Date.now() + timeoutMs;
        let connection;
        try {
            const client = await getClient();
            connection = await connect();
            connection.callTimeout = 15000;
            const events = map(await read(connection, { maxRows: maxRecords, deadline }));
            if (events.length > maxRecords) throw Object.assign(new Error('This dataset exceeds the website refresh limit. Use the maintenance import.'), { status: 413 });
            await connection.rollback();
            await connection.close();
            connection = undefined;
            const result = await write(client, events, { deadline, concurrency });
            const { failures, ...summary } = result;
            return { ...summary, status: result.failed ? 'partial' : 'complete',
                partitions: new Set(events.map(event => `${event.patient_id}:${event.event_month}`)).size,
                completed_at: new Date().toISOString() };
        } finally {
            try {
                if (connection) {
                    try { await connection.rollback(); } finally { await connection.close(); }
                }
            } finally { running = false; }
        }
    };
}

module.exports = { createRefreshService, refreshTimeline: createRefreshService() };
