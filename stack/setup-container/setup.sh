#!/bin/sh
set -e

# Initialize database for MLFlow
psql -v ON_ERROR_STOP=1 <<-EOSQL
	CREATE USER mlflow WITH ENCRYPTED PASSWORD 'mlflow123';
	CREATE DATABASE mlflow;
	GRANT ALL PRIVILEGES ON DATABASE mlflow TO mlflow;
EOSQL

