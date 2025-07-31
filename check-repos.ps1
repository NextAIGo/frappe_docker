# Simple Repository Status Check
Write-Host "🔍 ERPNext Repositories Status Check" -ForegroundColor Green
Write-Host "====================================" -ForegroundColor Green

# Check frappe_docker
Write-Host ""
Write-Host "📦 1. frappe_docker (Docker Environment)" -ForegroundColor Cyan
Write-Host "   Path: ." -ForegroundColor Gray
$currentStatus = git status --porcelain
if ($currentStatus) {
    Write-Host "   Status: Changes detected" -ForegroundColor Yellow
    git status -s
} else {
    Write-Host "   Status: Clean ✅" -ForegroundColor Green
}

# Check ahead/behind
$aheadBehind = git rev-list --left-right --count origin/main...main 2>$null
if ($aheadBehind) {
    Write-Host "   Sync: $aheadBehind (behind...ahead)" -ForegroundColor Blue
} else {
    Write-Host "   Sync: Up to date ✅" -ForegroundColor Green
}

# Check frappe
Write-Host ""
Write-Host "📦 2. frappe (Framework Fork)" -ForegroundColor Cyan
Write-Host "   Path: ./apps/frappe" -ForegroundColor Gray
if (Test-Path "./apps/frappe") {
    Push-Location "./apps/frappe"
    $frappeStatus = git status --porcelain
    if ($frappeStatus) {
        Write-Host "   Status: Changes detected" -ForegroundColor Yellow
        git status -s
    } else {
        Write-Host "   Status: Clean ✅" -ForegroundColor Green
    }
    
    $frappeAheadBehind = git rev-list --left-right --count origin/develop-branch...develop-branch 2>$null
    if ($frappeAheadBehind -and $frappeAheadBehind -ne "0	0") {
        Write-Host "   Sync: $frappeAheadBehind commits (behind...ahead)" -ForegroundColor Blue
    } else {
        Write-Host "   Sync: Up to date ✅" -ForegroundColor Green
    }
    Pop-Location
} else {
    Write-Host "   Status: Directory not found ❌" -ForegroundColor Red
}

# Check erpnext
Write-Host ""
Write-Host "📦 3. erpnext (Application Fork)" -ForegroundColor Cyan
Write-Host "   Path: ./apps/erpnext" -ForegroundColor Gray
if (Test-Path "./apps/erpnext") {
    Push-Location "./apps/erpnext"
    $erpnextStatus = git status --porcelain
    if ($erpnextStatus) {
        Write-Host "   Status: Changes detected" -ForegroundColor Yellow
        git status -s
    } else {
        Write-Host "   Status: Clean ✅" -ForegroundColor Green
    }
    
    $erpnextAheadBehind = git rev-list --left-right --count origin/develop-branch...develop-branch 2>$null
    if ($erpnextAheadBehind -and $erpnextAheadBehind -ne "0	0") {
        Write-Host "   Sync: $erpnextAheadBehind commits (behind...ahead)" -ForegroundColor Blue
    } else {
        Write-Host "   Sync: Up to date ✅" -ForegroundColor Green
    }
    Pop-Location
} else {
    Write-Host "   Status: Directory not found ❌" -ForegroundColor Red
}

Write-Host ""
Write-Host "🔗 Repository URLs:" -ForegroundColor Yellow
Write-Host "   frappe_docker: https://github.com/NextAIGo/frappe_docker" -ForegroundColor Gray
Write-Host "   frappe:        https://github.com/NextAIGo/frappe" -ForegroundColor Gray
Write-Host "   erpnext:       https://github.com/NextAIGo/erpnext" -ForegroundColor Gray

Write-Host ""
Write-Host "✅ Status check complete!" -ForegroundColor Green
