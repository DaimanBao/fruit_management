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

$backendPath = Split-Path -Parent $PSScriptRoot
$pidPath = Join-Path $PSScriptRoot ".pids"

New-Item -ItemType Directory -Path $pidPath -Force | Out-Null

$pidFile = Join-Path $pidPath "$Service.pid"

# Check if service is already running
if (Test-Path $pidFile) {
    $saved = Get-Content $pidFile | ConvertFrom-Json

    $existingProcess = Get-Process `
        -Id $saved.Id `
        -ErrorAction SilentlyContinue

    if ($existingProcess -and
        $existingProcess.StartTime.ToFileTimeUtc().ToString() -eq $saved.StartTime) {
        Write-Host "$Service is already running." -ForegroundColor Yellow
        return
    }

    Remove-Item $pidFile -Force
}

# Resolve service directory
if ($Service -eq "gateway") {
    $servicePath = Join-Path $backendPath "api-gateway"
}
else {
    $servicePath = Join-Path $backendPath "services\$Service-service"
}

if (-not (Test-Path "$servicePath\package.json")) {
    Write-Host "Service directory not found: $servicePath" -ForegroundColor Red
    return
}

# Start service in a separate terminal
$process = Start-Process `
    -FilePath "cmd.exe" `
    -ArgumentList "/c", "npm run dev" `
    -WorkingDirectory $servicePath `
    -PassThru

# Save process information
@{
    Id        = $process.Id
    StartTime = $process.StartTime.ToFileTimeUtc().ToString()
} | ConvertTo-Json | Set-Content $pidFile

Write-Host "$Service launched (PID: $($process.Id))" -ForegroundColor Green