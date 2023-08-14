# Gandi Dynamic DNS Makefile
#
# Copyright (c) Winston Astrachan 2022
#
help:
	@echo ""
	@echo "Usage: make COMMAND"
	@echo ""
	@echo "Gandi Dynamic DNS Makefile"
	@echo ""
	@echo "Commands:"
	@echo "  build        Build and tag image"
	@echo "  run          Start container in the background with locally mounted volume"
	@echo "  tail         Tail logs from running docker container"
	@echo "  stop         Stop and remove container running in the background"
	@echo "  clean        Mark image for rebuild"
	@echo "  delete       Delete image and mark for rebuild"
	@echo ""

build: .gandi-ddns.img

.gandi-ddns.img:
	docker build -t fdewasmes/gandi-ddns:latest .
	@touch $@

.PHONY: run
run: build
	docker run --name gandi-ddns -d --restart unless-stopped fdewasmes/gandi-ddns:latest

.PHONY: tail
tail:
	docker logs -f gandi-ddns

.PHONY: stop
stop:
	docker stop gandi-ddns
	docker rm gandi-ddns

.PHONY: clean
clean:
	rm -f .gandi-ddns.img

.PHONY: delete
delete: clean
	docker rmi -f fdewasmes/gandi-ddns
