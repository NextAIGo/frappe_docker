# ERPNext Development Environment Repository Status Checker
Write-Host "=== ERPNext Repositories Status Check ===" -ForegroundColor Cyan

# Check frappe_docker repository
Write-Host "1. frappe_docker (Docker Environment)" -ForegroundColor Yellow
$status = git status --porcelain 2>$null
if ($status) {
    Write-Host "   Status: Changes detected" -ForegroundColor Yellow
    $status | ForEach-Object { Write-Host "   $_" -ForegroundColor Gray }
} else {
    Write-Host "   Status: Clean" -ForegroundColor Green
}

# Check frappe repository
Write-Host "`n2. frappe (Framework Fork)" -ForegroundColor Yellow
if (Test-Path "./apps/frappe") {
    Push-Location "./apps/frappe"
    
    $status = git status --porcelain 2>$null
    if ($status) {
        Write-Host "   Status: Changes detected" -ForegroundColor Yellow
        $status | ForEach-Object { Write-Host "   $_" -ForegroundColor Gray }
    } else {
        Write-Host "   Status: Clean" -ForegroundColor Green
    }
    
    $currentBranch = git branch --show-current 2>$null
    Write-Host "   Branch: $currentBranch" -ForegroundColor Blue
    
    Pop-Location
} else {
    Write-Host "   Status: Directory not found" -ForegroundColor Red
}

# Check erpnext repository
Write-Host "`n3. erpnext (Application Fork)" -ForegroundColor Yellow
if (Test-Path "./apps/erpnext") {
    Push-Location "./apps/erpnext"
    
    $status = git status --porcelain 2>$null
    if ($status) {
        Write-Host "   Status: Changes detected" -ForegroundColor Yellow
        $status | ForEach-Object { Write-Host "   $_" -ForegroundColor Gray }
    } else {
        Write-Host "   Status: Clean" -ForegroundColor Green
    }
    
    $currentBranch = git branch --show-current 2>$null
    Write-Host "   Branch: $currentBranch" -ForegroundColor Blue
    
    Pop-Location
} else {
    Write-Host "   Status: Directory not found" -ForegroundColor Red
}

Write-Host "`nRepository URLs:" -ForegroundColor Cyan
Write-Host "  frappe_docker: https://github.com/NextAIGo/frappe_docker" -ForegroundColor Gray
Write-Host "  frappe:        https://github.com/NextAIGo/frappe" -ForegroundColor Gray
Write-Host "  erpnext:       https://github.com/NextAIGo/erpnext" -ForegroundColor Gray

Write-Host "`nStatus check complete!" -ForegroundColor Green
