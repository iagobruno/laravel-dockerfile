#!/bin/sh

ENV=${APP_ENV:-production}
echo "Starting container in [$ENV] mode"

if [ ! -f "vendor/autoload.php" ]; then
    composer install --optimize-autoloader --no-progress --no-interaction
fi

if [ ! -d "node_modules" ]; then
    yarn install
fi

if [ ! -f ".env" ]; then
    echo "Creating env file..."
    cp .env.example .env
fi

if [ "$ENV" = "production" ]; then
    echo "Caching Laravel configs and assets..."
    (php artisan config:cache && php artisan route:cache && php artisan view:cache && php artisan event:cache)

    yarn run build

    php artisan migrate --force
fi

# Start!
exec /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf
