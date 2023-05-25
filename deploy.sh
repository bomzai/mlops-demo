#!/bin/bash
set -e

if [ "$1" == "-h" ]; then
  echo "Deploy the stack using docker compose and a configuration file."
  echo "Usage: ./deploy.sh CONFIG_FILE COMPONENT_1 ... COMPONENT_N "
  echo "Example: ./deploy.sh configs/local_docker.env coder mlflow"
  exit 0
fi

CONFIG_FILE=$1; shift

# Set host env variables
case $(uname) in

  Linux)
    export DOCKER_GROUP_ID=$(getent group docker | cut -d: -f3)
    ;;

  Darwin)
    # Docker workaround on Macos 
    export DOCKER_GROUP_ID=1002
    docker run --rm \
    -v /var/run/docker.sock:/var/run/docker.sock \
    --user root \
    --entrypoint /bin/sh \
    ghcr.io/coder/coder:v0.23.4 \
    -c "chmod g+w /var/run/docker.sock && chgrp $DOCKER_GROUP_ID /var/run/docker.sock"
    ;;

  *)
    echo "Error: Unsupported OS"
    exit 1
    ;;
esac

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
