FROM tiangolo/uwsgi-nginx:python2.7

LABEL maintainer="Kaihua Li"

RUN pip install flask flask_cors

# Add demo app
COPY ./app /app
WORKDIR /app

# Make /app/* available to be imported by Python globally to better support several use cases like Alembic migrations.
ENV PYTHONPATH=/app

# Move the base entrypoint to reuse it
RUN mv /entrypoint.sh /uwsgi-nginx-entrypoint.sh
# Copy the entrypoint that will generate Nginx additional configs
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
#
## Run the start script provided by the parent image tiangolo/uwsgi-nginx.
## It will check for an /app/prestart.sh script (e.g. for migrations)
## And then will start Supervisor, which in turn will start Nginx and uWSGI
CMD ["/start.sh"]
