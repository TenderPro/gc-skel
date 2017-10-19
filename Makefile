# dcape gitbook Makefile

SHELL               = /bin/bash
CFG                ?= .env

# Run recreate on deploy
APP_BUILD          ?= yes

# DOCUMENT_ROOT для nginx
NGINX_ROOT         ?= html

# имя сайта для контейнера
APP_SITE           ?= doc.dev.lan

# идентификатор проекта
PROJECT            ?= book

# значения для make book-serve
SERVER_ADDR=127.0.0.1
SERVER_PORT=4000
RELOAD_PORT=35729

# Docker-compose project name (container name prefix)
PROJECT_NAME       ?= iac
# dcape containers name prefix
DCAPE_PROJECT_NAME ?= dcape
# dcape network attach to
DCAPE_NET          ?= $(DCAPE_PROJECT_NAME)_default

# build docker image
BUILD_IMAGE       ?= tenderpro/gitbook:0.5

define CONFIG_DEF
# project config file, generated by make $(CFG)
APP_SITE=$(APP_SITE)

PROJECT=$(PROJECT)

# Run recreate on deploy
APP_BUILD=$(APP_BUILD)
# Docker-compose project name (container name prefix)
PROJECT_NAME=$(PROJECT_NAME)
# dcape network attach to
DCAPE_NET=$(DCAPE_NET)

endef
export CONFIG_DEF

# if exists - load old values
-include $(CFG).bak
export

-include $(CFG)
export

.PHONY: all start stop stopall build serve book-cmd book-build

all: help

## настройка контейнера
setup: $(CFG) dirs

dirs:
	@[ -L html ] || ln -s _book html

# ------------------------------------------------------------------------------
# webhook commands

start: $(CFG) build reup

start-hook: $(CFG) build reup

stop: down

update: build

# ------------------------------------------------------------------------------
# docker commands

## старт контейнеров
up:
up: CMD=up -d
up: dc

## рестарт контейнеров
reup:
reup: CMD=up --force-recreate -d
reup: dc

## остановка и удаление всех контейнеров
down:
down: CMD=rm -f -s
down: dc

# ------------------------------------------------------------------------------
# сборка

# Use: CMD=ls make nodejs
## compile pgm packages
book-cmd:
	@[[ $$APP_BUILD == "yes" ]] && docker run --rm -it \
	  -v /etc/timezone:/etc/timezone:ro \
	  -v /etc/localtime:/etc/localtime:ro \
	  -v $$PWD:/home/app \
	  -w /home/app \
	  -p $(SERVER_ADDR):$(RELOAD_PORT):$(RELOAD_PORT) \
	  -p $(SERVER_ADDR):$(SERVER_PORT):$(SERVER_PORT) \
	  --name $(PROJECT) \
	  --env=API_URL=$$API_SITE \
	  --env=AUTH_SERVER=$$AUTH_SERVER \
	  --env=MEDIA_URL=$$MEDIA_SITE \
	  --env=PROJECT=$$PROJECT \
	  --env=DEFAULT_THEME=$$SKIN_TAG \
	  --env=GA_ACCOUNT=$$GA_ACCOUNT \
	  $(BUILD_IMAGE) \
	  bash ./build.sh $(BOOK_CMD) $(PROJECT) || echo "APP_BUILD is $$APP_BUILD (need 'yes')"

# ------------------------------------------------------------------------------
# Gitbook

book-init: BOOK_CMD = init
book-init: book-cmd

book-install: BOOK_CMD = install
book-install: book-cmd

book-serve: BOOK_CMD = serve
book-serve: book-cmd

book-html: BOOK_CMD = html
book-html: book-cmd

book-pdf: BOOK_CMD = pdf
book-pdf: book-cmd

book-epub: BOOK_CMD = epub
book-epub: book-cmd

book-all: BOOK_CMD = all
book-all: book-cmd

build: book-all dirs

# ------------------------------------------------------------------------------

# $$PWD используется для того, чтобы текущий каталог был доступен в контейнере по тому же пути
# и относительные тома новых контейнеров могли его использовать
## run docker-compose
dc: docker-compose.yml
	@docker run --rm  \
	  -v /var/run/docker.sock:/var/run/docker.sock \
	  -v $$PWD:$$PWD \
	  -w $$PWD \
	  docker/compose:1.14.0 \
	  -p $$PROJECT_NAME \
	  $(CMD)

# ------------------------------------------------------------------------------

$(CFG):
	@[ -f $@ ] || { echo "$$CONFIG_DEF" > $@ ; echo "Warning: Created default $@" ; }

# ------------------------------------------------------------------------------

## List Makefile targets
help:
	@grep -A 1 "^##" Makefile | less

##
## Press 'q' for exit
##
