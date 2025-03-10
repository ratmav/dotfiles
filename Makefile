.PHONY: lint install help

default: help

help:
	@echo "Available targets:"
	@echo "  lint     - Run luacheck to lint Lua files"
	@echo "  install  - Install luacheck dependency"
	@echo "  help     - Show this help message"

install:
	@echo "Installing luacheck..."
	@if command -v luarocks > /dev/null; then \
		luarocks install --local luacheck; \
	else \
		echo "Error: LuaRocks not found. Please install LuaRocks first."; \
		exit 1; \
	fi

lint:
	@echo "Linting Lua files..."
	@if command -v luacheck > /dev/null; then \
		luacheck .; \
	else \
		echo "Error: luacheck not found. Run 'make install' first."; \
		exit 1; \
	fi
