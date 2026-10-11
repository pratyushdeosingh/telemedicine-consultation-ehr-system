const path = require('node:path');
const fs = require('node:fs');
require('dotenv').config({ path: path.join(__dirname, '..', '.env'), quiet: true });
const config = require('../cassandraConfig');

async function main() {
    try {
        const client = await config.getClient();
        const query = fs.readFileSync(path.join(__dirname, '../../cassandra/table.cql'), 'utf8')
            .replace(/^--.*$/gm, '').trim().replace(/;$/, '')
            .replace('care_continuum.', `${config.keyspace()}.`);
        await client.execute(query);
        console.log('Timeline table ready in the configured Cassandra keyspace. No existing rows were removed.');
    } finally { await config.shutdown(); }
}
main().catch(() => { console.error('Timeline schema setup failed. Check the existing keyspace, credentials, permissions, and connection.'); process.exitCode = 1; });
