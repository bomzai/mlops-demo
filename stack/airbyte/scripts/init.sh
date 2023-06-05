#!/bin/sh
set -e

# Wait for postgres connection
echo "Waiting for postgres connection."
for i in 1 2 3 4; do pg_isready && break || sleep 15; done
echo "Ready for connection"

# Initialize database airbyte for Airbyte
echo "Creating Airbyte user and airbyte db on postgres"
# Create Airbyte user if not exists
psql -tXAc "SELECT 1 FROM pg_roles WHERE rolname='$AIRBYTE_USER'" | grep -q 1 || psql -v ON_ERROR_STOP=1 -c  "CREATE USER $AIRBYTE_USER WITH ENCRYPTED PASSWORD '$AIRBYTE_PASSWORD'"
# Create Airbyte database if not exists
psql -tXAc "SELECT 1 FROM pg_database WHERE datname = '$AIRBYTE_DB'" | grep -q 1 || psql -v ON_ERROR_STOP=1 -c "CREATE DATABASE $AIRBYTE_DB"
# Setup privileges

# Setup privileges
psql -c "GRANT ALL PRIVILEGES ON DATABASE $AIRBYTE_DB TO $AIRBYTE_USER;"
psql -c "GRANT CREATE, TEMPORARY ON DATABASE $AIRBYTE_DB TO $AIRBYTE_USER;"
psql -c "ALTER DATABASE $AIRBYTE_DB OWNER TO $AIRBYTE_USER;"
psql -c "ALTER USER $AIRBYTE_USER CREATEDB;"

echo "$AIRBYTE_USER user and airbyte created."