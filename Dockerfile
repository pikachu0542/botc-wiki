FROM docker.io/mediawiki:1.40

RUN apt-get update; \
    apt-get install -y wget unzip vim;

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
    mv WikiBanner-master /var/www/html/extensions/WikiBanner; \
    rm master.zip; \
    wget https://github.com/wikimedia/mediawiki-extensions-OpenIDConnect/archive/refs/heads/master.zip; \
    unzip master.zip; \
    mv mediawiki-extensions-OpenIDConnect-master /var/www/html/extensions/OpenIDConnect; \
    rm master.zip; \
    wget https://github.com/WillNilges/mediawiki-aws-s3/archive/refs/heads/master.zip; \
    unzip master.zip; \
    mv mediawiki-aws-s3-master /var/www/html/extensions/AWS; \
    rm master.zip; 

WORKDIR /var/www/html

# Install composer, I guess...
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
    php -r "if (hash_file('sha384', 'composer-setup.php') === 'e21205b207c3ff031906575712edab6f13eb0b361f2085f1f1237b7126d785e826a450292b6cfd1d64d92e6563bbde02') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" && \
    php composer-setup.php && \
    php -r "unlink('composer-setup.php');" && \
    mv composer.phar /usr/local/bin/composer

RUN chown -R www-data:www-data composer.json
RUN composer require mediawiki/pluggable-auth jumbojett/openid-connect-php
#edwardspec/mediawiki-aws-s3
RUN composer update
