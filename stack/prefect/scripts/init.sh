#!/bin/sh
set -e

# Wait for postgres connection
echo "Waiting for postgres connection."
for i in 1 2 3 4; do pg_isready && break || sleep 15; done

# Initialize database for Prefect
echo "Creating Prefect user and db on postgres"
# Create prefect user if not exists
psql -tXAc "SELECT 1 FROM pg_roles WHERE rolname='$PREFECT_USER'" | grep -q 1 || psql -v ON_ERROR_STOP=1 -c  "CREATE USER $PREFECT_USER WITH ENCRYPTED PASSWORD '$PREFECT_PASSWORD'"
# Create prefect database if not exists
psql -tXAc "SELECT 1 FROM pg_database WHERE datname = '$PREFECT_DB'" | grep -q 1 || psql -v ON_ERROR_STOP=1 -c "CREATE DATABASE $PREFECT_DB"
# Setup privileges
psql -c "GRANT ALL PRIVILEGES ON DATABASE $PREFECT_DB TO $PREFECT_USER;"
psql -c "ALTER DATABASE $PREFECT_DB OWNER TO $PREFECT_USER;"

