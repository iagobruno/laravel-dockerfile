FROM php:8.2-fpm

ARG APP_DIR=/var/www/html

COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer

# Install OS deps
RUN apt-get update -y && apt-get install -y --no-install-recommends \
  apt-utils \
  nginx \
  supervisor \
  git \
  zlib1g-dev \
  libzip-dev \
  zip \
  unzip \
  libpng-dev \
  libpq-dev \
  libxml2-dev

# Install php extensions
RUN docker-php-ext-install \
  pdo \
  pdo_mysql \
  pdo_pgsql \
  mysqli \
  pgsql \
  session \
  xml \
  zip \
  iconv \
  simplexml \
  bcmath \
  intl \
  pcntl \
  gd \
  fileinfo \
  opcache

RUN pecl install redis-5.3.7 \
    && docker-php-ext-enable redis

# Install NodeJS
RUN curl -sLS https://deb.nodesource.com/setup_18.x | bash - \
  && curl https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
  && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
  && apt-get update && apt-get install -y nodejs yarn

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

#########################################################################

ARG TZ=UTC
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

COPY . .

RUN chmod -R ugo+rw storage/logs bootstrap/cache
RUN rm -rf /etc/nginx/sites-enabled/* && rm -rf /etc/nginx/sites-available/*
COPY ./docker/nginx.conf /etc/nginx/sites-enabled/default.conf
COPY ./docker/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY ./docker/php.ini "$PHP_INI_DIR/extra-php.ini"
COPY ./docker/php-fpm.conf /etc/php8/php-fpm.d/www.conf
COPY ./docker/start-container /usr/local/bin/start-container
RUN chmod +x /usr/local/bin/start-container

EXPOSE 8000
ENTRYPOINT ["start-container"]
