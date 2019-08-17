VERSION=`git rev-parse HEAD`
BUILD=`date +%FT%T%z`
LDFLAGS=-ldflags "-X main.Version=${VERSION} -X main.Build=${BUILD}"

.PHONY: help
help: ## - Show help message
	@printf "usage: make [target]\n\n"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: build
build:	## - Build the docker image
	@printf "Build the docker image\n"
	@docker build -t exampleapp .

.PHONY: ls
ls: ## - List 'exampleapp' docker images
	@printf "List of images!\n"
	@docker images exampleapp

.PHONY: clean
clean: ## - Remove  'none' docker images
	@printf "Remove none:none images!\n"
	@docker rmi `docker images -f "dangling=true" -q`

.PHONY: run
run:	## - Run the docker image
	@printf "Run the exampleapp image\n"
	@docker run --rm -d -p 80:8080 --name exampleapp exampleapp

.PHONY: push-to-gcp
push-to-gcp:	## - Push docker image to gcr.io container registry
	@gcloud auth application-default login
	@gcloud auth configure-docker
	@docker push gcr.io/evgeniy.suslov/exampleapp:$(VERSION)

.PHONY: test
test:	## - Run tests
	@printf "Run tests\n"
	@go test -v

.PHONY: kube-deploy
kube-deploy:	## - Deploy to kubernetes
	@printf "Run the exampleapp image\n"
	@kubectl apply -f pod.yaml
