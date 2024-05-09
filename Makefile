.PHONY: test
# Makefile


install:
	rm -f ~/.sumake/*
	python setup.py install --verbose 
	ls ~/.sumake
	pip install . --verbose


clean:
	rm -rf bin build sumake.egg-info dist
	rm -f version.py
dist: clean
	python setup.py sdist
	$(eval VERSION = $(shell cat version.txt))
	tar -ztvf dist/sumake-$(VERSION).tar.gz

publish: clean dist
	#mv dist/sumake-$(VERSION).tar.gz dist/sumake-$(VERSION)-$(shell date +%s).tar.gz
	twine upload dist/* --verbose

dev:
	mv ~/.sumake/utils.mk ~/.sumake/utils.mk.bak
	ln -s $(PWD)/utils.mk ~/.sumake/utils.mk

	$(eval sumake=$(shell command -v sumake))
	if [ -x "$(sumake)" ]; then rm $(sumake); \
		else echo $(eval sumake=$(shell conda info --base)/bin/sumake); fi
	@echo $(sumake)
	ln -s $(PWD)/bin/sumake $(sumake)
	chmod +x $(sumake)
	ls -l $(sumake)

test:
	make -f test.mk
