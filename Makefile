VERSION=`git rev-parse HEAD`
BUILD=`date +%FT%T%z`
LDFLAGS=-ldflags "-X main.Version=${VERSION} -X main.Build=${BUILD}"

.PHONY: help
help: ## - Show help message
	@printf "\033[32musage: make [target]\n\n\033[0m"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: build
build:	## - Build the docker image
	@printf "\033[32m\xE2\x9c\x93 Build the docker image \n\033[0m"
	@docker build -t exampleapp .

.PHONY: ls
ls: ## - List 'exampleapp' docker images
	@printf "\033[32m\xE2\x9c\x93 Losf pf exampleapp images !\n\033[0m"
	@docker images exampleapp

.PHONY: clean
clean: ## - Remove  'none' docker images
	@printf "\033[32m\xE2\x9c\x93 Remove none:none images !\n\033[0m"
	@docker rmi `docker images -f "dangling=true" -q`

.PHONY: run
run:	## - Run the docker image
	@printf "Run the exampleapp image\n"
	@docker run -d -p 8080:8080 --name exampleapp exampleapp

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
	@printf "\033[32m\xE2\x9c\x93 Run the exampleapp image\n\033[0m"
	@kubectl apply -f pod.yaml
