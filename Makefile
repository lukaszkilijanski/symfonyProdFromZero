-include .env

DOCKER_COMPOSE = docker compose

.PHONY: up

up:
	@if [ ! -f .env ]; then \
  		echo 'There are no .env - it will be created from .env.example'; \
  		sleep 3; \
  		cp .env.example .env; \
  	fi; \
	/bin/bash -c ' \
		. .env; \
		if [ -z "$$APP_ENV" ]; then \
			echo "Error: APP_ENV is not set. Please set APP_ENV in your .env file."; \
			exit 1; \
		elif [ "$$APP_ENV" = "dev" ]; then \
			echo "Using local environment"; \
			sleep 3; \
			$(DOCKER_COMPOSE) up -d --build; \
			docker exec doctor_symfony_php mkdir -p src/Entity; \
			docker exec doctor_symfony_php composer install; \
		elif [ "$$APP_ENV" = "testing" ]; then \
			echo "Using testing environment"; \
		elif [ "$$APP_ENV" = "staging" ]; then \
			echo "Using staging environment"; \
		elif [ "$$APP_ENV" = "prod" ]; then \
			echo "Using production environment"; \
			$(DOCKER_COMPOSE) -f docker-compose.prod.yml up; \
		else \
			echo "Error: APP_ENV $$APP_ENV is not a valid environment. Valid options are local, testing, staging, or production."; \
			exit 1; \
		fi \
	'