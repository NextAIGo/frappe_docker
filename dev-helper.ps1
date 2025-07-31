# ERPNext Development Helper Script
# This script provides various development utilities

param(
    [string]$Action,
    [string]$Service = "backend",
    [string]$Command = ""
)

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
Set-Location $ScriptDir

function Show-Help {
    Write-Host "ERPNext Development Helper" -ForegroundColor Green
    Write-Host "=========================" -ForegroundColor Green
    Write-Host ""
    Write-Host "Usage: .\dev-helper.ps1 -Action <action> [options]" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Available Actions:" -ForegroundColor Yellow
    Write-Host "  logs       - Show logs for a service" -ForegroundColor White
    Write-Host "  shell      - Enter shell in a container" -ForegroundColor White
    Write-Host "  bench      - Run bench commands" -ForegroundColor White
    Write-Host "  status     - Show service status" -ForegroundColor White
    Write-Host "  restart    - Restart a service" -ForegroundColor White
    Write-Host "  rebuild    - Rebuild and restart services" -ForegroundColor White
    Write-Host ""
    Write-Host "Examples:" -ForegroundColor Yellow
    Write-Host "  .\dev-helper.ps1 -Action logs -Service frontend" -ForegroundColor Gray
    Write-Host "  .\dev-helper.ps1 -Action shell -Service backend" -ForegroundColor Gray
    Write-Host "  .\dev-helper.ps1 -Action bench -Command 'migrate'" -ForegroundColor Gray
    Write-Host "  .\dev-helper.ps1 -Action status" -ForegroundColor Gray
}

switch ($Action.ToLower()) {
    "logs" {
        Write-Host "📋 Showing logs for $Service..." -ForegroundColor Cyan
        docker-compose logs -f $Service
    }
    
    "shell" {
        Write-Host "🐚 Entering shell in $Service container..." -ForegroundColor Cyan
        docker-compose exec $Service /bin/bash
    }
    
    "bench" {
        if ([string]::IsNullOrEmpty($Command)) {
            Write-Host "❌ Please provide a bench command with -Command parameter" -ForegroundColor Red
            exit 1
        }
        Write-Host "⚡ Running bench command: $Command" -ForegroundColor Cyan
        docker-compose exec backend bench $Command
    }
    
    "status" {
        Write-Host "📊 Service Status:" -ForegroundColor Cyan
        docker-compose ps
        Write-Host ""
        Write-Host "🖥️  System Resources:" -ForegroundColor Cyan
        docker stats --no-stream --format "table {{.Container}}\t{{.CPUPerc}}\t{{.MemUsage}}\t{{.NetIO}}"
    }
    
    "restart" {
        Write-Host "🔄 Restarting $Service..." -ForegroundColor Yellow
        docker-compose restart $Service
        Write-Host "✅ $Service restarted!" -ForegroundColor Green
    }
    
    "rebuild" {
        Write-Host "🔨 Rebuilding and restarting services..." -ForegroundColor Yellow
        docker-compose down
        docker-compose -f compose.yaml -f docker-compose.dev.yaml up -d --build
        Write-Host "✅ Services rebuilt and restarted!" -ForegroundColor Green
    }
    
    default {
        if ([string]::IsNullOrEmpty($Action)) {
            Show-Help
        } else {
            Write-Host "❌ Unknown action: $Action" -ForegroundColor Red
            Show-Help
        }
    }
}
