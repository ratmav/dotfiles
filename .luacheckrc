-- Use maximum set of standard Lua definitions
std = "max"

-- Global objects defined by Neovim and WezTerm
globals = {
  "vim",
  "wezterm",
  "require"
}

-- Don't report unused self arguments of methods
self = false

-- Rerun tests only if their modification time changed
cache = true

-- Maximum line length for code
max_line_length = 100

-- Exclude third party modules
exclude_files = {
  ".git",
  ".luarocks",
  "lua_modules"
}
