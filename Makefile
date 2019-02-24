build-files:
	python3 setup.py build_ext --inplace

run: build-files
	python3 run.py
