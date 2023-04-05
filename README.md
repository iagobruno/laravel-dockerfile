Um projeto de exemplo de como usar o Docker para criar vários containers para:

- Servidor web
- Agendamento de ações
- Processamento de filas
- Bando de dados
- Redis

Inspirado neste artigo https://laravel-news.com/laravel-scheduler-queue-docker.

## How it works

1. O scheduler do Laravel adiciona um novo `ProccessJob` na fila a cada minuto. ([See](/app/Console/Kernel.php#L17))
2. O Horizon processa a fila de jobs.
3. O `ProccessJob` cria um Log no banco de dados. ([See](/app/Jobs/ProccessJob.php#L36))
4. Quando um Log é criado o Eloquent dispara o evento `LogCreated` via websocket. ([See](/app/Models/Log.php#L33))
5. A página inicial recebe um evento `LogCreated` via websocket e atualiza a página. ([See](/resources/js/app.js#L6))

## Run Locally

Clone this repo and run commands in the order below:

```bash
composer install
cp .env.example .env # And edit the values
php artisan key:generate
```

Then start Docker containers using [Sail](https://laravel.com/docs/10.x/sail):

```bash
sail up -d
```

And run the migrations:

```bash
sail artisan migrate
sail artisan db:seed # Optional
```

### Front-end assets

Open another terminal tab and run the command below to compile front-end assets:

```bash
sail yarn install
sail yarn run dev
```

Now you can access the project at http://localhost in the browser.

## Production note

Em produção, é necessário iniciar somente o servidor, o scheduler e o horizon.

```
sail up laravel.test scheduler queues
```
