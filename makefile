IMAGE_NAME ?= laravel-app
CONTAINER_NAME ?= laravel-app
ENV ?= local
PORT ?= 8080

dev:
	docker compose -f docker-compose.yml -f docker-compose.development.yml up -d --build && \
	pnpm run dev

bash:
	docker exec -it $(CONTAINER_NAME) bash

build:
	docker build \
		--build-arg ENV=$(ENV) \
		--build-arg PORT=$(PORT) \
		-t $(IMAGE_NAME) \
		-f Dockerfile .

start:
	docker rm -f $(CONTAINER_NAME) || true
	docker run -d \
		-e PORT=$(PORT) \
		-e ENV=$(ENV) \
		-p $(PORT):$(PORT) \
		-p 80:$(PORT) \
		-p 443:433 \
		--network laravel-dockerfile_laravel \
		--name $(CONTAINER_NAME) \
		$(IMAGE_NAME)
	docker image prune -f || true
# Configurar para usar mais recursos da VPS conforme necessário e disponibilidade
# --memory="4g" \
# --cpus="1" \
