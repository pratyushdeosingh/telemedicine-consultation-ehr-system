param([Parameter(Mandatory)][string]$SecureBundleZip)
$ErrorActionPreference = 'Stop'
$bundleFile = (Resolve-Path -LiteralPath $SecureBundleZip).Path
$bundleBytes = [IO.File]::ReadAllBytes($bundleFile)
if ($bundleBytes.Length -lt 4 -or $bundleBytes[0] -ne 80 -or $bundleBytes[1] -ne 75) { throw 'Select the downloaded Secure Connect Bundle ZIP.' }
$envFile = Join-Path (Split-Path $PSScriptRoot -Parent) 'backend/.env'
if (-not (Test-Path -LiteralPath $envFile)) { throw 'Configure backend/.env for Oracle first.' }
$privateToken = Read-Host 'Paste the Astra application token (hidden input)' -AsSecureString
$tokenHandle = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($privateToken)
try {
    $tokenValue = [Runtime.InteropServices.Marshal]::PtrToStringBSTR($tokenHandle)
    if (-not $tokenValue -or $tokenValue -notmatch '^[A-Za-z0-9_:+/=.\-]+$') { throw 'Invalid token format.' }
    $settings = @{
        CASSANDRA_ENABLED = 'true'
        CASSANDRA_KEYSPACE = 'care_continuum'
        CASSANDRA_TOKEN = $tokenValue
        CASSANDRA_SECURE_BUNDLE_B64 = [Convert]::ToBase64String($bundleBytes)
    }
    $content = [IO.File]::ReadAllText($envFile)
    foreach ($setting in $settings.GetEnumerator()) {
        $pattern = '(?m)^' + [regex]::Escape($setting.Key) + '=.*\r?$'
        $line = $setting.Key + '=' + $setting.Value
        if ([regex]::IsMatch($content, $pattern)) {
            $content = [regex]::Replace($content, $pattern, [System.Text.RegularExpressions.MatchEvaluator]{ param($match) $line })
        } else { $content = $content.TrimEnd() + "`n" + $line + "`n" }
    }
    [IO.File]::WriteAllText($envFile, $content)
    Write-Output 'Cloud Cassandra configuration saved privately to backend/.env. Restart the backend; no token values were printed.'
} finally {
    [Runtime.InteropServices.Marshal]::ZeroFreeBSTR($tokenHandle)
    $tokenValue = $null
    $privateToken.Dispose()
}
