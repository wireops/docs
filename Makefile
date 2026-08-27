VENV := .venv
PYTHON := $(VENV)/bin/python
MKDOCS := $(VENV)/bin/mkdocs

.PHONY: help install serve build clean

help:
	@echo "make install  - create .venv and install docs dependencies"
	@echo "make serve    - run mkdocs dev server at http://127.0.0.1:8000"
	@echo "make build    - build the static site into ./site (strict)"
	@echo "make clean    - remove ./site"

$(VENV)/bin/activate: requirements.txt
	python3 -m venv $(VENV)
	$(PYTHON) -m pip install --upgrade pip
	$(PYTHON) -m pip install -r requirements.txt
	touch $(VENV)/bin/activate

install: $(VENV)/bin/activate

serve: install
	$(MKDOCS) serve

build: install
	PATH="$(abspath $(VENV)/bin):$$PATH" ./scripts/build.sh

clean:
	rm -rf site
