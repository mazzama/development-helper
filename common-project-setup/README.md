# Common Project Setup with LGTM Stack

This Docker Compose setup provides a complete development and monitoring environment with PostgreSQL, Redis, and the LGTM (Loki, Grafana, Tempo, Mimir) observability stack.

## Services Included

### Core Services
- **PostgreSQL 15**: Primary database with persistent storage
- **Redis 7**: Caching and session storage with persistent data

### LGTM Monitoring Stack
- **Loki**: Log aggregation and storage
- **Grafana**: Visualization and dashboards
- **Tempo**: Distributed tracing
- **Mimir**: Long-term metrics storage
- **Prometheus**: Metrics collection and scraping

### Exporters
- **Node Exporter**: System metrics
- **PostgreSQL Exporter**: Database metrics
- **Redis Exporter**: Cache metrics

## Quick Start

1. **Clone and navigate to the directory:**
   ```bash
   cd common-project-setup
   ```

2. **Start all services:**
   ```bash
   docker-compose up -d
   ```

3. **Check service status:**
   ```bash
   docker-compose ps
   ```

4. **Access the services:**
   - Grafana: http://localhost:3000 (admin/admin)
   - PostgreSQL: localhost:5432 (postgres/postgres)
   - Redis: localhost:6379
   - Prometheus: http://localhost:9090
   - Loki: http://localhost:3100
   - Tempo: http://localhost:3200

## Service Details

### PostgreSQL
- **Port**: 5432
- **Database**: myapp
- **Username**: postgres
- **Password**: postgres
- **Volume**: `postgres_data`
- **Additional databases**: app_development, app_test, app_staging
- **Application user**: app_user/app_password

### Redis
- **Port**: 6379
- **Volume**: `redis_data`
- **Configuration**: Production-ready settings with persistence
- **Memory Policy**: allkeys-lru
- **Persistence**: Both RDB and AOF enabled

### Grafana
- **Port**: 3000
- **Username**: admin
- **Password**: admin
- **Pre-configured datasources**: Prometheus, Mimir, Loki, Tempo
- **Pre-built dashboards**: PostgreSQL and Redis monitoring

### Monitoring Stack
- **Prometheus**: Scrapes metrics from all services
- **Mimir**: Long-term metrics storage with remote write from Prometheus
- **Loki**: Centralized logging with retention policies
- **Tempo**: Distributed tracing with service maps

## Production Considerations

### Security
1. **Change default passwords** in production:
   ```yaml
   environment:
     POSTGRES_PASSWORD: your_secure_password
     GF_SECURITY_ADMIN_PASSWORD: your_grafana_password
   ```

2. **Enable Redis authentication**:
   ```
   # In redis/redis.conf
   requirepass your_redis_password
   ```

3. **Use secrets management** for sensitive data

### Storage
- All services use named volumes for data persistence
- For production, consider using external storage or NFS mounts
- Regular backups should be implemented for PostgreSQL and Redis

### Resource Limits
Add resource limits to prevent any service from consuming all available resources:

```yaml
services:
  postgres:
    deploy:
      resources:
        limits:
          memory: 1G
          cpus: '0.5'
```

### Networking
- Services are separated into `app-network` and `monitoring` networks
- Adjust firewall rules for production deployments
- Consider using reverse proxy for external access

## Monitoring and Alerting

### Available Dashboards
1. **PostgreSQL Overview**: Database performance, connections, transactions
2. **Redis Overview**: Memory usage, commands rate, client connections
3. **System Metrics**: CPU, memory, disk usage via Node Exporter

### Setting Up Alerts
1. Configure alert rules in Prometheus
2. Set up Alertmanager for notifications
3. Use Grafana alerts for dashboard-based alerting

## Maintenance Commands

### Start/Stop Services
```bash
# Start all services
docker-compose up -d

# Stop all services
docker-compose down

# Restart specific service
docker-compose restart postgres
```

### View Logs
```bash
# All services
docker-compose logs -f

# Specific service
docker-compose logs -f postgres
```

### Database Operations
```bash
# Connect to PostgreSQL
docker-compose exec postgres psql -U postgres -d myapp

# Connect to Redis
docker-compose exec redis redis-cli
```

### Backup and Restore
```bash
# PostgreSQL backup
docker-compose exec postgres pg_dump -U postgres myapp > backup.sql

# PostgreSQL restore
docker-compose exec -T postgres psql -U postgres myapp < backup.sql

# Redis backup
docker-compose exec redis redis-cli BGSAVE
```

## Troubleshooting

### Common Issues

1. **Port conflicts**: Ensure ports 3000, 3100, 3200, 5432, 6379, 9009, 9090 are available
2. **Volume permissions**: Check Docker volume permissions if services fail to start
3. **Memory issues**: Increase Docker memory limits if services are killed

### Health Checks
All services include health checks. Check status with:
```bash
docker-compose ps
```

### Performance Tuning
1. **PostgreSQL**: Adjust `shared_buffers`, `effective_cache_size` in postgresql.conf
2. **Redis**: Tune `maxmemory` and `maxmemory-policy` in redis.conf
3. **Monitoring**: Adjust scrape intervals and retention periods

## Development Integration

### Application Configuration
Use these connection strings in your applications:

```yaml
# Database
DATABASE_URL: postgresql://app_user:app_password@localhost:5432/myapp

# Redis
REDIS_URL: redis://localhost:6379

# Monitoring endpoints
PROMETHEUS_URL: http://localhost:9090
GRAFANA_URL: http://localhost:3000
```

### Adding Custom Metrics
1. Expose metrics endpoint in your application
2. Add scrape configuration to `prometheus/prometheus.yml`
3. Create custom Grafana dashboards

## Contributing

1. Fork the repository
2. Create feature branch
3. Test changes thoroughly
4. Submit pull request

## License

MIT License - see LICENSE file for details