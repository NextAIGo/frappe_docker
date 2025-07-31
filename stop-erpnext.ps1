# ERPNext Development Environment Stop Script
# This script stops the ERPNext development environment

param(
    [switch]$Clean,   # Remove containers and volumes
    [switch]$Logs     # Show logs before stopping
)

Write-Host "🛑 Stopping ERPNext Development Environment..." -ForegroundColor Yellow

# Change to script directory
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
Set-Location $ScriptDir

if ($Logs) {
    Write-Host "📋 Recent logs before stopping:" -ForegroundColor Cyan
    docker-compose logs --tail=10
    Write-Host ""
}

if ($Clean) {
    Write-Host "🧹 Clean stop requested. Removing containers and volumes..." -ForegroundColor Red
    docker-compose down -v --remove-orphans
    
    Write-Host "🗑️  Removing unused Docker resources..." -ForegroundColor Yellow
    docker system prune -f
    
    Write-Host "✅ Clean stop completed!" -ForegroundColor Green
} else {
    Write-Host "⏹️  Stopping services..." -ForegroundColor Yellow
    docker-compose down
    
    Write-Host "✅ Services stopped!" -ForegroundColor Green
    Write-Host "💡 Data is preserved. Use -Clean flag to remove all data." -ForegroundColor Cyan
}

Write-Host "📊 Remaining containers:" -ForegroundColor Cyan
docker ps -a --filter "name=frappe_docker"
