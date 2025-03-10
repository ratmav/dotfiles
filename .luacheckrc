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

-- Check code against these standards
std = {
  "lua51",
  "luajit"
}

-- Read globals
read_globals = {
  "io",
  "table",
  "package",
  "os"
}

-- Maximum line length for code
max_line_length = 100

-- Exclude third party modules
exclude_files = {
  ".git",
  ".luarocks",
  "lua_modules"
}
