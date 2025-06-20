-- avoid vimception in terminal buffers (skip during plugin installation)
local error_msg = "Error: nvim in nvim terminal buffer"
if vim.env.NVIM and #vim.api.nvim_list_uis() > 0 then
  vim.cmd('echohl ErrorMsg')
  vim.cmd('echo "' .. error_msg .. '"')
  vim.cmd('echohl None')
  vim.cmd('sleep 2')
  vim.cmd('cquit')
end

-- use the system clipboard by default
vim.opt.clipboard = "unnamedplus"

-- no mouse
vim.opt.mouse = ""

-- no backups
vim.opt.backup = false
vim.opt.writebackup = false

-- no swap
vim.opt.swapfile = false

-- code folding
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldcolumn = "2"
vim.opt.foldlevelstart = 100

-- autoindent width
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2

-- backspace should behave like other applications
vim.opt.backspace = "indent,eol,start"

-- disable sql omnicomplete, which is tied to <c-c> for some reason
vim.g.omni_sql_no_default_maps = 1

-- disable autocommenting
vim.cmd [[
  autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
]]

-- Disable tag plugins (Ctrl-] is used as universal escape key)
vim.g.loaded_tagstack = 1
vim.g.loaded_tags = 1
