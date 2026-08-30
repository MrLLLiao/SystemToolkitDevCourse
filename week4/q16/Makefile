.PHONY: check build clean

check:
	bash check.sh

build:
	python3 -m build --no-isolation

clean:
	rm -rf build dist src/*.egg-info src/greetlab_*.egg-info .pytest_cache .ruff_cache
