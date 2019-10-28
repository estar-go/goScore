FROM ubuntu:18.04
LABEL maintainer="Kaihua Li"


ENV PYTHONUNBUFFERED 1
ENV C_FORCE_ROOT true
ENV LANG C.UTF-8

ADD pip.conf /root/.pip/pip.conf

ADD sources.list /etc/apt/sources.list

RUN apt-get update && \
    apt-get install python2.7 python2.7-dev python-pip software-properties-common -y

RUN pip install flask flask_cors uwsgi

RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai  /etc/localtime

# Add demo app
COPY ./app /app
COPY ./pachi /pachi
WORKDIR /pachi
RUN make && make install && make install-data
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

