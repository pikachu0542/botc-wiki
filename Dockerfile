FROM docker.io/mediawiki

RUN apt-get update; \
    apt-get install -y wget;

WORKDIR /tmp

RUN wget https://extdist.wmflabs.org/dist/extensions/OpenIDConnect-REL1_40-e9d47f2.tar.gz && \
    tar -xvzf OpenIDConnect-REL1_40-e9d47f2.tar.gz && \
    mv OpenIDConnect /var/www/html/extensions;

WORKDIR /var/www/html

# TODO: How to run update script? Methinks I need creds
#RUN php /var/www/html/maintenance/update.php

# Add our composer.json. This installs the dependencies, I guess.
COPY composer.local.json .
