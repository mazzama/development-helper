# Makefile for LocalStack automation

# Use zsh for shell commands to ensure 'source' works correctly
SHELL := /bin/zsh

# Define the Docker Compose file and the environment loading script
DOCKER_COMPOSE_FILE := docker-compose.yml
ENV_LOADER_SCRIPT := ./load_localstack_env.sh

# Define the LocalStack container name (must match your docker-compose.yml)
LOCALSTACK_CONTAINER_NAME := localstack

.PHONY: all start stop env init s3-test clean help

# Default target: Loads environment variables and starts LocalStack
all: init

# Loads environment variables from .env.localstack into the current shell
# This target is typically used by other targets that need the environment variables
env:
	@echo "Loading LocalStack environment variables..."
	@$(SHELL) -c "source $(ENV_LOADER_SCRIPT)"
	@echo "Environment variables loaded."

# Starts the LocalStack container in detached mode
start:
	@echo "Starting LocalStack container..."
	docker compose -f $(DOCKER_COMPOSE_FILE) up -d
	@echo "LocalStack started. Waiting a few seconds for services to become ready..."
	@sleep 5 # Give LocalStack a moment to spin up services

# Initializes LocalStack: loads env vars and starts the container
init: env start

# Stops the LocalStack container
stop:
	@echo "Stopping LocalStack container..."
	docker compose -f $(DOCKER_COMPOSE_FILE) stop
	@echo "LocalStack stopped."

# Runs a simple S3 test to verify LocalStack is working
# Requires 'awslocal' to be installed and env vars loaded
s3-test: env
	@echo "Running S3 test with awslocal..."
	@awslocal s3 ls
	@echo "S3 test complete."

# Cleans up: stops LocalStack and removes the container and network
clean: stop
	@echo "Removing LocalStack container and associated network..."
	docker compose -f $(DOCKER_COMPOSE_FILE) down -v
	@echo "Cleanup complete."

# Displays help information
help:
	@echo "Usage: make [target]"
	@echo ""
	@echo "Targets:"
	@echo "  all        : (Default) Loads env vars and starts LocalStack."
	@echo "  start      : Starts the LocalStack container."
	@echo "  stop       : Stops the LocalStack container."
	@echo "  env        : Loads LocalStack environment variables into the current shell."
	@echo "  init       : Loads env vars and starts LocalStack (same as 'all')."
	@echo "  s3-test    : Runs a simple S3 test using awslocal (requires 'env' to be run first)."
	@echo "  clean      : Stops LocalStack and removes its container/network."
	@echo "  help       : Displays this help message."
	@echo ""
	@echo "Note: Ensure 'docker-compose.yml', '.env.localstack', and 'load_localstack_env.sh' are in the same directory."
	@echo "      'awslocal' should be installed for 's3-test' to work."

