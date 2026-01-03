#!/bin/bash

# Build docker images
build() {
  echo "🐋 Building docker images..."
  # Local test cleanup:
  if [ ${BUILD_ENVIRONMENT} == "local" ]; then
    echo -e "🧹 cleanup local docker files"
    sudo rm -rf docker/run-data/

    sudo mkdir -p docker/run-data
    sudo mkdir -p docker/run-data/db
    sudo mkdir -p docker/run-data/alpha_apartments_mailpit_data
    sudo mkdir -p docker/run-data/staticfiles
    sudo mkdir -p docker/run-data/client

    sudo touch docker/run-data/.keep
    # sudo chmod 1000:1000 docker/run-data/*
  fi

  # api:
  echo "- api"
  echo "Build env ${BUILD_ENVIRONMENT}"
  docker build \
    --build-arg PYTHON_VER=3.13.7 \
    --build-arg DEBIAN_FLAVOR=slim-trixie \
    --build-arg BUILD_ENVIRONMENT=${BUILD_ENVIRONMENT} \
    --build-arg APP_HOME=/app \
    -t alpha-apartments-api:${BUILD_ENVIRONMENT}-${BUILD_VERSION} \
    -f ./docker/local/django/Dockerfile \
    .

  # postgres
  echo "- postgres"
  docker build \
    -f docker/local/postgres/Dockerfile \
    -t alpha-postgres-db:${BUILD_ENVIRONMENT}-${BUILD_VERSION} \
    .

  # Node.js client
  echo "- client"
  docker build \
    -f client/docker/local/Dockerfile \
    -t alpha-client:${BUILD_ENVIRONMENT}-${BUILD_VERSION} \
    ./client

  # Nginx
  echo "- Nginx"
  docker build \
    -f docker/local/nginx/Dockerfile \
    -t alpha-nginx:${BUILD_ENVIRONMENT}-${BUILD_VERSION} \
    ./docker/local/nginx

  if [ ${DOCKER_ALPHA_USE_MAILPIT} == "1" ]; then
    # mailpit
    echo "- mailpit"
    docker build \
      -f docker/local/mailpit/Dockerfile \
      -t alpha-mailpit:${BUILD_ENVIRONMENT}-${BUILD_VERSION} \
      ./docker/local/mailpit
  else
    echo "- prod"
    # build for production
    # ....
  fi
}

# start compose up:
run() {
  echo -e "Runing containers"
  docker compose -f docker-compose.yml up --remove-orphans
}

while test $# -gt 0; do
  case "$1" in
  -l | --local)
    export DOCKER_BUILD_ENV="local"
    shift
    ;;
  -p | --prod)
    export DOCKER_BUILD_ENV="production"
    shift
    ;;
  -b | --build)
    export DOCKER_ALPHA_BUILD_IMAGE=1
    shift
    ;;
  -h | --help)
    export BREAK_EXECUTION=1
    echo -e "-l | --local    Runs the build images in local mode, setting the images tags to local-latest"
    echo -e "-p | --prod     Runs the build images in production mode, setting the images tags to prod-latest"
    echo -e "-b | --build    Build the docker images before compose up"
    echo -e "-h | --help     Help menu"
    echo -e "\nNOTE: If no flag is set development tags are goint to be used"
    break
    ;;
  *)
    break
    ;;
  esac
done

if [ -z ${BREAK_EXECUTION} ]; then
  case "${DOCKER_BUILD_ENV}" in
  "local")
    echo "Local env"
    export BUILD_VERSION=latest
    export DOCKER_ALPHA_USE_MAILPIT=1
    ;;
  "production")
    echo "Production env"
    export BUILD_VERSION=latest
    export DOCKER_ALPHA_USE_MAILPIT=0
    ;;
  *)
    echo "Development env"
    export BUILD_VERSION=latest
    ;;
  esac

  if [ -z ${DOCKER_ALPHA_BUILD_IMAGE} ]; then
    run
  else
    build
    run
  fi
fi

unset BREAK_EXECUTION
unset DOCKER_ALPHA_USE_MAILPIT
