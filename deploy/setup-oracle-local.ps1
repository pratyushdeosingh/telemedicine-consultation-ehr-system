param(
    [string]$WalletZip = (Join-Path $env:USERPROFILE 'Downloads\Wallet_TELEMEHR.zip')
)

$ErrorActionPreference = 'Stop'

if (-not (Test-Path -LiteralPath $WalletZip -PathType Leaf)) {
    throw "Wallet ZIP not found: $WalletZip"
}

Add-Type -AssemblyName System.IO.Compression
Add-Type -AssemblyName System.IO.Compression.FileSystem

$archive = [IO.Compression.ZipFile]::OpenRead($WalletZip)
try {
    $pemEntry = $archive.GetEntry('ewallet.pem')
    $tnsEntry = $archive.GetEntry('tnsnames.ora')
    if (-not $pemEntry -or -not $tnsEntry) {
        throw 'The ZIP is not an Oracle Autonomous Database instance wallet.'
    }

    $pemStream = $pemEntry.Open()
    try {
        $memory = [IO.MemoryStream]::new()
        try {
            $pemStream.CopyTo($memory)
            $walletBase64 = [Convert]::ToBase64String($memory.ToArray())
        } finally { $memory.Dispose() }
    } finally { $pemStream.Dispose() }

    $tnsReader = [IO.StreamReader]::new($tnsEntry.Open())
    try { $tnsText = $tnsReader.ReadToEnd() }
    finally { $tnsReader.Dispose() }
} finally { $archive.Dispose() }

$lowEntry = [regex]::Match($tnsText, '(?im)^\s*[A-Za-z0-9_]+_low\s*=\s*(\(description=.*\))\s*$')
if (-not $lowEntry.Success) {
    throw 'No low-priority connection descriptor was found in tnsnames.ora.'
}
$connectString = $lowEntry.Groups[1].Value.Trim()

function Read-SecretText([string]$Prompt) {
    $secure = Read-Host -Prompt $Prompt -AsSecureString
    $ptr = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($secure)
    try { return [Runtime.InteropServices.Marshal]::PtrToStringBSTR($ptr) }
    finally { [Runtime.InteropServices.Marshal]::ZeroFreeBSTR($ptr) }
}

$appPassword = Read-SecretText 'Password for TELEMEDICINE_APP (input hidden)'
$walletPassword = Read-SecretText 'Wallet download password (input hidden)'
if (-not $appPassword -or -not $walletPassword) {
    throw 'Both passwords are required.'
}
if ($appPassword -match "['`r`n]" -or $walletPassword -match "['`r`n]") {
    throw "Passwords containing an apostrophe or newline cannot be stored by this helper. Do not alter the passwords; use a different local setup method."
}

$repoRoot = Split-Path -Parent $PSScriptRoot
$envFile = Join-Path $repoRoot 'backend\.env'
if (Test-Path -LiteralPath $envFile) {
    $backup = "$envFile.before-oracle-$(Get-Date -Format yyyyMMdd-HHmmss)"
    Copy-Item -LiteralPath $envFile -Destination $backup -ErrorAction Stop
    Write-Host 'Backed up the existing backend/.env to an ignored local file.'
}

$lines = @(
    'ORACLE_USER=TELEMEDICINE_APP'
    "ORACLE_PASSWORD='$appPassword'"
    "ORACLE_CONNECT_STRING='$connectString'"
    "ORACLE_WALLET_B64='$walletBase64'"
    "ORACLE_WALLET_PASSWORD='$walletPassword'"
    'PORT=3000'
    'HOST=127.0.0.1'
    'CORS_ORIGIN=http://localhost:5173'
)
[IO.File]::WriteAllLines($envFile, $lines, [Text.UTF8Encoding]::new($false))
Write-Host 'Created ignored backend/.env for the Oracle app user and instance wallet.'
Write-Host 'Do not share this file or commit it. Next, run npm run db:setup from backend only on this fresh schema.'
