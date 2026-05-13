$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $PSScriptRoot

$patterns = @(
  "C:\\Users\\",
  "/Users/[^/\s]+",
  "127\.0\.0\.1:(3000|5000|8000|8080|9000)",
  "localhost:(3000|5000|8000|8080|9000)",
  "client_secret\s*[:=]",
  "client_id\s*[:=]",
  "PRIVATE KEY",
  "BEGIN RSA",
  "BEGIN OPENSSH",
  "password\s*[:=]",
  "passwd\s*[:=]",
  "secret\s*[:=]",
  "token\s*[:=]",
  "api[_-]?key\s*[:=]",
  "[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}"
)

$localDenylist = Join-Path $root ".publication-denylist.local.txt"
if (Test-Path $localDenylist) {
  $patterns += Get-Content $localDenylist |
    Where-Object { $_ -and -not $_.TrimStart().StartsWith("#") }
}

$combined = $patterns -join "|"
$matches = & rg --hidden --glob "!.git/**" --glob "!scripts/scan-publication.ps1" -n -i $combined $root
$exit = $LASTEXITCODE

if ($exit -eq 0) {
  Write-Host "Potential publication leaks found:" -ForegroundColor Red
  $matches
  exit 1
}

if ($exit -eq 1) {
  Write-Host "Publication leak scan passed." -ForegroundColor Green
  exit 0
}

Write-Host "Leak scan failed to run. Is ripgrep installed?" -ForegroundColor Yellow
exit $exit
