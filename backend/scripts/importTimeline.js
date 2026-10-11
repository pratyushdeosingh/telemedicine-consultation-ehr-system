const path = require('node:path');
require('dotenv').config({ path: path.join(__dirname, '..', '.env'), quiet: true });
const oracle = require('oracledb');
const dbConfig = require('../dbConfig');
const cassandra = require('../cassandraConfig');
const { readSource, mapSourceRecords, importEvents } = require('../timelineImport');

async function main() {
    let connection;
    try {
        const client = await cassandra.getClient();
        connection = await oracle.getConnection({ ...dbConfig, connectTimeout: 10, transportConnectTimeout: 10, retryCount: 0 });
        connection.callTimeout = 15000;
        const events = mapSourceRecords(await readSource(connection));
        const result = await importEvents(client, events);
        console.log(JSON.stringify({ ...result, partitions: new Set(events.map((event) => `${event.patient_id}:${event.event_month}`)).size }, null, 2));
        if (result.failed) process.exitCode = 1;
    } finally {
        if (connection) { await connection.rollback(); await connection.close(); }
        await cassandra.shutdown();
    }
}

if (require.main === module) main().catch(() => {
    console.error('Timeline import failed. Check Oracle/Cassandra configuration and connectivity; no Oracle records were changed.');
    process.exitCode = 1;
});
module.exports = { main };
