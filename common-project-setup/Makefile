.PHONY: help up down restart logs status clean backup restore health

# Default target
help: ## Show this help message
	@echo 'Usage: make [target]'
	@echo ''
	@echo 'Targets:'
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

# Docker Compose Commands
up: ## Start all services
	@echo "Starting all services..."
	docker-compose up -d
	@echo "Services started. Access Grafana at http://localhost:3000 (admin/admin)"

down: ## Stop all services
	@echo "Stopping all services..."
	docker-compose down

restart: ## Restart all services
	@echo "Restarting all services..."
	docker-compose restart

stop: ## Stop all services without removing containers
	@echo "Stopping all services..."
	docker-compose stop

start: ## Start existing containers
	@echo "Starting existing containers..."
	docker-compose start

# Service-specific commands
up-db: ## Start only database services (PostgreSQL and Redis)
	docker-compose up -d postgres redis

up-monitoring: ## Start only monitoring services
	docker-compose up -d grafana prometheus loki tempo mimir node-exporter postgres-exporter redis-exporter

restart-db: ## Restart database services
	docker-compose restart postgres redis

restart-monitoring: ## Restart monitoring services
	docker-compose restart grafana prometheus loki tempo mimir

# Logs and Status
logs: ## Show logs for all services
	docker-compose logs -f

logs-db: ## Show logs for database services
	docker-compose logs -f postgres redis

logs-monitoring: ## Show logs for monitoring services
	docker-compose logs -f grafana prometheus loki tempo mimir

status: ## Show status of all services
	docker-compose ps

health: ## Check health of all services
	@echo "Checking service health..."
	@docker-compose ps --format "table {{.Name}}\t{{.Status}}\t{{.Ports}}"

# Database Operations
db-connect: ## Connect to PostgreSQL database
	docker-compose exec postgres psql -U postgres -d myapp

redis-connect: ## Connect to Redis
	docker-compose exec redis redis-cli

db-backup: ## Backup PostgreSQL database
	@echo "Creating PostgreSQL backup..."
	@mkdir -p backups
	docker-compose exec postgres pg_dump -U postgres myapp > backups/postgres_backup_$$(date +%Y%m%d_%H%M%S).sql
	@echo "Backup created in backups/ directory"

redis-backup: ## Backup Redis data
	@echo "Creating Redis backup..."
	docker-compose exec redis redis-cli BGSAVE
	@echo "Redis backup initiated"

db-restore: ## Restore PostgreSQL database (requires BACKUP_FILE variable)
	@if [ -z "$(BACKUP_FILE)" ]; then \
		echo "Usage: make db-restore BACKUP_FILE=path/to/backup.sql"; \
		exit 1; \
	fi
	@echo "Restoring PostgreSQL database from $(BACKUP_FILE)..."
	docker-compose exec -T postgres psql -U postgres myapp < $(BACKUP_FILE)

# Monitoring and Maintenance
clean: ## Remove all containers, volumes, and networks
	@echo "WARNING: This will remove all data. Press Ctrl+C to cancel, or wait 10 seconds to continue..."
	@sleep 10
	docker-compose down -v --remove-orphans
	docker system prune -f

clean-logs: ## Clean up Docker logs
	docker system prune -f

update: ## Pull latest images and restart services
	@echo "Pulling latest images..."
	docker-compose pull
	@echo "Restarting services with new images..."
	docker-compose up -d

# Development helpers
setup: ## Initial setup (copy .env.example to .env)
	@if [ ! -f .env ]; then \
		cp .env.example .env; \
		echo "Created .env file from .env.example"; \
		echo "Please review and modify .env file as needed"; \
	else \
		echo ".env file already exists"; \
	fi

test-connections: ## Test connections to all services
	@echo "Testing PostgreSQL connection..."
	@docker-compose exec postgres pg_isready -U postgres || echo "PostgreSQL not ready"
	@echo "Testing Redis connection..."
	@docker-compose exec redis redis-cli ping || echo "Redis not ready"
	@echo "Testing Grafana..."
	@curl -s http://localhost:3000/api/health > /dev/null && echo "Grafana OK" || echo "Grafana not ready"
	@echo "Testing Prometheus..."
	@curl -s http://localhost:9090/-/ready > /dev/null && echo "Prometheus OK" || echo "Prometheus not ready"

monitor: ## Open monitoring URLs
	@echo "Opening monitoring interfaces..."
	@echo "Grafana: http://localhost:3000 (admin/admin)"
	@echo "Prometheus: http://localhost:9090"
	@echo "Loki: http://localhost:3100"
	@echo "Tempo: http://localhost:3200"

dev-setup: setup up test-connections ## Complete development setup
	@echo "Development environment is ready!"
	@echo "Access Grafana at http://localhost:3000 (admin/admin)"
	@echo "PostgreSQL: localhost:5432 (postgres/postgres)"
	@echo "Redis: localhost:6379"

# Resource monitoring
resources: ## Show resource usage of containers
	docker stats --format "table {{.Container}}\t{{.CPUPerc}}\t{{.MemUsage}}\t{{.NetIO}}\t{{.BlockIO}}"

top: ## Show top processes in containers
	docker-compose top