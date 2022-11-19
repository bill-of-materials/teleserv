# Inspired from microscaling
# https://github.com/microscaling/microscaling/blob/master/Makefile

default: build
build: docker_build output
clean: docker_clean
test: docker_scan
release: docker_build test output docker_push
run: dockercompose_up

DOCKER_IMAGE ?= uzer/teleserv
BUILD_VCS_REF = $(strip $(shell git rev-parse --short HEAD))

# APP version (Semver...)
APP_VERSION = $(strip $(shell cat VERSION))
ifndef APP_VERSION
	$(error You need to create a VERSION file to build a release)
endif

APP_VCS_REF = $(BUILD_VCS_REF)

# Find out if the working build directory is clean
GIT_NOT_CLEAN_CHECK = $(shell git status --porcelain)
ifneq (x$(GIT_NOT_CLEAN_CHECK), x)
	DOCKER_TAG_SUFFIX = -dirty
endif

# If we're releasing to Docker Hub, and we're going to mark it with the latest
# tag, it should exactly match a version release
ifeq ($(MAKECMDGOALS), release)
	# Use the version number as the release tag.
	DOCKER_TAG = $(APP_VERSION)-$(APP_VCS_REF)

# Don't push to Docker Hub if this isn't a clean repo
ifneq (x$(GIT_NOT_CLEAN_CHECK), x)
	$(error echo You are trying to release a build based on a dirty repo)
endif

else
	DOCKER_TAG = $(APP_VERSION)-$(APP_VCS_REF)$(DOCKER_TAG_SUFFIX)
endif

IMAGE_PRUNE_LIST = $(shell docker image ls $(DOCKER_IMAGE) -q)
ifneq (x$(IMAGE_PRUNE_LIST), x)
	IMAGE_PRUNE_CMD = docker image rm $(IMAGE_PRUNE_LIST)
else
	IMAGE_PRUNE_CMD = echo "no image to remove."
endif

docker_clean:
	docker system prune
	$(IMAGE_PRUNE_CMD)

docker_build:
	# Build Docker image
	docker build \
		--build-arg APP_VCS_REF=$(APP_VCS_REF) \
		--build-arg APP_VERSION=$(APP_VERSION) \
		--build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` \
		--build-arg BUILD_VCS_REF=$(BUILD_VCS_REF) \
		-t $(DOCKER_IMAGE):$(DOCKER_TAG) .

docker_push:
	# Tag image as latest
	docker tag $(DOCKER_IMAGE):$(DOCKER_TAG) $(DOCKER_IMAGE):latest
	# Push to DockerHub
	docker push $(DOCKER_IMAGE):$(DOCKER_TAG)
	docker push $(DOCKER_IMAGE):latest

docker_scan:
	docker scan $(DOCKER_IMAGE):$(DOCKER_TAG)

output:
	@echo $(DOCKER_IMAGE):$(DOCKER_TAG)

dockercompose_up: $(docker_build)
	DOCKER_IMAGE=$(DOCKER_IMAGE) DOCKER_TAG=$(DOCKER_TAG) docker-compose up
