param(
    [Parameter(Mandatory = $true)]
    [ValidateSet(
        "gateway",
        "auth",
        "user",
        "product",
        "order",
        "payment",
        "promotion"
    )]
    [string]$Service
)

$pidPath = Join-Path $PSScriptRoot ".pids"
$pidFile = Join-Path $pidPath "$Service.pid"

if (-not (Test-Path $pidFile)) {
    Write-Host "$Service is not managed by this script." -ForegroundColor Yellow
    return
}

$saved = Get-Content $pidFile | ConvertFrom-Json

$process = Get-Process `
    -Id $saved.Id `
    -ErrorAction SilentlyContinue

# Verify process identity
if (-not $process -or
    $process.StartTime.ToFileTimeUtc().ToString() -ne $saved.StartTime) {

    Remove-Item $pidFile -Force

    Write-Host "$Service process is no longer running." -ForegroundColor Yellow
    return
}

# Stop process and all child processes
taskkill.exe /PID $saved.Id /T /F | Out-Null

if ($LASTEXITCODE -eq 0) {
    Remove-Item $pidFile -Force

    Write-Host "$Service stopped." -ForegroundColor Green
}
else {
    Write-Host "Failed to stop $Service." -ForegroundColor Red
}