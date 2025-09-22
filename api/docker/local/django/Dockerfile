ARG PYTHON_VER=3.13.7
ARG DEBIAN_FLAVOR=slim-trixie

# [STAGE 1] BUILD
FROM docker.io/python:$PYTHON_VER-$DEBIAN_FLAVOR AS debian

ARG BUILD_ENVIRONMENT=production

# Copy Required files:
COPY ./requirements .

# Install dependencies and build packages:
RUN apt-get update && apt-get install --no-install-recommends -y \
    build-essential libpq-dev && \
    pip wheel --wheel-dir /usr/src/app/wheels \
    -r ${BUILD_ENVIRONMENT}.txt

# [STAGE 2] RUN
FROM debian AS django-run

ARG BUILD_ENVIRONMENT=production
ARG APP_HOME /app

# Skip writing byte code flag No pyc files to minimise the docker space usage
ENV PYTHONDONTWRITEBYTECODE=1
# Output is not buffered, directly outputs to container terminal
ENV PYTHONUNBUFFERED=1

WORKDIR ${APP_HOME}

# Install dependencies
RUN apt-get update && apt-get install --no-install-recommends -y \
    sudo git bash-completion vim ssh libpq-dev gettext \
    && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false \
    && rm -rf /var/lib/apt/lists/*

COPY --from=debian /usr/src/app/wheels /wheels/

# Install Dependencies wheels
RUN pip3 install --no-cache-dir --no-index --find-links=/wheels/ /wheels/* \
    && rm -rf /wheels/

# Ownership
RUN addgroup --system django && \
    adduser --system --ingroup django django && \
    mkdir -p ${APP_HOME}/staticfiles && \
    chown django:django ${APP_HOME}/staticfiles && \
    chmod -R 775 ${APP_HOME}/staticfiles

COPY --chown=django:django . ${APP_HOME}
COPY --chown=django:django ./docker/local/django/entrypoint.sh /entrypoint
COPY --chown=django:django ./docker/local/django/start.sh /start

# Clean up for Windows paths \ vs /
RUN sed -i 's/\r$//g' /entrypoint && \
    chmod +x /entrypoint

RUN sed -i 's/\r$//g' /start && \
    chmod +x /start

RUN chown django:django ${APP_HOME}
USER django

ENTRYPOINT [ "/entrypoint" ]
