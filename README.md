# Implementation of MVP django course.

## Tools and technologies used:

Technologies
- React
- Next.js
- Typescript
- Python
- Django
- Django REST API
- Docker
- Portainer
- Redis

Libraries:
- shadcn
- Tailwind.css
- Redux Toolkit
- heroicons
- Zod
- react tostify
- djoser
- drf-yasg

Tools and services:
- Mailgun
- Mailpit
- Celery
- Cloudinary
- Digital Ocean
- namecheap

# Getting Started:

## Local Environment:

Run the server:

```shell
python3 manage.py runserver 0:8000 --settings=config.settings.local
```

## Docker Compose:

You can build and run the application by executing the following command:

```shell
./scripts/run-docker.sh --build --local
```

Or without building the images:

```shell
./scripts/run-docker.sh --local
```

For more information run:

```shell
./scripts/run-docker.sh --help
```

For production:

```shell
./script/run-docker.sh --prod --build
```


## Makefile

Build without arguments:

```shell
make build
```

Up the containers:
```shell
make up
```

Down
```shell
make down
```

Other available commands:

- build
- up
- down
- show-logs
- show-logs-api
- makemigrations
- migrate
- collectstatic
- superuser
- db-volume
- mailpit-volume
- alpha-db

### Local setup:

Make sure you have all envs in .env file

```shell
# Local
export DEBUG=1
export BUILD_ENVIRONMENT=local
export BUILD_VERSION=latest
export DOMAIN=""
export ADMIN_URL=""
export SITE_NAME=""
export SECRET_KEY=""
export DJANGO_SECRET_KEY=""
export DEFAULT_FROM_EMAIL=""
export DJANGO_ALLOWED_HOSTS="localhost 127.0.0.1 [::1]"
export EMAIL_HOST="mailpit"
export EMAIL_PORT="1025"
export SQL_ENGINE=django.db.backends.postgresql
export SQL_DB=""
export SQL_USER=""
export SQL_PASSWORD=""
export SQL_HOST=""
export SQL_PORT=""

# MAILPIT
export MP_MAX_MESSAGES=5000
export MP_DATA_FILE=/data/mailpit.db
# unsecure login for dev:
export MP_SMTP_AUTH_ACCEPT_ANY=1
export MP_SMTP_AUTH_ALLOW_INSECURE=1

# postgresql
export POSTGRES_PASSWORD=${SQL_PASSWORD}
export POSTGRES_USER=${SQL_USER}
export POSTGRES_DB=${SQL_DB}

# DOCKER and MAKEFIL:
export BUILD_ENVIRONMENT="local"
```


```shell
source .env
```

makemigrations:
```shell
make mm
```

migrate:
```shell
make mig
```

createsuperuser:

```shell
make su
```

runserver;

```shell
make runserer
```
