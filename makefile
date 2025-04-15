IMAGE_NAME ?= laravel-app
CONTAINER_NAME ?= laravel-app-prod
ENV ?= local
PORT ?= 8080

start:
	docker compose up --build -d

bash:
	docker exec -it $(CONTAINER_NAME) bash

build:
	docker build --build-arg APP_ENV=$(ENV) --build-arg PORT=$(PORT) -t $(IMAGE_NAME) -f Dockerfile .

start-prod:
	docker rm -f $(CONTAINER_NAME) || true
	docker run -d -p $(PORT):$(PORT) -e PORT=$(PORT) -e APP_ENV=$(ENV) --name $(CONTAINER_NAME) $(IMAGE_NAME)
