<?php

use Illuminate\Support\Facades\Route;

Route::get('/', function () {
    return view('welcome');
});

Route::get('/test', function () {
    return env('APP_NAME');
});

Route::get('/inspire', function () {
    return Process::run("php artisan inspire")->output();
});
