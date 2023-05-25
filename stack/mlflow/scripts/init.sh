#!/bin/sh
set -e

# Wait for postgres connection
echo "Waiting for postgres connection."
for i in 1 2 3 4; do pg_isready && break || sleep 15; done

# Initialize database for MLFlow
echo "Creating Coder user and db on postgres"
# Create MLFlow user if not exists
psql -tXAc "SELECT 1 FROM pg_roles WHERE rolname='$MLFLOW_USER'" | grep -q 1 || psql -v ON_ERROR_STOP=1 -c  "CREATE USER $MLFLOW_USER WITH ENCRYPTED PASSWORD '$MLFLOW_PASSWORD'"
# Create MLFlow database if not exists
psql -tXAc "SELECT 1 FROM pg_database WHERE datname = '$MLFLOW_DB'" | grep -q 1 || psql -v ON_ERROR_STOP=1 -c "CREATE DATABASE $MLFLOW_DB"
# Setup privileges
psql -c "GRANT ALL PRIVILEGES ON DATABASE $MLFLOW_DB TO $MLFLOW_USER;"
psql -c "ALTER DATABASE $MLFLOW_DB OWNER TO $MLFLOW_USER;"

