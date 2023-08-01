FROM docker.io/mediawiki:1.40

RUN apt-get update; \
    apt-get install -y wget unzip;

WORKDIR /tmp

#COPY download_extensions.sh .
#RUN bash download_extensions.sh

# extension is spaghet and not available through composer
RUN wget https://github.com/Telshin/Spoilers/archive/master.zip; \
    unzip master.zip; \
    mv Spoilers-master /var/www/html/extensions/Spoilers; \
    rm master.zip; \
    wget https://github.com/Pavelovich/WikiBanner/archive/master.zip; \
    unzip master.zip; \
    mv WikiBanner-master /var/www/html/extensions/WikiBanner;

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
RUN chown -R www-data:www-data composer.json
RUN composer require mediawiki/pluggable-auth mediawiki/oauthclient
RUN composer update
#COPY composer.local.json .
#RUN composer update
