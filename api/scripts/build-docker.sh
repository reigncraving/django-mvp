#!/bin/bash/

local_build() {
  # build:
  # api:
  docker build \
    --build-arg PYTHON_VER=3.13.7 \
    --build-arg DEBIAN_FLAVOR=trixie \
    --build-arg BUILD_ENVIRONMENT=local \
    --build-arg APP_HOME=/app \
    -t alpha-apartments-api:local-latest \
    -f docker/local/django/Dockerfile \
    .
  # postgres
  docker build \
    -f docker/local/postgres/Dockerfile \
    -t alpha-postgres-db:local-latest \
    .
  # start compose up:
  docker compose -f docker-compose-local.yml up --remove-orphans
}

echo "🐋 Building docker images..."
while test $# -gt 0; do
  case "$1" in
  -l | --local)
    local_build
    echo "local.."
    return 1
    shift
    ;;
  *)
    break
    ;;
  esac
done
