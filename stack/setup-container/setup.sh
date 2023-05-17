#!/bin/sh
set -e

# Initialize database for MLFlow
echo "Creating MLFlow user and db on postgres"
psql -v ON_ERROR_STOP=1 <<-EOSQL
	CREATE USER mlflow WITH ENCRYPTED PASSWORD 'mlflow123';
	CREATE DATABASE mlflow;
	GRANT ALL PRIVILEGES ON DATABASE mlflow TO mlflow;
EOSQL

echo "Setup of coder environment"
coder login http://coder:7080
coder templates create -y -d ./coder-template ml-workspace 