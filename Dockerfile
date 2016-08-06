FROM phusion/baseimage:0.9.19

RUN apt-get update\
    && apt-get install -y wget php php-curl php-imagick php-gd php-mysql php-zip php-mbstring git locales sudo nginx supervisor

# set locale
#RUN sed -i 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
#ENV LANG en_US.UTF-8
#ENV LC_ALL en_US.UTF-8
#RUN locale-gen

# prepare workdir
RUN mkdir -p /var/www/html \
    && chown -R www-data:www-data /var/www/html \
    && gpasswd -a www-data sudo \
    && echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

RUN mkdir -p /var/www/html \
    && chown -R www-data /var/www/html \
    && chown -R www-data /var/lib/nginx \
    && mkdir -p /var/www/.composer \
    && chown -R www-data /var/www/.composer 

#USER www-data
WORKDIR /var/www/html
RUN rm index.nginx-debian.html \
    && git clone https://github.com/movim/movim.git . \
    && cp config/db.example.inc.php config/db.inc.php \
    && wget -qO- https://getcomposer.org/installer | php \
    && php composer.phar install

VOLUME ["/var/www/html/log/","/var/www/html/users/","/var/www/html/cache/"]

COPY nginx.conf /etc/nginx/nginx.conf
COPY run-script /run-script
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
CMD supervisord -c /etc/supervisor/conf.d/supervisord.conf

EXPOSE 80
