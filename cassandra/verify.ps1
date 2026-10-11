param([switch]$Restart)
$ErrorActionPreference = 'Stop'
$composeFile = Join-Path $PSScriptRoot 'compose.yaml'

function Invoke-Compose {
    param([string[]]$Arguments)
    $result = & docker compose -f $composeFile @Arguments
    if ($LASTEXITCODE -ne 0) { throw "Docker Compose failed: $($Arguments -join ' ')" }
    return $result
}

function Invoke-Cql {
    param([string]$Query)
    return (Invoke-Compose -Arguments @('exec', '-T', 'cassandra', 'cqlsh', '-e', $Query)) -join "`n"
}

function Assert-Count {
    param([string]$Conditions, [int]$Expected)
    $result = Invoke-Cql -Query "SELECT COUNT(*) FROM care_continuum.clinical_events_by_patient_month WHERE $Conditions;"
    $match = [regex]::Match($result, '(?m)^\s*(\d+)\s*$')
    if (-not $match.Success -or [int]$match.Groups[1].Value -ne $Expected) {
        throw "Expected $Expected rows for $Conditions. Actual output: $result"
    }
}

$september = "patient_id = 'DEMO-01' AND event_month = '2026-09'"
$august = "patient_id = 'DEMO-01' AND event_month = '2026-08'"
$secondPatient = "patient_id = 'DEMO-02' AND event_month = '2026-09'"
Assert-Count -Conditions $september -Expected 4
Assert-Count -Conditions $august -Expected 2
Assert-Count -Conditions $secondPatient -Expected 2
Write-Output 'PASS: patient/month partitions return the intended synthetic records'

Assert-Count -Conditions "$september AND event_time = '2026-09-10T00:00:00Z'" -Expected 2
Assert-Count -Conditions "$september AND event_time >= '2026-09-11T00:00:00Z' AND event_time < '2026-09-13T00:00:00Z'" -Expected 2
Write-Output 'PASS: equal-date records remain distinct and date-range queries work'

$latest = Invoke-Cql -Query "SELECT event_id FROM care_continuum.clinical_events_by_patient_month WHERE $september LIMIT 1;"
if ($latest -notmatch 'invoice:1') { throw 'The newest record was not returned first' }
Write-Output 'PASS: clustering order returns newest records first'

# Re-seeding updates the same keys; it must not create duplicate records.
Invoke-Compose -Arguments @('cp', (Join-Path $PSScriptRoot 'seed.cql'), 'cassandra:/tmp/da3-seed.cql') | Out-Null
Invoke-Compose -Arguments @('exec', '-T', 'cassandra', 'cqlsh', '-f', '/tmp/da3-seed.cql') | Out-Null
Assert-Count -Conditions $september -Expected 4
Assert-Count -Conditions $august -Expected 2
Assert-Count -Conditions $secondPatient -Expected 2
Write-Output 'PASS: repeat seed writes do not create duplicates'

$verificationId = 'verify:' + [guid]::NewGuid().ToString('N')
$key = "patient_id = 'DEMO-VERIFY' AND event_month = '2026-09' AND event_time = '2026-09-01T00:00:00Z' AND event_id = '$verificationId'"
try {
    Invoke-Cql -Query "INSERT INTO care_continuum.clinical_events_by_patient_month (patient_id, event_month, event_time, event_id, summary) VALUES ('DEMO-VERIFY', '2026-09', '2026-09-01T00:00:00Z', '$verificationId', 'Initial verification summary');" | Out-Null
    Assert-Count -Conditions $key -Expected 1
    Invoke-Cql -Query "UPDATE care_continuum.clinical_events_by_patient_month SET summary = 'Updated verification summary' WHERE $key;" | Out-Null
    $updated = Invoke-Cql -Query "SELECT summary FROM care_continuum.clinical_events_by_patient_month WHERE $key;"
    if ($updated -notmatch 'Updated verification summary') { throw 'The summary was not updated' }
    Write-Output 'PASS: insert, read and update using the complete primary key'
} finally {
    Invoke-Cql -Query "DELETE FROM care_continuum.clinical_events_by_patient_month WHERE $key;" | Out-Null
}
Assert-Count -Conditions $key -Expected 0
Write-Output 'PASS: the disposable verification record was deleted'

if ($Restart) {
    Invoke-Compose -Arguments @('restart', 'cassandra') | Out-Null
    Invoke-Compose -Arguments @('up', '-d', '--wait', '--wait-timeout', '240') | Out-Null
    Assert-Count -Conditions $september -Expected 4
    Assert-Count -Conditions $august -Expected 2
    Assert-Count -Conditions $secondPatient -Expected 2
    Write-Output 'PASS: seeded records survive a Cassandra restart'
}
Write-Output 'Local Cassandra verification completed. Oracle was not accessed.'
