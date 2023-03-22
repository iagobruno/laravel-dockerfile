<h1>Logs:</h1>

<ol>
    @foreach (\App\Models\Log::latest()->get() as $log)
        <li>{{ $log->message }} - {{ $log->created_at->diffForHumans() }}</li>
    @endforeach
</ol>
