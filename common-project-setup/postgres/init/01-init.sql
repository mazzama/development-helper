-- PostgreSQL initialization script
-- This script runs when the PostgreSQL container starts for the first time

-- Create additional databases if needed
CREATE DATABASE app_development;
CREATE DATABASE app_test;
CREATE DATABASE app_staging;

-- Create application user with appropriate permissions
CREATE USER app_user WITH PASSWORD 'app_password';

-- Grant permissions to the application user
GRANT ALL PRIVILEGES ON DATABASE myapp TO app_user;
GRANT ALL PRIVILEGES ON DATABASE app_development TO app_user;
GRANT ALL PRIVILEGES ON DATABASE app_test TO app_user;
GRANT ALL PRIVILEGES ON DATABASE app_staging TO app_user;

-- Connect to the main database and create extensions
\c myapp;

-- Enable commonly used extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pg_stat_statements";
CREATE EXTENSION IF NOT EXISTS "pg_trgm";
CREATE EXTENSION IF NOT EXISTS "btree_gin";
CREATE EXTENSION IF NOT EXISTS "btree_gist";
