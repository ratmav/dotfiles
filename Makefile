OS := $(shell uname)
CWD := $(shell pwd)

.PHONY: debian_up
debian_up:
	@vagrant up debian


.PHONY: debian_ssh
debian_ssh:
	@vagrant ssh debian

.PHONY: debian_destroy
debian_destroy:
	@vagrant destroy debian
