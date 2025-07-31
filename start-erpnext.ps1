# ERPNext Development Environment Startup Script
# This script starts the complete ERPNext development environment

param(
    [switch]$Fresh,   # Force rebuild containers
    [switch]$Logs     # Show logs after startup
)

Write-Host "🚀 Starting ERPNext Development Environment..." -ForegroundColor Green
Write-Host "Version: ERPNext v15.72.1 with Frappe v15.74.0" -ForegroundColor Cyan

# Change to script directory
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
Set-Location $ScriptDir

# Check if .env file exists
if (-not (Test-Path ".env")) {
    Write-Host "❌ .env file not found! Please run the setup first." -ForegroundColor Red
    exit 1
}

# Check if apps directory exists
if (-not (Test-Path "./apps")) {
    Write-Host "⚠️  Apps directory not found. Creating..." -ForegroundColor Yellow
    New-Item -ItemType Directory -Path "./apps" -Force
}

# Stop existing containers if Fresh flag is used
if ($Fresh) {
    Write-Host "🔄 Fresh start requested. Stopping existing containers..." -ForegroundColor Yellow
    docker-compose down
}

# Start the services
Write-Host "📦 Starting Docker services..." -ForegroundColor Blue
try {
    docker-compose -f compose.yaml -f docker-compose.dev.yaml up -d
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ Services started successfully!" -ForegroundColor Green
        
        # Wait a moment for services to initialize
        Write-Host "⏳ Waiting for services to initialize..." -ForegroundColor Yellow
        Start-Sleep -Seconds 10
        
        # Check service status
        Write-Host "📊 Service Status:" -ForegroundColor Cyan
        docker-compose ps
        
        Write-Host ""
        Write-Host "🌐 ERPNext is now accessible at:" -ForegroundColor Green
        Write-Host "   http://localhost:8080" -ForegroundColor White
        Write-Host ""
        Write-Host "🔑 Default login credentials:" -ForegroundColor Green
        Write-Host "   Username: Administrator" -ForegroundColor White
        Write-Host "   Password: admin" -ForegroundColor White
        Write-Host ""
        Write-Host "📁 Local development directories:" -ForegroundColor Green
        Write-Host "   Apps: ./apps/" -ForegroundColor White
        Write-Host "   Your forks are mounted for real-time development" -ForegroundColor White
        
        if ($Logs) {
            Write-Host ""
            Write-Host "📋 Showing recent logs..." -ForegroundColor Cyan
            docker-compose logs --tail=20
        }
        
    } else {
        Write-Host "❌ Failed to start services!" -ForegroundColor Red
        exit 1
    }
    
} catch {
    Write-Host "❌ Error starting services: $_" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "🎉 ERPNext Development Environment is ready!" -ForegroundColor Green
Write-Host "💡 Use 'docker-compose logs -f [service-name]' to view real-time logs" -ForegroundColor Yellow
Write-Host "💡 Use 'docker-compose down' to stop all services" -ForegroundColor Yellow
