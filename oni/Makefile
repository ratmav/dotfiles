OS := $(shell uname)
CWD := $(shell pwd)

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

.PHONY: manjaro_pull
manjaro_pull:
	docker pull manjarolinux/base


.PHONY: manjaro_shell
manjaro_shell:
	@docker run -it --rm \
		--name manjaro_oni_build \
		-v "$(CWD)"/build:/build \
		manjarolinux/base
