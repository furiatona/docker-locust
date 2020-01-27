.PHONY: all build docker-nw run-pimock run-master run-slave

include envfile

VERSION		= latest
IMAGE       = $(REGISTRY)/$(SVC)
LOCUSTFILES_BASE= $(shell echo $$PWD/$(LOCUSTFILES))
SLAVE_RANGE	= $(shell seq 0 $(SLAVE_COUNT))

all: build docker-nw run-pimock run-master run-slave
run: docker-nw run-pimock run-master run-slave

build:	
	@set -e && \
	docker build -t $(IMAGE):$(VERSION) .

push:
	@set -e && \
	docker push $(IMAGE):$(VERSION)

docker-nw:
	@set -e && \
	docker network create -d bridge locustnw

run-pimock:
	@set -e && \
	docker run --rm --name=pimock --network=locustnw -itd \
	-p 8080:8080 furiatona/pimock:latest

run-master:
	@set -e && \
	docker run --rm --name=locust-master --network=locustnw -itd \
	-p 5557-5558:5557-5558 -p 8089:8089 \
	-v $(LOCUSTFILES_BASE):/locust \
	-e TARGET_HOST=$(TARGET_HOST) -e LOCUST_MODE=master $(IMAGE):$(VERSION)

run-slave:
	@set -e && \
	$(foreach f, $(SLAVE_RANGE), \
	docker run --rm --name=locust-slave$(f) --network=locustnw -itd \
	-v $(LOCUSTFILES_BASE):/locust -e TARGET_HOST=$(TARGET_HOST) \
	-e LOCUST_MODE=slave -e LOCUST_MASTER_HOST=locust-master $(IMAGE):$(VERSION);)

stop-slave:
	@set -e && \
	$(foreach i, $(SLAVE_RANGE), \
	docker stop locust-slave$(i);)

stop-all:
	@set -e && \
	docker stop pimock && \
	docker stop locust-master && \
	$(MAKE) stop-slave && \
	docker network rm locustnw

