FROM php:5.6.31-apache

# Install mcrypt
RUN apt-get update &&\
  DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
  mcrypt php5-mcrypt libmcrypt-dev nano git &&\
  docker-php-ext-install mcrypt &&\
  apt-get clean && rm -rf /tmp/* /var/tmp/* && rm -rf /var/lib/apt/lists/*

RUN a2enmod rewrite

# OpenShift default security model is to run the container under random UID, so
# in order to drop the root user, we have to:
# 1. Run apache2 on a custom port (8080), a non-root user does not have access to port 80.
# 2. Make some directories world writeable.
# https://askubuntu.com/a/338239
# https://github.com/openshift/origin/issues/6629
RUN sed -i "s/Listen 80/Listen 8080/g" /etc/apache2/ports.conf &&\
  sed -i "s/<VirtualHost \*:80>/<VirtualHost \*:8080>/g" /etc/apache2/sites-enabled/000-default.conf
RUN mkdir -p /var/run/apache2 && chmod 777 -R /var/run/apache2 &&\
  mkdir -p /var/log/apache2 && chmod 777 -R /var/log/apache2 &&\
  mkdir -p /var/lock/apache2 && chmod 777 -R /var/lock/apache2
# Compare also with: https://github.com/sclorg/s2i-php-container/
