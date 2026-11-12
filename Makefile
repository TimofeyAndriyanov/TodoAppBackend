.PHONY: env-up env-down env-cleanup env-port-forward env-port-close migrate-create migrate-up migrate-down help

include .env
export

.DEFAULT_GOAL := help

POSTGRES_URL=postgres://${POSTGRES_USER}:${POSTGRES_PASSWORD}@${POSTGRES_HOST}:${POSTGRES_PORT}/${POSTGRES_DB}?sslmode=disable

env-up:
	@docker compose up -d todoapp-postgres

env-down:
	@docker compose down todoapp-postgres

env-cleanup:

env-port-forward:
	@docker compose up -d port-forwarder

env-port-close:
	@docker compose down port-forwarder

migrate-create:
migrate-up:
migrate-down:

help:
	@echo "Доступные цели:"
	@echo "  env-up           - Запустить окружение"
	@echo "  env-down         - Остановить окружение"
	@echo "  env-cleanup      - Удалить данные окружения"
	@echo "  env-port-forward - Открыть порт к базе"
	@echo "  env-port-close   - Закрыть порт к базе"
	@echo "  migrate-create   - Создать миграцию"
	@echo "  migrate-up 	  - Применить миграции"
	@echo "  migrate-down 	  - Откатить миграции"