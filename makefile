IMAGE_NAME ?= laravel-app
CONTAINER_NAME ?= laravel-app-prod

start:
	docker compose up --build -d

docker-bash:
	docker exec -it laravel-app bash

build:
	docker build --build-arg APP_ENV=production -t $(IMAGE_NAME) -f Dockerfile .

start-production:
	docker run --rm -p 80:8080 --name $(CONTAINER_NAME) $(IMAGE_NAME)
