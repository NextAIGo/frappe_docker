# ERPNext Fork Repositories Push Script
# This script pushes all three repositories: frappe_docker, frappe, and erpnext

param(
    [switch]$Force,     # Force push all repositories
    [switch]$DryRun,    # Show what would be pushed without actually pushing
    [switch]$Status     # Show status of all repositories
)

Write-Host "🚀 ERPNext Fork Repositories Push Manager" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Green

$repos = @(
    @{
        Name = "frappe_docker"
        Path = "."
        Url = "https://github.com/NextAIGo/frappe_docker.git"
        Branch = "main"
        Description = "Docker development environment"
    },
    @{
        Name = "frappe"
        Path = "./apps/frappe"
        Url = "https://github.com/NextAIGo/frappe.git"
        Branch = "develop-branch"
        Description = "Frappe Framework (Fork)"
    },
    @{
        Name = "erpnext"
        Path = "./apps/erpnext"
        Url = "https://github.com/NextAIGo/erpnext.git"
        Branch = "develop-branch"
        Description = "ERPNext Application (Fork)"
    }
)

function Get-RepoStatus {
    param([hashtable]$repo)
    
    if (-not (Test-Path $repo.Path)) {
        return @{
            Status = "Missing"
            Behind = 0
            Ahead = 0
            Changes = 0
            Untracked = 0
        }
    }
    
    Push-Location $repo.Path
    try {
        # Get status information
        $gitStatus = git status --porcelain 2>$null
        if ($gitStatus) {
            $changedFiles = ($gitStatus | Where-Object { $_ -match "^[MADRC]" }).Count
            $untrackedFiles = ($gitStatus | Where-Object { $_ -match "^\?\?" }).Count
        } else {
            $changedFiles = 0
            $untrackedFiles = 0
        }
        
        # Get ahead/behind information
        $aheadBehind = git rev-list --left-right --count "origin/$($repo.Branch)...$($repo.Branch)" 2>$null
        if ($aheadBehind -and $aheadBehind -match "(\d+)\s+(\d+)") {
            $behindCount = [int]$matches[1]
            $aheadCount = [int]$matches[2]
        } else {
            $behindCount = 0
            $aheadCount = 0
        }
        
        return @{
            Status = if ($changedFiles -gt 0 -or $untrackedFiles -gt 0) { "Changes" } 
                    elseif ($aheadCount -gt 0) { "Ahead" }
                    elseif ($behindCount -gt 0) { "Behind" }
                    else { "Clean" }
            Behind = $behindCount
            Ahead = $aheadCount
            Changes = $changedFiles
            Untracked = $untrackedFiles
        }
    }
    finally {
        Pop-Location
    }
}

function Push-Repository {
    param([hashtable]$repo, [bool]$dryRun = $false, [bool]$force = $false)
    
    Write-Host ""
    Write-Host "📦 Processing: $($repo.Name)" -ForegroundColor Cyan
    Write-Host "   Path: $($repo.Path)" -ForegroundColor Gray
    Write-Host "   URL: $($repo.Url)" -ForegroundColor Gray
    Write-Host "   Branch: $($repo.Branch)" -ForegroundColor Gray
    
    if (-not (Test-Path $repo.Path)) {
        Write-Host "   ❌ Repository path not found!" -ForegroundColor Red
        return $false
    }
    
    Push-Location $repo.Path
    try {
        # Check if we're on the right branch
        $currentBranch = git branch --show-current
        if ($currentBranch -ne $repo.Branch) {
            Write-Host "   ⚠️  Current branch: $currentBranch, expected: $($repo.Branch)" -ForegroundColor Yellow
        }
        
        # Get repository status
        $repoStatus = Get-RepoStatus $repo
        
        Write-Host "   📊 Status: $($repoStatus.Status)" -ForegroundColor $(
            switch ($repoStatus.Status) {
                "Clean" { "Green" }
                "Ahead" { "Yellow" }
                "Changes" { "Red" }
                "Behind" { "Magenta" }
                default { "Gray" }
            }
        )
        
        if ($repoStatus.Changes -gt 0) {
            Write-Host "   📝 Uncommitted changes: $($repoStatus.Changes)" -ForegroundColor Yellow
        }
        
        if ($repoStatus.Untracked -gt 0) {
            Write-Host "   📄 Untracked files: $($repoStatus.Untracked)" -ForegroundColor Yellow
        }
        
        if ($repoStatus.Ahead -gt 0) {
            Write-Host "   ⬆️  Commits ahead: $($repoStatus.Ahead)" -ForegroundColor Green
            
            if ($dryRun) {
                Write-Host "   🔍 DRY RUN: Would push $($repoStatus.Ahead) commits" -ForegroundColor Cyan
            } else {
                Write-Host "   🚀 Pushing changes..." -ForegroundColor Green
                
                if ($force) {
                    git push --force origin $repo.Branch
                } else {
                    git push origin $repo.Branch
                }
                
                if ($LASTEXITCODE -eq 0) {
                    Write-Host "   ✅ Push successful!" -ForegroundColor Green
                } else {
                    Write-Host "   ❌ Push failed!" -ForegroundColor Red
                    return $false
                }
            }
        } else {
            Write-Host "   ✅ Repository is up to date" -ForegroundColor Green
        }
        
        return $true
    }
    finally {
        Pop-Location
    }
}

# Show status if requested
if ($Status) {
    Write-Host ""
    Write-Host "📊 Repository Status Summary:" -ForegroundColor Cyan
    Write-Host "=============================" -ForegroundColor Cyan
    
    foreach ($repo in $repos) {
        $status = Get-RepoStatus $repo
        $statusColor = switch ($status.Status) {
            "Clean" { "Green" }
            "Ahead" { "Yellow" }
            "Changes" { "Red" }
            "Behind" { "Magenta" }
            "Missing" { "Red" }
            default { "Gray" }
        }
        
        Write-Host ""
        Write-Host "📦 $($repo.Name)" -ForegroundColor White
        Write-Host "   Status: $($status.Status)" -ForegroundColor $statusColor
        Write-Host "   Changes: $($status.Changes) | Untracked: $($status.Untracked)" -ForegroundColor Gray
        Write-Host "   Ahead: $($status.Ahead) | Behind: $($status.Behind)" -ForegroundColor Gray
    }
    Write-Host ""
    return
}

# Process each repository
$successCount = 0
$totalCount = $repos.Count

Write-Host ""
Write-Host "🔄 Processing $totalCount repositories..." -ForegroundColor Blue

foreach ($repo in $repos) {
    $success = Push-Repository $repo $DryRun $Force
    if ($success) {
        $successCount++
    }
}

Write-Host ""
Write-Host "📈 Push Summary:" -ForegroundColor Cyan
Write-Host "================" -ForegroundColor Cyan
Write-Host "   Successful: $successCount/$totalCount" -ForegroundColor Green
Write-Host "   Failed: $($totalCount - $successCount)/$totalCount" -ForegroundColor Red

if ($DryRun) {
    Write-Host ""
    Write-Host "🔍 This was a dry run. Use without -DryRun to actually push." -ForegroundColor Yellow
}

if ($successCount -eq $totalCount) {
    Write-Host ""
    Write-Host "🎉 All repositories pushed successfully!" -ForegroundColor Green
} else {
    Write-Host ""
    Write-Host "⚠️  Some repositories failed to push. Check the output above." -ForegroundColor Yellow
}
