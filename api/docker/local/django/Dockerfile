ARG PYTHON_VER=3.13.7
ARG DEBIAN_FLAVOR=trixie

FROM docker.io/python:$PYTHON_VER-$DEBIAN_FLAVOR

ARG BUILD_ENVIRONMENT=local
ARG APP_HOME /app

ENV BUILD_ENV=${BUILD_ENVIRONMENT}
# Skip writing byte code flag No pyc files to minimise the docker space usage
ENV PYTHONDONTWRITEBYTECODE=1
# Output is not buffered, directly outputs to container terminal
ENV PYTHONUNBUFFERED=1
ENV BUILD_ENV=${BUILD_ENVIRONMENT}

# Install dependencies
RUN apt-get update && apt-get install --no-install-recommends -y \
    build-essential libpq-dev sudo git bash-completion vim ssh \
    libpq-dev gettext \
    && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false \
    && rm -rf /var/lib/apt/lists/*

# Copy Required files:
COPY ./requirements .

# Build Dependencies wheels
RUN pip3 wheel --wheel-dir /wheels/ -r ${BUILD_ENV}.txt
RUN pip3 install --no-cache-dir --no-index --find-links=/wheels/ /wheels/* \
    && rm -rf /wheels/

WORKDIR ${APP_HOME}

# Ownership
RUN addgroup --system django && \
    adduser --system --ingroup django django && \
    mkdir -p ${APP_HOME}/staticfiles && \
    chown django:django ${APP_HOME}/staticfiles && \
    chmod 775 ${APP_HOME}/staticfiles

COPY --chown=django:django . ${APP_HOME}
COPY --chown=django:django ./docker/local/django/entrypoint.sh /entrypoint
COPY --chown=django:django ./docker/local/django/start.sh /start

# Clean up for Windows paths \ vs /
RUN sed -i 's/\r$//g' /start && \
    sed -i 's/\r$//g' /entrypoint && \
    chmod +x /entrypoint && \
    chmod +x /start

USER django

ENTRYPOINT [ "/entrypoint" ]
