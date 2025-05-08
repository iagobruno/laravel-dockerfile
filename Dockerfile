FROM dunglas/frankenphp:php8.3-bookworm

ARG PORT
ARG ENV=local
ARG TZ=UTC

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Install composer
COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer
# Install NodeJS
COPY --from=node:20-slim /usr/local/bin /usr/local/bin
# Install NPM
COPY --from=node:20-slim /usr/local/lib/node_modules /usr/local/lib/node_modules
# Install Yarn
RUN npm install -g --force yarn pnpm@latest-10

# Install extensions
RUN apt-get update -y && apt-get install -y --no-install-recommends apt-utils \
  supervisor \
  cron \
  curl \
  git \
  make \
  zlib1g-dev \
  libzip-dev \
  libpng-dev \
  libjpeg-dev \
  libpq-dev \
  libxml2-dev

RUN install-php-extensions \
  pcntl \
  pdo_pgsql \
  pgsql \
  bcmath \
  intl
#   && pecl install redis

# RUN docker-php-ext-enable redis

COPY . /app

RUN if [ "$ENV" = "production" ]; then \
    composer install --optimize-autoloader --no-progress --no-interaction && \
    pnpm install && \
    pnpm run build && \
    sed -i 's/^DB_HOST=.*/DB_HOST=pgsql/' .env && \
    php artisan optimize \
  ;fi

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
RUN echo 'alias artisan="php artisan"' >> ~/.bashrc && \
  echo 'alias art="php artisan"' >> ~/.bashrc && \
  echo 'alias tinker="php artisan tinker"' >> ~/.bashrc

EXPOSE 8080

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
