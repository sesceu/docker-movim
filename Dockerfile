FROM ubuntu:16.04

RUN apt-get update\
    && apt-get install -y wget php php-curl php-imagick php-gd php-mysql php-zip git locales

# set locale
RUN sed -i 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8
RUN locale-gen

# prepare workdir
RUN mkdir -p /var/www/html \
    && chown -R www-data:www-data /var/www/html
COPY run-script /run-script

ENV MOVIM_VERSION 0.9

RUN wget -O /tmp/movim-v${MOVIM_VERSION}.tar.gz https://github.com/movim/movim/archive/v${MOVIM_VERSION}.tar.gz \
    && tar -xvzC /tmp/ -f /tmp/movim-v${MOVIM_VERSION}.tar.gz \
    && mkdir -p /var/www/html/log \
    && mkdir -p /var/www/html/users \
    && mkdir -p /var/www/html/cache \
    && mv /tmp/movim-${MOVIM_VERSION}/* /var/www/html/ \
    && chown -R www-data /var/www/html \
    && mkdir -p /var/www/.composer \
    && chown -R www-data /var/www/.composer 

USER www-data
WORKDIR /var/www/html
RUN cp config/db.example.inc.php config/db.inc.php \
    && wget -qO- https://getcomposer.org/installer | php \
    && php composer.phar install

VOLUME ["/var/www/html/log/","/var/www/html/users/","/var/www/html/cache/"]

CMD ["/run-script"]
