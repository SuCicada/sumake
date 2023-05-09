install:
	pip install . --verbose
	ls ~/.sumake
clean:
	rm -rf bin build sumake.egg-info
