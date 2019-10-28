FROM python:2.7-alpine
LABEL maintainer="Kaihua Li"


ENV PYTHONUNBUFFERED 1
ENV C_FORCE_ROOT true
ENV LANG C.UTF-8

ADD pip.conf /root/.pip/pip.conf

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories

RUN apk add --no-cache -U build-base python2-dev libressl-dev libffi-dev tzdata pcre-dev

RUN pip install flask flask_cors uwsgi

RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai  /etc/localtime

# Add demo app
COPY ./app /app
WORKDIR /app

#RUN cp nginx.conf /etc/nginx/nginx.conf

RUN cp uwsgi.ini /uwsgi.ini

# Make /app/* available to be imported by Python globally to better support several use cases like Alembic migrations.
#ENV PYTHONPATH=/app

# Move the base entrypoint to reuse it
#RUN mv /entrypoint.sh /uwsgi-nginx-entrypoint.sh
# Copy the entrypoint that will generate Nginx additional configs
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
#
## Run the start script provided by the parent image tiangolo/uwsgi-nginx.
## It will check for an /app/prestart.sh script (e.g. for migrations)
## And then will start Supervisor, which in turn will start Nginx and uWSGI
#CMD [""]
