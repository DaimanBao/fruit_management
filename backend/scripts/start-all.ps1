param(
    [switch]$ServicesOnly
)

$services = @(
    "auth",
    "user",
    "product",
    "order",
    "payment",
    "promotion"
)

if (-not $ServicesOnly) {
    $services += "gateway"
}

Write-Host "========== START BACKEND ==========" -ForegroundColor Cyan

foreach ($service in $services) {
    & "$PSScriptRoot\start.ps1" -Service $service
}

Write-Host "========== START COMPLETED ==========" -ForegroundColor Cyan