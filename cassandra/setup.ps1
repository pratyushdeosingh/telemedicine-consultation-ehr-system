param([switch]$Seed)
$ErrorActionPreference = 'Stop'
$composeFile = Join-Path $PSScriptRoot 'compose.yaml'

function Invoke-Compose {
    param([string[]]$Arguments)
    & docker compose -f $composeFile @Arguments
    if ($LASTEXITCODE -ne 0) { throw "Docker Compose failed: $($Arguments -join ' ')" }
}

Invoke-Compose -Arguments @('up', '-d', '--wait', '--wait-timeout', '240')
Invoke-Compose -Arguments @('cp', (Join-Path $PSScriptRoot 'schema.cql'), 'cassandra:/tmp/da3-schema.cql')
Invoke-Compose -Arguments @('exec', '-T', 'cassandra', 'cqlsh', '-f', '/tmp/da3-schema.cql')
if ($Seed) {
    Invoke-Compose -Arguments @('cp', (Join-Path $PSScriptRoot 'seed.cql'), 'cassandra:/tmp/da3-seed.cql')
    Invoke-Compose -Arguments @('exec', '-T', 'cassandra', 'cqlsh', '-f', '/tmp/da3-seed.cql')
}
Write-Output 'Cassandra schema ready. Oracle data has not been changed.'
