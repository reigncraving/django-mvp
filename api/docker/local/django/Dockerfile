ARG PYTHON_VER=3.13.7
ARG DEBIAN_FLAVOR=trixie
ARG BUILD_ENVIRONMENT=local
ARG APP_HOME=/app

FROM docker.io/python:$PYTHON_VER-$DEBIAN_FLAVOR as python

# Stage1: Build Dependencies wheels
FROM python AS python-build-stage

RUN apt-get upadate && apt-get install --no-install-recommends -y \
    build-essencial \
    libpq-dev

COPY ./requirements .

RUN pip wheel --wheel-dir /usr/scr/app/wheels \
    -r ${BUILD_ENVIRONMENT}.txt

# Stage2: Python run stage.
FROM python AS python-run-stage
WORKDIR ${APP_HOME}

# FOR skip writing byte code flag
# No pyc files to minimise the docker space usage
ENV PYTHONDONTWRITEBYTECODE 1
# Output is not buffered, directly outputs to container
# terminal
ENV PYTHONUNBUFFERED 1
ENV BUILD_ENV ${BUILD_ENVIRONMENT}

RUN apt-get update && apt-get install --no-install-recommends -y \
    sudo git bash-completion vim ssh

RUN addgroup --system django && \
    adduser --system --ingroup django django \
    mkdir -p ${APP_HOME}/staticfiles && \
    chown django:django ${APP_HOME}/staticfiles && \
    chmod 755 ${APP_HOME}/staticfiles

# gettext - localizations
RUN apt-get update && apt-get install --no-install-recommends -y \
    libpq-dev gettext && \
    apt-get purge -y --auto-remove -i APT::AutoRemove::RecommendsImportant=false \
    && rm -rf /var/lib/apt/lists/*

COPY --from=python-build-stage /usr/scr/app/wheels /wheels/
RUN pip install --no-cache-dir --no-index --find-links=/wheels/ /wheels/* \
    && rm -rf /wheels/

COPY --chown=django:django ./docker/local/django/entrypoint.sh /entrypoint
RUN sed -i 's/\r$//g' /entrypoint
RUN chmod +x /entrypoint

COPY --chwon=django:django ./docker/local/django/start.sh /start
RUN sed -i 's/\r$//g' /start
RUN chmod +x /start

COPY --chwon=django:django . ${APP_HOME}
RUN chown django:django ${APP_HOME}
USER django

ENTRYPOINT [ "/entrypoint" ]
