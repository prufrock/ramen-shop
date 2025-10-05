# Define the name and tag for your Docker image
IMAGE_NAME := ramen-shop
IMAGE_TAG := latest
GIT_COMMIT_TAG := $(shell git rev-parse --short HEAD)
DATE_TIME_TAG := $(shell date +%Y%m%d%H%M%S)

all: run

build: build/podman-out.txt
	

# Only do a podman build if changes to app.py or Dockerfile are newer than podman-out.txt(or it doesn't exist.
build/podman-out.txt: app.py Dockerfile
	@echo "--- Source code or Dockerfile changed. Rebuilding Docker image ---"
	mkdir build
	podman build -t $(IMAGE_NAME):$(IMAGE_TAG) -t $(IMAGE_NAME):$(GIT_COMMIT_TAG) -t $(IMAGE_NAME):$(DATE_TIME_TAG) . | tee build/podman-out.txt

# A phony target to clean up intermediate files
.PHONY: clean
clean:
	@echo "--- Cleaning up ---"
	podman compose down
	-podman images --format "{{.ID}}" --filter=reference=ramen-shop | xargs podman rmi -f
	-rm -r build

# A common target to start the application
.PHONY: run
run: build
	@echo "--- Running container ---"
	podman compose up --detach

# A phony target to test the application
.PHONY: test
test: run
	@echo "-- Testing the application  ---"
	sh wait-for-web.sh
	sh test.sh
