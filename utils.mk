UNAME_S := $(shell uname -s)
ifeq ($(UNAME_S),Linux)
	# pass
else ifeq ($(UNAME_S),Darwin)
	# pass
endif


define wget_if_not_exist
	@if [ ! -f $(1) ]; then \
		mkdir -p $(dir $(1)); \
		wget -O $(1) $(2); \
	fi
endef

sumake_version:
	@echo 2023.5.9
