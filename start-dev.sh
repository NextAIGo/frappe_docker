#!/bin/bash

# ERPNext v15.71.1 开发环境启动脚本

echo "=== ERPNext 开发环境启动 ==="
echo "版本: v15.71.1"
echo "开发模式: 启用"
echo ""

# 检查 Docker 是否运行
if ! docker info > /dev/null 2>&1; then
    echo "❌ Docker 未运行，请先启动 Docker"
    exit 1
fi

# 停止现有容器
echo "🛑 停止现有容器..."
docker-compose down

# 拉取最新镜像
echo "📥 拉取 ERPNext v15.71.1 镜像..."
docker pull frappe/erpnext:v15.71.1

# 启动服务
echo "🚀 启动开发环境..."
docker-compose -f compose.yaml -f docker-compose.dev.yaml up -d

# 等待服务启动
echo "⏳ 等待服务启动..."
sleep 30

# 显示状态
echo "📊 服务状态:"
docker-compose ps

echo ""
echo "✅ 开发环境启动完成！"
echo "🌐 访问地址: http://localhost:8080"
echo "📁 本地应用目录: ./apps"
echo "📄 日志目录: ./logs"
echo ""
echo "下一步操作:"
echo "1. 创建开发站点: docker-compose exec backend bench new-site --mariadb-user-host-login-scope='%' --admin-password=admin development.localhost"
echo "2. 启用开发者模式: docker-compose exec backend bench --site development.localhost set-config developer_mode 1"
echo "3. 清除缓存: docker-compose exec backend bench --site development.localhost clear-cache"
