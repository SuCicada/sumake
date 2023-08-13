
#$(call check_conda, my_env)
#conda_run = ???aa

CONDA_ENV:=my_env
aa = $(conda_run)
info:
	echo $(USE_CONDA)
	@echo "haha"
	echo $(aa)
	echo $(args)
