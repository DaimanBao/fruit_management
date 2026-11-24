param(
    [switch]$ServicesOnly
)

$services = @(
    "promotion",
    "payment",
    "order",
    "product",
    "user",
    "auth"
)

if (-not $ServicesOnly) {
    $services = @("gateway") + $services
}

Write-Host "========== STOP BACKEND ==========" -ForegroundColor Cyan

foreach ($service in $services) {
    & "$PSScriptRoot\stop.ps1" -Service $service
}

Write-Host "========== STOP COMPLETED ==========" -ForegroundColor Cyan