from os import getenv, path

from dotenv import load_dotenv

from .base import *  # noqa
from .base import BASE_DIR

local_env_file = path.join(BASE_DIR, ".env", ".env.local")

if path.isfile(local_env_file):
    load_dotenv(local_env_file)


SECRET_KEY = getenv("DJANGO_SECRET_KEY")

ADMIN_URL = getenv("DJANGO_ADMIN_URL")

SITE_NAME = getenv("SITE_NAME")

ADMINS = [("reigncraving", "admin@gmail.com")]

ALLOWED_HOSTS = []

EMAIL_BACKEND = "djcelery_email.backends.CeleryEmailBackend"
EMAIL_HOST = getenv("EMAIL_HOST")
EMAIL_PORT = getenv("EMAIL_PORT")
DEFAULT_FROM_EMAIL = getenv("DEFAULT_FROM_EMAIL")
DOMAIN = getenv("DOMAIN")
