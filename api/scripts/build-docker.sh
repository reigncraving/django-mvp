#!/bin/bash/

local_build() {
  docker build \
    --build-arg PYTHON_VER=3.13.7 \
    --build-arg DEBIAN_FLAVOR=trixie \
    --build-arg BUILD_ENVIRONMENT=local \
    --build-arg APP_HOME=/app \
    -t alpha-apartments:local-latest \
    docker/local/django/
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
