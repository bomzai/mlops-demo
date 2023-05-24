#!/bin/bash
set -e

if [ "$1" == "-h" ]; then
  echo "Deploy the stack using docker compose and a configuration file."
  echo "Usage: ./deploy.sh CONFIG_FILE COMPONENT_1 ... COMPONENT_N "
  echo "Example: ./deploy.sh configs/local_docker.env coder mlflow"
  exit 0
fi

CONFIG_FILE=$1; shift

# Deploy the pre-requisites
echo "Deploying prerequisites."
docker-compose -f stack/prerequisite/docker-compose.yml --env-file $CONFIG_FILE up --build --detach

# Deploy each component
for COMPONENT in "$@"
do
  if [ -d "$COMPONENT" ]; then
    echo "Unknown component $COMPONENT. Skipping."
    continue
  fi
  echo "Deploying $COMPONENT."
  docker-compose -f stack/$COMPONENT/docker-compose.yml --env-file $CONFIG_FILE up --build --detach
done

echo "Stack has been succesfully deployed !"
