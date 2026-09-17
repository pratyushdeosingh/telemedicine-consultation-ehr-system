const fs = require('node:fs');
const path = require('node:path');
const oracledb = require('oracledb');

require('dotenv').config({ path: path.join(__dirname, '..', '.env') });
const dbConfig = require('../dbConfig');

const schemaPath = path.join(__dirname, '..', '..', 'database', 'telemedicine_ehr.sql');
const ignoredCleanupErrors = new Set([942, 2289]);

function parseStatements(source) {
    const statements = [];
    let buffer = [];
    let isPlSql = false;

    for (const line of source.split(/\r?\n/)) {
        const trimmed = line.trim();

        if (buffer.length === 0 && (trimmed === '' || trimmed.startsWith('--'))) {
            continue;
        }

        if (buffer.length === 0) {
            isPlSql = /^(BEGIN|DECLARE)\b/i.test(trimmed)
                || /^CREATE(\s+OR\s+REPLACE)?\s+(FUNCTION|PROCEDURE|TRIGGER|PACKAGE)\b/i.test(trimmed);
        }

        if (isPlSql && trimmed === '/') {
            statements.push({ sql: buffer.join('\n'), isCleanup: false });
            buffer = [];
            isPlSql = false;
            continue;
        }

        buffer.push(line);

        if (!isPlSql && /;\s*$/.test(trimmed)) {
            const sql = buffer.join('\n').replace(/;\s*$/, '');
            statements.push({
                sql,
                isCleanup: /^DROP\s+(TABLE|SEQUENCE)\b/i.test(sql.trim())
            });
            buffer = [];
        }
    }

    if (buffer.some((line) => line.trim() !== '')) {
        throw new Error('The schema file ended with an incomplete SQL statement.');
    }

    return statements;
}

async function main() {
    const missing = ['ORACLE_USER', 'ORACLE_PASSWORD', 'ORACLE_CONNECT_STRING']
        .filter((name) => !process.env[name]);

    if (missing.length > 0) {
        throw new Error(`Missing database configuration: ${missing.join(', ')}`);
    }

    const statements = parseStatements(fs.readFileSync(schemaPath, 'utf8'));
    let connection;
    let executed = 0;
    let skippedCleanup = 0;

    try {
        connection = await oracledb.getConnection(dbConfig);

        for (const statement of statements) {
            try {
                await connection.execute(statement.sql, [], { autoCommit: true });
                executed += 1;
            } catch (error) {
                if (statement.isCleanup && ignoredCleanupErrors.has(error.errorNum)) {
                    skippedCleanup += 1;
                    continue;
                }

                throw new Error(`Database setup failed near:\n${statement.sql.slice(0, 180)}`, {
                    cause: error
                });
            }
        }

        const result = await connection.execute(`
            SELECT 'PATIENT' AS table_name, COUNT(*) AS total FROM PATIENT
            UNION ALL SELECT 'APPOINTMENT', COUNT(*) FROM APPOINTMENT
            UNION ALL SELECT 'PRESCRIPTION', COUNT(*) FROM PRESCRIPTION
            UNION ALL SELECT 'BILLING_INVOICE', COUNT(*) FROM BILLING_INVOICE
            ORDER BY table_name
        `);

        console.log(`Database setup complete: ${executed} statements executed, ${skippedCleanup} absent cleanup targets skipped.`);
        result.rows.forEach(([tableName, total]) => console.log(`${tableName}: ${total}`));
    } finally {
        if (connection) {
            await connection.close();
        }
    }
}

main().catch((error) => {
    console.error(error.cause?.message || error.message);
    process.exitCode = 1;
});
