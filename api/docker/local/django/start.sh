#!/bin/bash

set -o errexit
set -o pipefail
set -o nounset

python manage.py migrate --no-input --settings config.settings.${BUILD_ENVIRONMENT}
python manage.py collectstatic --no-input --settings config.settings.${BUILD_ENVIRONMENT}
python manage.py runserver 0.0.0.0:8000 --settings config.settings.${BUILD_ENVIRONMENT}
