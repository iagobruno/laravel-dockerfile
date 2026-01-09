Um projeto de exemplo de como usar queues e o scheduler do Laravel dentro do Docker e de quebra como usar o mesmo Dockerfile em desenvolvimento e em produção.

## How it works

1. O scheduler do Laravel adiciona um novo `ProcessJob` na fila a cada minuto. ([See](/routes/console.php))
2. O comando queue:listen processa a fila de jobs.
3. O `ProcessJob` cria um Log no banco de dados. ([See](/app/Jobs/ProcessJob.php#L36))
4. Quando um Log é criado o Eloquent dispara o evento `LogCreated` via websocket. ([See](/app/Models/Log.php#L33))
5. A página inicial recebe o evento `LogCreated` via websocket e atualiza a página. ([See](/resources/js/app.js#L6))

## Run Locally

Clone this repo and run commands in the order below:

```bash
composer install
cp .env.example .env # And edit the values
php artisan key:generate
```

Then start Docker containers using:

```bash
make dev
```

And run the migrations:

```bash
make exec
php artisan migrate
php artisan db:seed # Optional
```

### Front-end assets

The `make dev` command already starts Vite, but you can also start it manually.

Open another terminal tab and run the command below to compile front-end assets:

```bash
pnpm install
pnpm run dev
```

Now you can access the project at http://localhost in the browser.

### How to deploy to production

Run the [makefile](./makefile#L18) command below, which will execute the necessary commands to update the container without downtime:

```bash
git pull origin main
make ENV=production deploy
```

> Don't forget to configure the .env file in the root **outside** the container with the correct variables.

> You can customize the PORT with an environment variable too.
