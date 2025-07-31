# ERPNext v15.71.1 开发环境启动脚本 (Windows PowerShell)

Write-Host "=== ERPNext 开发环境启动 ===" -ForegroundColor Green
Write-Host "版本: ERPNext v15.72.1 + Frappe v15.74.0" -ForegroundColor Cyan
Write-Host "开发模式: 启用" -ForegroundColor Cyan
Write-Host ""

# 检查 Docker 是否运行
try {
    docker info | Out-Null
    Write-Host "✅ Docker 运行正常" -ForegroundColor Green
} catch {
    Write-Host "❌ Docker 未运行，请先启动 Docker" -ForegroundColor Red
    exit 1
}

# 检查应用目录
if (-not (Test-Path "apps\frappe") -or -not (Test-Path "apps\erpnext")) {
    Write-Host "⚠️  检测到应用目录缺失，请先clone代码:" -ForegroundColor Yellow
    Write-Host "cd apps" -ForegroundColor Cyan
    Write-Host "git clone --branch v15.74.0 https://github.com/NextAIGo/frappe.git" -ForegroundColor Cyan
    Write-Host "git clone --branch v15.72.1 https://github.com/NextAIGo/erpnext.git" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "💡 使用你自己的 Fork 仓库，方便二次开发和提交代码" -ForegroundColor Yellow
    Write-Host "   Frappe: v15.74.0 (最新稳定版)" -ForegroundColor Gray
    Write-Host "   ERPNext: v15.72.1 (最新稳定版)" -ForegroundColor Gray
    Write-Host ""
}

# 停止现有容器
Write-Host "🛑 停止现有容器..." -ForegroundColor Yellow
docker-compose down

# 启动开发环境 (包含数据库和Redis)
Write-Host "🚀 启动完整开发环境..." -ForegroundColor Yellow
docker-compose -f compose.yaml -f docker-compose.dev.yaml up -d

# 等待服务启动
Write-Host "⏳ 等待服务启动..." -ForegroundColor Yellow
Start-Sleep -Seconds 30

# 显示状态
Write-Host "📊 服务状态:" -ForegroundColor Cyan
docker-compose ps

Write-Host ""
Write-Host "✅ 开发环境启动完成！" -ForegroundColor Green
Write-Host "🌐 访问地址: http://localhost:8080" -ForegroundColor Cyan
Write-Host "📁 本地应用目录: ./apps" -ForegroundColor Cyan
Write-Host "📄 日志目录: ./logs" -ForegroundColor Cyan
Write-Host "🗄️  数据库: localhost:3306 (root/123)" -ForegroundColor Cyan
Write-Host ""
Write-Host "下一步操作:" -ForegroundColor Yellow
Write-Host "1. 创建开发站点: docker-compose exec backend bench new-site --mariadb-user-host-login-scope='%' --admin-password=admin development.localhost"
Write-Host "2. 安装ERPNext: docker-compose exec backend bench --site development.localhost install-app erpnext"
Write-Host "3. 启用开发者模式: docker-compose exec backend bench --site development.localhost set-config developer_mode 1"
Write-Host "4. 清除缓存: docker-compose exec backend bench --site development.localhost clear-cache"
