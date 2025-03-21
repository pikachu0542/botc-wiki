FROM docker.io/mediawiki:1.40

COPY remoteip.conf /etc/apache2/mods-available/
RUN a2enmod remoteip

RUN apt-get update; \
    apt-get install -y wget unzip libldap-dev;

WORKDIR /tmp

# extension is spaghet and not available through composer
COPY download_git_extensions.sh .
RUN bash download_git_extensions.sh

WORKDIR /var/www/html

COPY csh-wiki-logo.png images/

# Install composer, I guess...
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
    php -r "if (hash_file('sha384', 'composer-setup.php') === '544e09ee996cdf60ece3804abc52599c22b1f40f4323403c44d44fdfdd586475ca9813a858088ffbc1f233e9b180f061') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" && \
    php composer-setup.php && \
    php -r "unlink('composer-setup.php');" && \
    mv composer.phar /usr/local/bin/composer

RUN docker-php-ext-configure ldap && \
  docker-php-ext-install -j$(nproc) ldap && \
  mkdir /etc/ldap && \
  echo 'TLS_CACERT  /etc/ssl/certs/ca-certificates.crt' > /etc/ldap/ldap.conf

RUN chown -R www-data:www-data composer.json

# edwardspec/mediawiki-aws-s3 has old version of AWS SDK that causes problems
RUN composer require mediawiki/pluggable-auth jumbojett/openid-connect-php:0.9.10
COPY composer.local.json .
RUN composer update
