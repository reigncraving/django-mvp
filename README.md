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

or without building the images:

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



