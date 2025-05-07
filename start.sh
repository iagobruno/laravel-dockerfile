if [ "$ENV" = "production" ]; then
    php artisan octane:frankenphp --host=0.0.0.0 --port=$PORT --admin-port=2019 --max-requests=500
else
    php artisan serve --host=0.0.0.0 --port=$PORT
fi
