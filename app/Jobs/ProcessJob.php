<?php

namespace App\Jobs;

use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldBeUnique;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Foundation\Bus\Dispatchable;
use Illuminate\Queue\InteractsWithQueue;
use Illuminate\Queue\SerializesModels;
use App\Models\Log;
use Illuminate\Foundation\Inspiring;
use Illuminate\Support\Facades\Process;

class ProcessJob implements ShouldQueue
{
    use Dispatchable, InteractsWithQueue, Queueable, SerializesModels;

    /**
     * Create a new job instance.
     *
     * @return void
     */
    public function __construct()
    {
        //
    }

    /**
     * Execute the job.
     *
     * @return void
     */
    public function handle()
    {
        $log = Log::create([
            'message' => '⏳ Processing...'
        ]);

        // $result = Process::run("php artisan inspire");
        // $emoji = $result->successful() ? '✅' : '❌';
        // $output = $result->successful() ? $result->output() : 'Failed to process the command' ?? $result->errorOutput();
        // $message = $emoji . ' ' . $output;

        $message = '✅ ' . Inspiring::quote();

        $log->update(compact('message'));
    }
}
