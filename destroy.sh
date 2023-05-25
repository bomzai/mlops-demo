#!/bin/bash
set -e

if [ "$1" == "-h" ]; then
  echo "Destroy the stack using docker compose and a configuration file."
  echo "Usage: ./destroy.sh CONFIG_FILE COMPONENT_1 ... COMPONENT_N "
  echo "Example: ./destroy.sh configs/local_docker.env coder mlflow"
  exit 0
fi

CONFIG_FILE=$1; shift

# Deploy each component
for COMPONENT in "$@"
do
  if [ -d "$COMPONENT" ]; then
    echo "Unknown component $COMPONENT. Skipping."
    continue
  fi
  echo "Destroying $COMPONENT."
  docker-compose -f stack/$COMPONENT/docker-compose.yml --env-file $CONFIG_FILE down -v
done

# Destroying prerequisites
echo "Destroying prerequisites."
docker-compose -f stack/prerequisite/docker-compose.yml --env-file $CONFIG_FILE down -v

echo "Stack has been succesfully destroyed !"
