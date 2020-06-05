FROM php:7.3-fpm-alpine
WORKDIR /var/www
EXPOSE 80
EXPOSE 443
ENV TIMEOUT=60
ENV PHP_EXT_DIR=/usr/lib/php7/modules

# Install core PHP extensions
RUN apk add --no-cache openssl nginx nginx-mod-http-headers-more su-exec postgresql-client libzip-dev unzip php7-igbinary php7-pecl-redis

COPY php php
COPY entry.sh entry.sh
RUN ["chmod", "755", "entry.sh"]
ENTRYPOINT ["sh", "entry.sh"]
