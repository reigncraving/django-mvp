#!/bin/bash

# Build docker images
build() {
  echo "🐋 Building docker images..."
  # api:
  docker build \
    --build-arg PYTHON_VER=3.13.7 \
    --build-arg DEBIAN_FLAVOR=slim-trixie \
    --build-arg BUILD_ENVIRONMENT=local \
    --build-arg APP_HOME=/app \
    -t alpha-apartments-api:${DOCKER_ALPHA_IMAGE_VERSION} \
    -f docker/local/django/Dockerfile \
    --remove-orphans \
    .
  # postgres
  docker build \
    -f docker/local/postgres/Dockerfile \
    -t alpha-postgres-db:${DOCKER_ALPHA_IMAGE_VERSION} \
    --remove-orphans \
    .
  # mailpit
  docker build \
    -f docker/local/mailpit/Dockerfile \
    -t alpha-mailpit:${DOCKER_ALPHA_IMAGE_VERSION} \
    --remove-orphans \
    .
}

# start compose up:
run() {
  echo -e "Runing containers"
  docker compose -f docker-compose-local.yml up --remove-orphans
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
    export DOCKER_ALPHA_IMAGE_VERSION=local-latest
    ;;
  "production")
    echo "Production env"
    export DOCKER_ALPHA_IMAGE_VERSION=prod-latest
    ;;
  *)
    echo "Development env"
    export DOCKER_ALPHA_IMAGE_VERSION=develop-latest
    ;;
  esac

  if [ -z ${DOCKER_ALPHA_BUILD_IMAGE} ]; then
    run
  else
    build
    run
  fi
fi

unset DOCKER_ALPHA_BUILD_IMAGE
unset BREAK_EXECUTION
