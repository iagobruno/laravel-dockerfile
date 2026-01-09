ENV ?= local
PORT ?= 8080

dev:
	docker compose -f docker-compose.yml -f docker-compose.development.yml up -d --build && \
	pnpm run dev

exec:
	docker exec -it $$(docker ps -q --filter "ancestor=laravel-app") \
		$(if $(filter-out $@,$(MAKECMDGOALS)),$(filter-out $@,$(MAKECMDGOALS)),bash)

build:
	docker compose build \
		--build-arg APP_ENV=$(ENV) \
		--build-arg APP_PORT=$(PORT) \
        server

deploy:
	make ENV=production build
	docker compose run --rm -it server php artisan migrate --force
	# Deploy new version without downtime -> github.com/wowu/docker-rollout
	docker rollout server
	docker image prune -f || true
	echo "DEPLOYED SUCCESSFULLY"

container-logs:
	docker logs --follow $$(docker ps -q --filter "ancestor=laravel-app")
