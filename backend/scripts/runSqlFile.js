const fs = require('node:fs');
const path = require('node:path');
const oracledb = require('oracledb');

require('dotenv').config({ path: path.join(__dirname, '..', '.env') });

function parseStatements(source) {
    const statements = [];
    let buffer = [];
    let isPlSql = false;

    for (const line of source.split(/\r?\n/)) {
        const trimmed = line.trim();

        if (buffer.length === 0 && (
            trimmed === ''
            || trimmed.startsWith('--')
            || /^SET\s+/i.test(trimmed)
        )) {
            continue;
        }

        if (buffer.length === 0) {
            isPlSql = /^(BEGIN|DECLARE)\b/i.test(trimmed)
                || /^CREATE(\s+OR\s+REPLACE)?\s+(FUNCTION|PROCEDURE|TRIGGER|PACKAGE)\b/i.test(trimmed);
        }

        if (isPlSql && trimmed === '/') {
            statements.push(buffer.join('\n'));
            buffer = [];
            isPlSql = false;
            continue;
        }

        buffer.push(line);

        if (!isPlSql && /;\s*$/.test(trimmed)) {
            statements.push(buffer.join('\n').replace(/;\s*$/, ''));
            buffer = [];
        }
    }

    if (buffer.some((line) => line.trim() !== '')) {
        throw new Error('The SQL file ended with an incomplete statement.');
    }

    return statements;
}

async function main() {
    const requestedPath = process.argv[2];

    if (!requestedPath) {
        throw new Error('Usage: node scripts/runSqlFile.js <path-to-sql-file>');
    }

    const missing = ['ORACLE_USER', 'ORACLE_PASSWORD', 'ORACLE_CONNECT_STRING']
        .filter((name) => !process.env[name]);

    if (missing.length > 0) {
        throw new Error(`Missing database configuration: ${missing.join(', ')}`);
    }

    const sqlPath = path.resolve(process.cwd(), requestedPath);
    const statements = parseStatements(fs.readFileSync(sqlPath, 'utf8'));
    let connection;

    try {
        connection = await oracledb.getConnection({
            user: process.env.ORACLE_USER,
            password: process.env.ORACLE_PASSWORD,
            connectString: process.env.ORACLE_CONNECT_STRING
        });

        for (const [index, sql] of statements.entries()) {
            const result = await connection.execute(sql, [], {
                autoCommit: false,
                outFormat: oracledb.OUT_FORMAT_OBJECT
            });

            console.log(`Statement ${index + 1}/${statements.length}: OK`);
            if (result.rows) {
                console.table(result.rows);
            }
        }

        await connection.commit();
        console.log(`Completed ${path.basename(sqlPath)} successfully.`);
    } catch (error) {
        if (connection) {
            await connection.rollback();
        }
        throw error;
    } finally {
        if (connection) {
            await connection.close();
        }
    }
}

main().catch((error) => {
    console.error(error.message);
    process.exitCode = 1;
});
