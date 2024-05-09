UNAME_S := $(shell uname -s)
ifeq ($(UNAME_S),Linux)
# pass
else ifeq ($(UNAME_S),Darwin)
# pass
endif

.PHONY: wget_if_not_exist

define wget_if_not_exist
@if [ ! -f $(1) ]; then \
	mkdir -p $(dir $(1)); \
	wget -O $(1) $(2); \
else \
	echo "File already exists: $(1) "; \
fi
endef

#sumake_version:
#	@echo 2023.5.9

# $(call check_conda, my_env)
#define check_conda
#$(eval conda_env := $(1)) \
#if [ $(USE_CONDA) != false ]; then \
#$(eval CONDA_RUN := conda run -n $(conda_env) --no-capture-output); \
#fi
#endef
# 这一行放到里面就不起作用了，我也不知道为什么
export conda_run = conda run -n $(CONDA_ENV) --no-capture-output
ifeq ($(USE_CONDA),false)
	export conda_run=
endif
#if $(filter $(conda) $(USE_CONDA),false),, $(eval CONDA_RUN := conda run -n $(conda_env) --no-capture-output))
USERNAME ?= $(shell whoami)
DEPLOY_USERNAME ?= $(USERNAME)

DEPLOY_PORT ?= 22
DEPLOY_HOST ?= $(DEPLOY_USERNAME)@$(DEPLOY_ADDRESS)
# define upload
# 	rsync -av  \
# 		--rsh="ssh -o StrictHostKeyChecking=no -p $(DEPLOY_PORT)" \
# 		$(1) \
# 		${DEPLOY_HOST}:$(patsubst %,%, $(if $(2),$(2),~/$(patsubst %,%,$(1))))
# endef

# define command
# 	ssh -p $(DEPLOY_PORT) $(DEPLOY_HOST) $(1)
# endef


ENVIRONMENT =  @export DEPLOY_PORT=$(DEPLOY_PORT); \
                export DEPLOY_HOST=$(DEPLOY_HOST); \
                export DEPLOY_USERNAME=$(USERNAME); \
                export DEPLOY_PASSWORD=$(DEPLOY_PASSWORD); \

deploy_path := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
python = $(ENVIRONMENT) python
call_utils = $(python) $(deploy_path)/utils.py

define upload
	$(call_utils) upload $(1) $(2)
endef

define upload_root
	$(call_utils) upload --root $(1) $(2)
endef

define download
	$(call_utils) download $(1) $(2)
endef



define command
	$(call_utils) ssh '$(1)'
endef
define ssh
	$(call_utils) ssh '$(1)'
endef
define ssh_root
	$(call_utils) ssh --root '$(1)'
endef

# special a script to run on remote server
define ssh_file
	echo '$(2)'
	$(call_utils) ssh --file $(1) '$(2)'
endef
define ssh_root_file
	$(call_utils) ssh --root --file $(1) '$(2)'
endef
