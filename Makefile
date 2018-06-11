default:
	@echo "Makefile Usage"
	@echo " clean-pyc"
	@echo " 	Removes all .pyc, .pyo files and __pycache__ dir."
	@echo " clean-build"
	@echo " 	Removes build, dist and *.egg-info dirs."
	@echo " bootstrap"
	@echo " 	Installs project's setup requirements."
	@echo " install"
	@echo " 	Creates a virtualenv and install project dependencies."
	@echo " install-deploy"
	@echo " 	Same as 'install' but making sure the Pipfile.lock is up-to-date."
	@echo " clean-env"
	@echo " 	Delete virtualenv directory."
	@echo " format"
	@echo " 	Runs black formatter on project code."
	@echo " lint"
	@echo " 	Runs black lint check on project code."
	@echo " test"
	@echo " 	Runs unit tests with coverage."
	@echo " gen-doc"
	@echo " 	Generates sphinx documentation."
	@echo " run-local"
	@echo " 	Runs project locally."
	@echo " docker-build"
	@echo " 	Builds the project's Dockerfile."
	@echo " docker-run"
	@echo " 	Runs the project inside a docker container."
	@echo " docker-clean"
	@echo " 	Kills and removes the project container."

clean-pyc:
	find . -type f -name "*.py[co]" -delete
	find . -type d -name "__pycache__" -delete

clean-build:
	rm --force --recursive build/
	rm --force --recursive dist/
	rm --force --recursive *.egg-info

bootstrap:
	pip install -U pipenv pre-commit
	pre-commit install

install:
	pipenv install --dev

install-deploy:
	pipenv install --deploy

clean-env:
	rm -rf .venv

format:
	pipenv run black -l 80 --py36 ms tests

lint:
	pipenv run black -l 80 --py36 --check ms tests

test:
	pipenv run pytest --cov tests

gen-doc:
	@echo "Not implemented"

run-local:
	pipenv run python ms/app.py

docker-build:
	docker build -t ms-exp .

docker-run:
	docker run -d -p 8000:8000 --name ms-exp ms-exp

docker-clean:
	docker kill ms-exp
	docker rm ms-exp
