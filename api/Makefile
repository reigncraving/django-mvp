build:
	docker compose -f docker-compose.yml --build --remove-orphans

up:
	docker compose -f docker-compose.yml up

down:
	docker compose -f docker-compose.yml down

down-v:
	docker compose -f docker-compose.yml down -v

show-logs:
	docker compose -f docker-compose.yml logs

show-logs-api:
	docker compose -f docker-compose.yml logs api

makemigrations:
	docker compose -f docker-compose.yml run --rm api python manage.py makemigrations --no-input --settings config.settings.${BUILD_ENVIRONMENT}

makemigrations-local:
	python manage.py makemigrations

migrate:
	docker compose -f docker-compose.yml run --rm api python manage.py migrate --no-input --settings config.settings.${BUILD_ENVIRONMENT}

migrate-local:
	python manage.py migrate --no-input --settings config.settings.local

collectstatic:
	docker compose -f docker-compose.yml run --rm api python manage.py collectstatic --no-input --clear --settings config.settings.${BUILD_ENVIRONMENT}

superuser:
	docker compose -f docker-compose.yml run --rm api python manage.py createsuperuser

db-volume:
	docker volume inspect api_alpha_apartments_db_data

mailpit-volume:
	docker volume inspect alpha_apartments_mailpit_data

alpha-db:
	docker compose -f docker-compose.yml exec postgres psql --username=root --dbname=alpha

