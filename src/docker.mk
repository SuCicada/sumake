# DOCKER_SERVICE_NAME
# DOCKER_HOST
# DOCKER_SERVICE_PORT
# DOCKER_RUN_OPTS
# DOCKER_BUILD_OPTS
# DOCKER_RUN_HOST // 如果DOCKER_RUN_HOST存在，则使用DOCKER_RUN_HOST，否则使用DOCKER_HOST
# DOCKER_SKIP_BUILD

DOCKER_REPOSITORY ?= sucicada

service_name ?= $(DOCKER_SERVICE_NAME)
REMOTE_DOCKER_HOST ?= $(DOCKER_HOST)

docker_image_name := $(DOCKER_REPOSITORY)/$(service_name):latest

remote_docker := unset DOCKER_HOST && docker
ifeq ($(REMOTE),true)
	remote_docker := DOCKER_HOST=$(REMOTE_DOCKER_HOST) docker
	ifneq ($(DOCKER_RUN_HOST),)
		remote_run_docker := DOCKER_HOST=$(DOCKER_RUN_HOST) docker
		remote_run_docker_on_other_host := true
	else
		remote_run_docker := DOCKER_HOST=$(REMOTE_DOCKER_HOST) docker
	endif
endif

DOCKER_RUN_OPTS := $(shell echo $(DOCKER_RUN_OPTS) | tr -d '"')

_docker-info:
	@echo DOCKER_SERVICE_NAME $(DOCKER_SERVICE_NAME)


docker-build:
	$(remote_docker) build -t $(docker_image_name) $(DOCKER_BUILD_OPTS) .

DOCKER_BUILD :=
ifneq ($(DOCKER_SKIP_BUILD),true)
DOCKER_BUILD := docker-build
endif

_docker-run: $(DOCKER_BUILD)
	@echo "DOCKER_HOST: $(DOCKER_HOST)"
	@echo "DOCKER_RUN_HOST: $(DOCKER_RUN_HOST)"
	@echo "remote_docker: $(remote_docker)"
	@echo "remote_run_docker: $(remote_run_docker)"
	@if [ "$(remote_run_docker_on_other_host)" = "true" ]; then \
		$(remote_docker) push $(docker_image_name); \
	fi

	$(remote_run_docker) stop $(service_name) || true
	$(remote_run_docker) rm $(service_name) || true
	$(remote_run_docker) run -d \
		$(if $(remote_run_docker_on_other_host), --pull always,) \
		$(if $(DOCKER_SERVICE_PORT), -p $(DOCKER_SERVICE_PORT):$(DOCKER_SERVICE_PORT),) \
		--name $(service_name) \
		$(if $(wildcard .env), --env-file .env,) \
		--restart=always \
		$(DOCKER_RUN_OPTS) \
		$(docker_image_name)

docker-run-remote:
	REMOTE=true sumake _docker-run

docker-run-local:
	sumake _docker-run

docker-build-remote:
	REMOTE=true sumake docker-build
docker-build-local:
	sumake docker-build

docker-push:
	docker push $(docker_image_name)
