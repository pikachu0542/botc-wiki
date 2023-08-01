FROM docker.io/mediawiki:1.35.0

RUN apt-get update; \
    apt-get install -y wget unzip;

WORKDIR /tmp

#COPY download_extensions.sh .
#RUN bash download_extensions.sh

WORKDIR /var/www/html

# Install composer, I guess...
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
    php -r "if (hash_file('sha384', 'composer-setup.php') === 'e21205b207c3ff031906575712edab6f13eb0b361f2085f1f1237b7126d785e826a450292b6cfd1d64d92e6563bbde02') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" && \
    php composer-setup.php && \
    php -r "unlink('composer-setup.php');" && \
    mv composer.phar /usr/local/bin/composer

# TODO: How to run update script? Methinks I need creds
#RUN php /var/www/html/maintenance/update.php

# Add our composer.json. This installs the dependencies, I guess.
RUN composer self-update 1.10.22
RUN composer require mediawiki/auth-remoteuser
#COPY composer.local.json .
#RUN composer update
