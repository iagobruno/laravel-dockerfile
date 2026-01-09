if [ "$1" = "serve" ]; then

    php artisan octane:frankenphp \
        --host=0.0.0.0 \
        --port=$APP_PORT \
        --admin-port=2019 \
        --max-requests=500 \
        $( [ "$APP_ENV" = "local" ] && echo "--watch" );


elif [ "$1" = "queue" ]; then

    if [ "$APP_ENV" = "production" ]; then
        php artisan queue:work --sleep=3 --tries=3 --verbose
    else
        php artisan queue:listen --sleep=3 --tries=3 --verbose
    fi

fi
