FROM ubuntu:16.04

RUN apt-get update\
    && apt-get install -y wget php php-curl php-imagick php-gd php-mysql locales

# set locale
RUN sed -i 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8
RUN locale-gen

# create and use user
RUN useradd --create-home --shell /bin/bash www-data
USER www-data

ENV MOVIM_VERSION 0.9

RUN wget -O /tmp/movim-v{MOVIM-VERSION}.tar.gz https://github.com/movim/movim/archive/v${MOVIM_VERSION}.tar.gz \
    && tar -xvzC /tmp/ -f /tmp/movim-v{MOVIM-VERSION}.tar.gz \
    && mkdir -p /var/www/html \
    && mkdir -p /var/www/html/log \
    && mkdir -p /var/www/html/users \
    && mkdir -p /var/www/html/cache \
    && mv /tmp/movim-{MOVIM_VERSION}/* /var/www/html/ \
    && chown -R nginx /var/ww/html

WORKDIR /var/www/html
RUN cp db.example.inc.php db.inc.php

VOLUME ["/var/www/html/log/","/var/www/html/users/","/var/www/html/cache/"]
