.PHONY: env-up env-down env-cleanup env-port-forward env-port-close migrate-create migrate-up migrate-down help

include .env
export

export PROJECT_ROOT := $(shell pwd)

.DEFAULT_GOAL := help

POSTGRES_URL=postgres://${POSTGRES_USER}:${POSTGRES_PASSWORD}@${POSTGRES_HOST}:${POSTGRES_PORT}/${POSTGRES_DB}?sslmode=disable

env-up:
	@docker compose up -d todoapp-postgres

env-down:
	@docker compose down todoapp-postgres port-forwarder

env-cleanup:
	@read -p "Очистить volume? Опасность утери данных. [y/N]: " ans; \
	if [ "$$ans" = "y" ]; then \
		docker compose down todoapp-postgres port-forwarder && \
		sudo rm -rf ${PROJECT_ROOT}/out/pgdata; \
	fi

env-port-forward:
	@docker compose up -d port-forwarder

env-port-close:
	@docker compose down port-forwarder

migrate-create:
	@if [ -z "$(seq)" ]; then \
		echo "Usage: make migrate-create seq=name_new_version_database"; \
		exit 1; \
	fi

	@docker compose run --rm todoapp-postgres-migrate \
		create -ext sql -dir /migrations -seq "$(seq)"

migrate-up:
	@docker compose run --rm todoapp-postgres-migrate \
		-path /migrations \
		-database $(POSTGRES_URL) \
		up

migrate-down:
	@docker compose run --rm todoapp-postgres-migrate \
		-path /migrations \
		-database $(POSTGRES_URL) \
		down

help:
	@echo "Доступные цели:"
	@echo "  env-up           - Запустить окружение       "
	@echo "  env-down         - Остановить окружение      "
	@echo "  env-cleanup      - Удалить данные окружения  "
	@echo "  env-port-forward - Открыть порт к базе       "
	@echo "  env-port-close   - Закрыть порт к базе       "
	@echo "  migrate-create   - Создать миграцию          "
	@echo "  migrate-up       - Применить миграции        "
	@echo "  migrate-down     - Откатить миграции         "
	@echo "  help             - Все доступные цели        "