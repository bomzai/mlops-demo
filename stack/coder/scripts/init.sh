#!/bin/sh
set -e

# Wait for postgres connection
echo "Waiting for postgres connection."
for i in 1 2 3 4; do pg_isready && break || sleep 15; done

# Initialize database for Coder
echo "Creating Coder user and db on postgres"
# Create coder user if not exists
psql -tXAc "SELECT 1 FROM pg_roles WHERE rolname='$CODER_USER'" | grep -q 1 || psql -v ON_ERROR_STOP=1 -c  "CREATE USER $CODER_USER WITH ENCRYPTED PASSWORD '$CODER_PASSWORD'"
# Create coder database if not exists
psql -tXAc "SELECT 1 FROM pg_database WHERE datname = '$CODER_DB'" | grep -q 1 || psql -v ON_ERROR_STOP=1 -c "CREATE DATABASE $CODER_DB"
# Setup privileges
psql -c "GRANT ALL PRIVILEGES ON DATABASE $CODER_DB TO $CODER_USER;"
psql -c "ALTER DATABASE $CODER_DB OWNER TO $CODER_USER;"

# Setup coder environment
echo "Setup of coder environment"
coder login http://coder:7080
coder templates create -y -d /coder-template ml-workspace 
