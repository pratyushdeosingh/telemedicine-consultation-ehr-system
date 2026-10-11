const path = require('node:path');
require('dotenv').config({ path: path.join(__dirname, '..', '.env'), quiet: true });
const cassandra = require('../cassandraConfig');
const { refreshTimeline } = require('../timelineRefresh');

async function main() {
    try {
        const result = await refreshTimeline({ maxRecords: Infinity, timeoutMs: Infinity });
        console.log(JSON.stringify(result, null, 2));
        if (result.failed) process.exitCode = 1;
    } finally {
        await cassandra.shutdown();
    }
}

if (require.main === module) main().catch(() => {
    console.error('Timeline import failed. Check Oracle/Cassandra configuration and connectivity; no Oracle records were changed.');
    process.exitCode = 1;
});
module.exports = { main };
