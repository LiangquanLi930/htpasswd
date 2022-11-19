IMG ?= htpasswd:latest
OUT_DIR ?= bin

.PHONY: help
help: ## Display this help.
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z_0-9-]+:.*?##/ { printf "  \033[36m%-22s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

.PHONY: htpasswd
htpasswd: ## build htpasswd
	go build -o $(OUT_DIR)/htpasswd .

.PHONY: docker-buildx-push
docker-build: ## docker buildx and push
	docker buildx build --platform linux/amd64,linux/arm64,linux/s390x,linux/ppc64le -t ${IMG} --push .
