<li id="log-{{ $log->id }}">
    {{ $log->message }}
    -
    <relative-time datetime="{{ $log->created_at->toIso8601String() }}">
        {{ $log->created_at->diffForHumans() }}
    </relative-time>
</li>
