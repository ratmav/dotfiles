OS := $(shell uname)
CWD := $(shell pwd)

.PHONY: debian_pull
debian_pull:
	docker pull debian:buster


.PHONY: debian_shell
debian_shell:
	@docker run -it --rm \
		--name debian_oni_build \
		-v "$(CWD)"/build:/build \
		debian:buster

.PHONY: macos_pull
macos_pull:
	docker pull sickcodes/docker-osx:auto

.PHONY: shell_macos
shell_macos:
	@if [[ "$(OS)" == "Darwin" ]]; then \
		echo "docker is virtualized on macos. use a linux host."; \
	else \
		docker run -it --rm \
			--name macos_oni_build \
			--device /dev/kvm \
			-p 50922:10022 \
			-v "$(CWD)"/build:/build \
			sickcodes/docker-osx:auto; \
	fi
