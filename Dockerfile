FROM php:8.2-cli

ARG APP_DIR=/var/www/html
ARG TZ=UTC

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Install OS deps
RUN apt-get update -y && apt-get install -y --no-install-recommends apt-utils \
  supervisor \
  nginx \
  cron \
  git \
  zip \
  unzip \
  zlib1g-dev \
  libzip-dev \
  libpng-dev \
  libjpeg-dev \
  libpq-dev \
  libxml2-dev

# Install php extensions
RUN docker-php-ext-install \
  dom \
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
  opcache \
  && pecl install redis swoole

RUN docker-php-ext-enable swoole redis

# Install composer
COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer

# Install NodeJS
RUN curl -sLS https://deb.nodesource.com/setup_18.x | bash - \
  && curl https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
  && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
  && apt-get update && apt-get install -y nodejs yarn \
  && yarn add chokidar

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

#########################################################################

COPY . .

RUN chmod -R ugo+rw storage/logs bootstrap/cache
COPY ./docker/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY ./docker/php.ini "$PHP_INI_DIR/conf.d/extra-php.ini"
COPY ./docker/opcache.ini "$PHP_INI_DIR/conf.d/opcache.ini"
COPY ./docker/start-container /usr/local/bin/start-container
COPY ./docker/start-server /usr/local/bin/start-server
RUN chmod +x /usr/local/bin/start-container /usr/local/bin/start-server

EXPOSE 8000
ENTRYPOINT ["start-container"]

HEALTHCHECK --start-period=5s --interval=2s --timeout=5s --retries=5 CMD php artisan octane:status || exit 1
