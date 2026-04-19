SHELL := /bin/bash

# All Hugo and Go commands run inside the Docker image so the host doesn't need
# Hugo or the Go toolchain installed. See Dockerfile.dev / docker-compose.yml.

DC      := docker compose
HUGO    := $(DC) run --rm --service-ports hugo
HUGO_NP := $(DC) run --rm hugo
ENV_FILE := .env.deploy

.PHONY: help dev shell build clean lint mod-init mod-get mod-update mod-tidy new-studio deploy verify-deploy-env

help:
	@echo "Targets:"
	@echo "  dev          - Hugo dev server at http://localhost:1313 (live reload)"
	@echo "  shell        - Shell into the Hugo container"
	@echo "  build        - Production build into ./public"
	@echo "  clean        - Remove ./public and ./resources"
	@echo "  lint         - Strict build + (future) link/a11y checks"
	@echo "  mod-init     - One-time: hugo mod init <module-path>"
	@echo "  mod-get      - hugo mod get (use ARGS='<module>')"
	@echo "  mod-update   - hugo mod get -u ./..."
	@echo "  mod-tidy     - hugo mod tidy"
	@echo "  new-studio   - Scaffold a new studio (SLUG=foo)"
	@echo "  deploy       - rsync ./public to VPS (requires .env.deploy)"

dev:
	$(DC) up

shell:
	$(DC) run --rm --entrypoint sh hugo

build: clean
	$(HUGO_NP) --gc --minify --environment production

clean:
	rm -rf public resources/_gen

lint:
	$(HUGO_NP) --gc --minify --environment production --printI18nWarnings --printPathWarnings --printUnusedTemplates

mod-init:
	@if [ -z "$(MODULE)" ]; then echo "Usage: make mod-init MODULE=github.com/owner/repo"; exit 1; fi
	$(HUGO_NP) mod init $(MODULE)

mod-get:
	@if [ -z "$(ARGS)" ]; then echo "Usage: make mod-get ARGS='github.com/nunocoracao/blowfish/v2'"; exit 1; fi
	$(HUGO_NP) mod get $(ARGS)

mod-update:
	$(HUGO_NP) mod get -u ./...
	$(HUGO_NP) mod tidy

mod-tidy:
	$(HUGO_NP) mod tidy

new-studio:
	@if [ -z "$(SLUG)" ]; then echo "Usage: make new-studio SLUG=mi-estudio"; exit 1; fi
	$(HUGO_NP) new estudios/$(SLUG)/index.md

verify-deploy-env:
	@if [ ! -f $(ENV_FILE) ]; then \
		echo "Missing $(ENV_FILE). Copy .env.deploy.example and fill it in."; \
		exit 1; \
	fi

deploy: verify-deploy-env build
	@set -a; source $(ENV_FILE); set +a; \
	rsync -avz --delete \
		--exclude-from=deploy/rsync-exclude.txt \
		-e "ssh -p $${DEPLOY_PORT:-22} $${DEPLOY_KEY:+-i $$DEPLOY_KEY}" \
		public/ $$DEPLOY_USER@$$DEPLOY_HOST:$$DEPLOY_PATH/
