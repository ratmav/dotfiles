-- Treesitter plugin configuration

-- Behavior
local treesitter = require('nvim-treesitter.configs')
treesitter.setup {
  ensure_installed = {
    "markdown", "rust", "python", "yaml", "hcl", "make", "go", "bash", "powershell", "lua"
  },
  sync_install = false,
  auto_install = true,
  highlight = {
    enable = true,
  },
  indent = {
    enable = true
  },
}

-- Display

-- Keybindings