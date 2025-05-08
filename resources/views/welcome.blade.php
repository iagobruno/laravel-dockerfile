<!DOCTYPE html>
<html lang="{{ str_replace('_', '-', app()->getLocale()) }}">

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="csrf-token" content="{{ csrf_token() }}">

    <title>Laravel</title>

    @vite(['resources/css/app.css', 'resources/js/app.js'])
    <script type="module" src="https://cdn.skypack.dev/@github/relative-time-element"></script>

</head>

<body>
    <p>⚡ Página atualizada em tempo real. <span id="estimate"></span></p>

    <h1>Logs:</h1>
    <ol reversed>
        @foreach (\App\Models\Log::latest()->limit(500)->get() as $log)
            <x-log :$log />
        @endforeach
    </ol>

</body>

</html>
