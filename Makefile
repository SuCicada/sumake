.PHONY: test

install:
	pip install . --verbose
	ls ~/.sumake

clean:
	rm -rf bin build sumake.egg-info

publish:
	python setup.py sdist
	twine upload dist/* --verbose

	mv ~/.sumake/utils.mk ~/.sumake/utils.mk.bak
	ln -s $(PWD)/utils.mk ~/.sumake/utils.mk
dev:
	$(eval sumake=$(shell command -v sumake))
	if [ -x "$(sumake)" ]; then rm $(sumake); \
		else echo $(eval sumake=$(shell conda info --base)/bin/sumake); fi
	@echo $(sumake)
	ln -s $(PWD)/bin/sumake $(sumake)
	chmod +x $(sumake)
	ls -l $(sumake)
test:
	make -f test.mk
