default:
	@IFS=$$'\n' ; \
    help_lines=(`fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//'`); \
    for help_line in $${help_lines[@]}; do \
        IFS=$$'#' ; \
        help_split=($$help_line) ; \
        help_command=`echo $${help_split[0]} | sed -e 's/^ *//' -e 's/ *$$//'` ; \
        help_info=`echo $${help_split[2]} | sed -e 's/^ *//' -e 's/ *$$//'` ; \
        printf "%-30s %s\n" $$help_command $$help_info ; \
    done

clean-pyc: ## Delete all py[co] files and __pycache__ dir
	find . -type f -name "*.py[co]" -delete
	find . -type d -name "__pycache__" -delete

clean-build:  ## Removes python build and cache dirs
	rm --force --recursive build/
	rm --force --recursive dist/
	rm --force --recursive *.egg-info

bootstrap:  ## Install required system packages for this project
	pip install --user -U pipenv pre-commit
	pre-commit install
	curl -o \
		/usr/local/bin/circleci \
		https://circle-downloads.s3.amazonaws.com/releases/build_agent_wrapper/circleci &&\
		chmod +x /usr/local/bin/circleci

install: ## Install project deps
	pipenv install --dev

install-deploy: ## Same as "install" but verify Pipfile.lock is up-to-date
	pipenv install --deploy

install-deploy-dev: ## Same as "install-deploy" but also install dev deps
	pipenv install --deploy --dev

clean-env: ## Delete the virtual env
	rm -rf .venv

format: ## Run Black formatter
	pipenv run black ms tests

lint: ## Check formatting with Black
	pipenv run black --check ms tests

test: ## Run unit tests
	pipenv run pytest --cov ms --junitxml test-results/junit/results.xml tests

gen-doc: ## Generate Sphinx documentation
	@echo "Not implemented"

run-local: ## Start app locally
	pipenv run python ms/app.py

docker-build: ## Build docker container
	docker build -t ms-exp .

docker-push: ## Login, tag and push latest image
	docker login -u ${DOCKER_AUTH_USERNAME} -p ${DOCKER_AUTH_PASSWORD}
	docker tag ms-exp:latest marcdufresne/ms-exploration:latest
	docker push marcdufresne/ms-exploration:latest

docker-run: ## Run docker container
	docker run -d -p 8000:8000 --name ms-exp ms-exp

docker-clean: ## Kill and remove app container
	docker kill ms-exp
	docker rm ms-exp

circleci-validate: ## Validate CircleCI config file
	circleci config validate
