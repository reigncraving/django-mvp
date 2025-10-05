build:
	docker compose -f docker-compose-local.yml --build --remove-orphans

up:
	docker compose -f docker-compose-local.yml up

down:
	docker compose -f docker-compose-local.yml down

down-v:
	docker compose -f docker-compose-local.yml down -v

show-logs:
	docker compose -f docker-compose-local.yml logs

show-logs-api:
	docker compose -f docker-compose-local.yml logs api

makemigrations:
	docker compose -f docker-compose-local.yml run --rm api python manage.py makemigrations

migrate:
	docker compose -f docker-compose-local.yml run --rm api python manage.py migrate

collectstatic:
	docker compose -f docker-compose-local.yml run --rm api python manage.py collectstatic --no-input --clear

superuser:
	docker compose -f docker-compose-local.yml run --rm api python manage.py createsuperuser

db-volume:
	docker volume inspect alpha_apartments_db_data

mailpit-volume:
	docker volume inspect alpha_apartments_mailpit_data

alpha-db:
	docker compose -f docker-compose-local.yml exec postgres psql --username=root --dbname=alpha

