all: build

# ENV can be dev or build

.PHONY: build
build:
	@docker build \
		--ssh default=${SSH_AUTH_SOCK} \
		-f Dockerfile.${ENV} \
		--progress plain \
		-t helloworld:${TAG} \
		.

