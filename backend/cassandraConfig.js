const cassandra = require('cassandra-driver');
const fs = require('node:fs');
const os = require('node:os');
const path = require('node:path');

let client;
let connecting;
let bundleDirectory;

function enabled() { return process.env.CASSANDRA_ENABLED === 'true'; }

function keyspace(env = process.env) {
    const value = env.CASSANDRA_KEYSPACE || 'care_continuum';
    if (!/^[a-z][a-z0-9_]{0,47}$/.test(value)) throw new Error('Invalid Cassandra keyspace configuration');
    return value;
}

function buildOptions(env = process.env) {
    const options = {
        keyspace: keyspace(env),
        socketOptions: { connectTimeout: 5000, readTimeout: 8000 },
        queryOptions: { prepare: true, consistency: cassandra.types.consistencies.localQuorum },
    };
    let bundlePath = env.CASSANDRA_SECURE_BUNDLE_PATH;
    if (env.CASSANDRA_SECURE_BUNDLE_B64) {
        const bytes = Buffer.from(env.CASSANDRA_SECURE_BUNDLE_B64, 'base64');
        if (bytes.length < 4 || bytes.subarray(0, 2).toString() !== 'PK') throw new Error('Invalid Cassandra bundle configuration');
        bundleDirectory ||= fs.mkdtempSync(path.join(os.tmpdir(), 'care-continuum-cassandra-'));
        bundlePath = path.join(bundleDirectory, 'secure-connect.zip');
        fs.writeFileSync(bundlePath, bytes, { mode: 0o600 });
    }
    if (bundlePath) {
        if (!env.CASSANDRA_TOKEN) throw new Error('Cassandra cloud token is missing');
        options.cloud = { secureConnectBundle: bundlePath };
        options.authProvider = new cassandra.auth.PlainTextAuthProvider('token', env.CASSANDRA_TOKEN);
    } else {
        if (env.VERCEL || env.DEPLOY_TARGET === 'vercel') throw new Error('Hosted Cassandra configuration is missing');
        options.contactPoints = (env.CASSANDRA_CONTACT_POINTS || '127.0.0.1').split(',').map((value) => value.trim());
        options.localDataCenter = env.CASSANDRA_LOCAL_DC || 'datacenter1';
        const port = Number(env.CASSANDRA_PORT || 9042);
        if (!Number.isInteger(port) || port < 1 || port > 65535) throw new Error('Invalid Cassandra port');
        options.protocolOptions = { port };
    }
    return options;
}

async function getClient() {
    if (!enabled()) throw new Error('Cassandra timeline is disabled');
    if (!client) client = new cassandra.Client(buildOptions());
    if (!connecting) {
        const current = client;
        connecting = current.connect().then(() => current).catch(async () => {
            connecting = undefined;
            client = undefined;
            await current.shutdown().catch(() => {});
            throw new Error('Cassandra connection unavailable');
        });
    }
    return connecting;
}

async function shutdown() {
    const current = client;
    client = undefined;
    connecting = undefined;
    if (current) await current.shutdown();
    if (bundleDirectory) {
        const file = path.join(bundleDirectory, 'secure-connect.zip');
        if (fs.existsSync(file)) fs.unlinkSync(file);
        fs.rmdirSync(bundleDirectory);
        bundleDirectory = undefined;
    }
}

module.exports = { enabled, keyspace, buildOptions, getClient, shutdown };
