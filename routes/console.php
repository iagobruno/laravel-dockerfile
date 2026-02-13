<?php

use App\Jobs\ProcessJob;
use Illuminate\Foundation\Inspiring;
use Illuminate\Support\Facades\Artisan;
use Illuminate\Support\Facades\Schedule;

// Stop when draining (stoping) the container
if (file_exists('/tmp/drain')) exit(0);

Artisan::command('inspire', function () {
    $this->comment(Inspiring::quote());
})->purpose('Display an inspiring quote')->hourly();

Schedule::job(new ProcessJob)->everyMinute();
