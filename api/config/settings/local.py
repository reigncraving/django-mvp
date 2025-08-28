from os import getenv, path

from dotenv import load_dotenv

from config.settings.base import *  # noqa
from config.settings.base import BASE_DIR

local_env_file = path.join(BASE_DIR, ".env", ".env.local")

if path.isfile(local_env_file):
    load_dotenv(local_env_file)

DEBUG = True

SECRET_KEY = getenv(
    "DJANGO_SECRET_KEY", "Xj9M713esq9OI8nhuR8UzQ4TDDKPrUM2HLrxodZrAwemel5bok8"
)

SITE_NAME = getenv("SITE_NAME")


ALLOWED_HOSTS = ["localhost", "127.0.0.1", "0.0.0.0"]

ADMIN_URL = getenv("DJANGO_ADMIN_URL")
EMAIL_BACKEND = "djcelery_email.backends.CeleryEmailBackend"
EMAIL_HOST = getenv("EMAIL_HOST")
EMAIL_PORT = getenv("EMAIL_PORT")
DOMAIN = getenv("DOMAIN")
DEFAULT_FROM_EMAIL = getenv("DEFAULT_FROM_EMAIL")

LOGGING = {
    "version": 1,
    "disable_existing_loggers": False,
    "formatters": {
        "verbose": {
            "format": "%(levelname)s %(name)-12s %(asctime)s %(module)s %(process)d %(thread)d %(message)s"
        }
    },
    "handlers": {
        "console": {
            "level": "DEBUG",
            "class": "logging.StreamHandler",
            "formatter": "verbose",
        }
    },
    "root": {
        "level": "INFO",
        "handlers": [
            "console"
        ]
    },
}
