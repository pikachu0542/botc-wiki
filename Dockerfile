FROM docker.io/mediawiki

RUN apt-get update; \
    apt-get install -y wget;

WORKDIR /tmp

COPY download_extensions.sh .
RUN bash download_extensions.sh

WORKDIR /var/www/html

# TODO: How to run update script? Methinks I need creds
#RUN php /var/www/html/maintenance/update.php

# Add our composer.json. This installs the dependencies, I guess.
COPY composer.local.json .
