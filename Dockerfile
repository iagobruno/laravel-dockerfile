FROM php:8.2-fpm

ARG APP_DIR=/var/www/html
ARG TZ=UTC

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

WORKDIR /var/www/html

# Install OS deps
RUN apt-get update -y && apt-get install -y --no-install-recommends apt-utils \
  supervisor \
  nginx \
  curl \
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
  && pecl install redis

RUN docker-php-ext-enable redis

# Install composer
COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer

# Install NodeJS
RUN curl -sLS https://deb.nodesource.com/setup_18.x | bash - \
  && curl https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
  && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
  && apt-get update && apt-get install -y nodejs yarn

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

#########################################################################

COPY . .

COPY docker/start.sh /usr/local/bin/start
COPY docker/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY docker/nginx/default.conf /etc/nginx/conf.d/default.conf
COPY docker/php/custom.ini /usr/local/etc/php/conf.d/custom.ini
RUN chmod -R ugo+rw storage/logs bootstrap/cache
RUN chmod a+x /usr/local/bin/start

EXPOSE 80

CMD /usr/local/bin/start
