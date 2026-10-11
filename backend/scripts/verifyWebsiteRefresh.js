const path = require('node:path');
const assert = require('node:assert/strict');
require('dotenv').config({ path: path.join(__dirname, '..', '.env'), quiet: true });
const oracle = require('oracledb');
const dbConfig = require('../dbConfig');
const cassandra = require('../cassandraConfig');

async function main() {
    let connection, client, server, sequence;
    let disposableKey = false;
    const patient = 'PAT-01';
    const day = new Date().toISOString().slice(0, 10);
    const month = day.slice(0, 7);
    const date = new Date(`${day}T00:00:00.000Z`);
    const marker = `Temporary DA3 refresh verification ${Date.now()}`;
    try {
        client = await cassandra.getClient();
        connection = await oracle.getConnection({ ...dbConfig, connectTimeout: 10, transportConnectTimeout: 10, retryCount: 0 });
        connection.callTimeout = 15000;
        await connection.execute('SELECT Patient_ID FROM PATIENT WHERE Patient_ID = :patient FOR UPDATE', { patient });
        const next = await connection.execute('SELECT NVL(MAX(Log_Seq_No), 0) + 1 AS NEXT_SEQ FROM MEDICAL_LOG WHERE Patient_ID = :patient', { patient }, { outFormat: oracle.OUT_FORMAT_OBJECT });
        sequence = next.rows[0].NEXT_SEQ;
        const key = `medical_history:${patient}:${sequence}`;
        const select = `SELECT event_id, summary FROM ${cassandra.keyspace()}.clinical_events_by_patient_month WHERE patient_id = ? AND event_month = ? AND event_time = ? AND event_id = ?`;
        const args = [patient, month, date, key];
        assert.equal((await client.execute(select, args, { prepare: true })).rows.length, 0, 'Disposable key must not already exist');
        disposableKey = true;
        await connection.execute("INSERT INTO MEDICAL_LOG (Patient_ID, Log_Seq_No, Log_Date, Diagnosis) VALUES (:patient, :sequence, TO_DATE(:day, 'YYYY-MM-DD'), :marker)", { patient, sequence, day, marker });
        await connection.commit();
        assert.equal((await client.execute(select, args, { prepare: true })).rows.length, 0, 'Oracle insert alone must not update Cassandra');
        const app = require('../server');
        server = app.listen(0, '127.0.0.1');
        await new Promise(resolve => server.once('listening', resolve));
        const base = `http://127.0.0.1:${server.address().port}/api`;
        const refresh = async () => {
            const response = await fetch(base + '/timeline/import', { method: 'POST', signal: AbortSignal.timeout(160000) });
            assert.equal(response.status, 200);
            const result = await response.json();
            assert.equal(result.status, 'complete');
            assert.equal(result.failed, 0);
            assert.equal(result.attempted, result.written);
            return result;
        };
        const first = await refresh();
        assert.equal((await client.execute(select, args, { prepare: true })).rows[0].summary, marker);
        const countQuery = `SELECT COUNT(*) AS total FROM ${cassandra.keyspace()}.clinical_events_by_patient_month WHERE patient_id = ? AND event_month = ?`;
        const before = Number((await client.execute(countQuery, [patient, month], { prepare: true })).rows[0].total);
        const second = await refresh();
        assert.equal(second.written, first.written);
        assert.equal(Number((await client.execute(countQuery, [patient, month], { prepare: true })).rows[0].total), before);
        assert.equal((await (await fetch(base + '/timeline/health')).json()).connected, true);
        assert.equal((await fetch(base + '/patients')).status, 200);
        console.log(`PASS: real HTTP refresh copied ${first.written} source events; new Oracle fixture appeared only after refresh; repeat refresh created no duplicates; Oracle and Cassandra remain available`);
    } finally {
        if (server) { server.closeAllConnections(); await new Promise(resolve => server.close(resolve)); }
        try {
            if (connection && sequence !== undefined) {
                await connection.rollback();
                await connection.execute('DELETE FROM MEDICAL_LOG WHERE Patient_ID = :patient AND Log_Seq_No = :sequence AND Diagnosis = :marker', { patient, sequence, marker });
                await connection.commit();
            }
            if (client && disposableKey) await client.execute(`DELETE FROM ${cassandra.keyspace()}.clinical_events_by_patient_month WHERE patient_id = ? AND event_month = ? AND event_time = ? AND event_id = ?`, [patient, month, date, `medical_history:${patient}:${sequence}`], { prepare: true });
        } finally {
            if (connection) await connection.close();
            await cassandra.shutdown();
        }
        console.log('Verification fixture removed from Oracle and Cassandra. Existing records retained.');
    }
}

main().catch(error => { console.error(`Website refresh verification failed: ${error.name === 'AssertionError' ? error.message : error.code || error.name}`); process.exitCode = 1; });
