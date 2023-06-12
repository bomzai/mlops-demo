#!/bin/sh
set -e

# Wait for postgres connection
echo "Waiting for postgres connection."
for i in 1 2 3 4; do pg_isready && break || sleep 15; done

# Initialize database for Prefect
echo "Creating Airflow user and db on postgres"
# Create prefect user if not exists
psql -tXAc "SELECT 1 FROM pg_roles WHERE rolname='$DAGSTER_USER'" | grep -q 1 || psql -v ON_ERROR_STOP=1 -c  "CREATE USER $DAGSTER_USER WITH ENCRYPTED PASSWORD '$DAGSTER_PASSWORD'"
# Create prefect database if not exists
psql -tXAc "SELECT 1 FROM pg_database WHERE datname = '$DAGSTER_DB'" | grep -q 1 || psql -v ON_ERROR_STOP=1 -c "CREATE DATABASE $DAGSTER_DB"
# Setup privileges
psql -c "GRANT ALL PRIVILEGES ON DATABASE $DAGSTER_DB TO $DAGSTER_USER;"
psql -c "ALTER DATABASE $DAGSTER_DB OWNER TO $DAGSTER_USER;"
