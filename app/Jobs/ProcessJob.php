<?php

namespace App\Jobs;

use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldBeUnique;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Foundation\Bus\Dispatchable;
use Illuminate\Queue\InteractsWithQueue;
use Illuminate\Queue\SerializesModels;
use App\Models\Log;
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
        $this->onQueue('processing');
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

        $result = Process::run("sleep 1 && php artisan inspire");
        $emoji = $result->successful() ? '✅' : '❌';
        $output = $result->successful() ? $result->output() : 'Failed to process the command' ?? $result->errorOutput();
        $message = $emoji . ' ' . $output;

        $log->update(compact('message'));
    }
}
