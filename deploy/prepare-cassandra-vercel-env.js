const fs = require('node:fs');
const path = require('node:path');
const dotenv = require('dotenv');
const root = path.join(__dirname, '..');
const source = dotenv.parse(fs.readFileSync(path.join(root, 'backend/.env')));
const required = ['CASSANDRA_TOKEN', 'CASSANDRA_SECURE_BUNDLE_B64'];
if (required.some((name) => !source[name])) throw new Error('Run setup-cassandra-cloud.ps1 first. No cloud credentials were found.');
const output = path.join(root, '.env.cassandra-vercel-import');
const values = { CASSANDRA_ENABLED: 'true', CASSANDRA_KEYSPACE: source.CASSANDRA_KEYSPACE || 'care_continuum',
    CASSANDRA_TOKEN: source.CASSANDRA_TOKEN, CASSANDRA_SECURE_BUNDLE_B64: source.CASSANDRA_SECURE_BUNDLE_B64 };
for (const value of Object.values(values)) if (/[\r\n]/.test(value)) throw new Error('Invalid configuration format');
fs.writeFileSync(output, Object.entries(values).map(([key, value]) => `${key}=${value}`).join('\n') + '\n', { flag: 'wx', mode: 0o600 });
console.log('Created ignored .env.cassandra-vercel-import. Import its four keys into Vercel Production without changing existing Oracle/auth settings, then delete the file.');
