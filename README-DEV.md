# ERPNext Development Environment

This is a complete Docker-based development environment for ERPNext v15.72.1 with Frappe v15.74.0, configured for secondary development with local code mounting.

## 🚀 Quick Start

1. **Start the development environment:**
   ```powershell
   .\start-erpnext.ps1
   ```

2. **Access ERPNext:**
   - URL: http://localhost:8080
   - Username: `Administrator`
   - Password: `admin`

3. **Stop the environment:**
   ```powershell
   .\stop-erpnext.ps1
   ```

## 📁 Project Structure

```
frappe_docker/
├── .env                      # Environment configuration
├── apps.json                 # App repositories configuration
├── compose.yaml              # Main Docker Compose file
├── docker-compose.dev.yaml   # Development overrides
├── start-erpnext.ps1         # Startup script
├── stop-erpnext.ps1          # Stop script
├── dev-helper.ps1            # Development utilities
├── apps/                     # Local app development (mounted)
│   ├── frappe/              # Your Frappe fork
│   └── erpnext/             # Your ERPNext fork
└── README-DEV.md            # This file
```

## 🔧 Configuration

### Environment Variables (.env)
- `ERPNEXT_VERSION=v15.72.1` - ERPNext version
- `FRAPPE_VERSION=v15.74.0` - Frappe Framework version
- `DB_PASSWORD=123` - Database password
- `HTTP_PUBLISH_PORT=8080` - Web interface port

### Repository Configuration (apps.json)
- Points to your personal forks: `NextAIGo/frappe` and `NextAIGo/erpnext`
- Configured for specific version branches

## 🛠️ Development Workflow

### 1. Code Development
- Your local `./apps/` directory is mounted into containers
- Changes to code are reflected immediately
- Both Frappe and ERPNext are available for modification

### 2. Using Development Helper
```powershell
# View logs
.\dev-helper.ps1 -Action logs -Service backend

# Enter container shell
.\dev-helper.ps1 -Action shell -Service backend

# Run bench commands
.\dev-helper.ps1 -Action bench -Command "migrate"
.\dev-helper.ps1 -Action bench -Command "clear-cache"

# Check service status
.\dev-helper.ps1 -Action status

# Restart a service
.\dev-helper.ps1 -Action restart -Service frontend
```

### 3. Common Bench Commands
```bash
# Inside backend container
bench migrate                    # Apply database migrations
bench clear-cache               # Clear all caches
bench build                     # Build assets
bench restart                   # Restart services
bench new-app my_custom_app     # Create new app
bench install-app my_custom_app # Install app to site
```

## 🐳 Docker Services

| Service | Description | Port | Status |
|---------|-------------|------|--------|
| frontend | Nginx reverse proxy | 8080 | ✅ |
| backend | Frappe/ERPNext application | 8000 | ✅ |
| websocket | Real-time communication | 9000 | ✅ |
| scheduler | Background job scheduler | - | ✅ |
| queue-short | Short-running background jobs | - | ✅ |
| queue-long | Long-running background jobs | - | ✅ |
| db | MariaDB database | 3306 | ✅ |
| redis-cache | Redis for caching | 6379 | ✅ |
| redis-queue | Redis for job queue | 6379 | ✅ |

## 📊 Monitoring

### View Service Logs
```powershell
# All services
docker-compose logs -f

# Specific service
docker-compose logs -f frontend
docker-compose logs -f backend
```

### Check Service Health
```powershell
# Service status
docker-compose ps

# Resource usage
docker stats
```

## 🔄 Advanced Operations

### Fresh Start
```powershell
# Complete rebuild
.\start-erpnext.ps1 -Fresh

# With logs
.\start-erpnext.ps1 -Fresh -Logs
```

### Clean Stop
```powershell
# Stop and remove all data
.\stop-erpnext.ps1 -Clean
```

### Database Access
```powershell
# Connect to database
docker-compose exec db mysql -u root -p123

# Backup database
docker-compose exec db mysqldump -u root -p123 development > backup.sql

# Restore database
docker-compose exec -T db mysql -u root -p123 development < backup.sql
```

## 🚨 Troubleshooting

### Port Already in Use
```powershell
# Check what's using port 8080
netstat -ano | findstr :8080

# Kill process if needed
taskkill /PID <process_id> /F
```

### Container Issues
```powershell
# Restart all services
docker-compose restart

# Rebuild containers
.\dev-helper.ps1 -Action rebuild

# Clean restart
docker-compose down -v
.\start-erpnext.ps1 -Fresh
```

### Permission Issues (if using WSL)
```bash
# Fix permissions in WSL
sudo chown -R $USER:$USER ./apps/
```

## 📝 Development Notes

### File Watching
- Code changes in `./apps/` are automatically detected
- Frontend assets may need manual rebuild: `bench build`
- Backend changes usually require service restart

### Database Schema Changes
- Always run `bench migrate` after schema changes
- Test migrations on development site first

### Custom Apps
1. Create app: `bench new-app my_app`
2. Install app: `bench install-app my_app`
3. Add to apps.json for production deployment

## 🔗 Useful Links

- [ERPNext Documentation](https://docs.erpnext.com/)
- [Frappe Framework Documentation](https://frappeframework.com/docs)
- [Docker Documentation](https://docs.docker.com/)

## 📞 Support

For development environment issues:
1. Check logs: `.\dev-helper.ps1 -Action logs`
2. Verify service status: `.\dev-helper.ps1 -Action status`
3. Try fresh start: `.\start-erpnext.ps1 -Fresh`

---

**Version:** ERPNext v15.72.1 + Frappe v15.74.0  
**Last Updated:** 2025-07-31  
**Environment:** Docker Development Setup
