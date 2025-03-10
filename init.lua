-- TODO: This file is geting long and should be split into multiple focused files.

-- plugins

-- plugin definitions
local paq = require "paq"
paq {
  -- plugin manager
  "savq/paq-nvim";

  -- workflow
  -- telescope and dependencies
  "nvim-lua/plenary.nvim";
  {"nvim-telescope/telescope.nvim", tag = "0.1.8"};
  "ratmav/marv";
  "ratmav/nerdtree"; -- TODO: replace with neotree.
  "ratmav/wisp";
  "ratmav/vim-bufkill"; -- TODO: lua?
  "ratmav/vim-maximizer"; -- TODO: lua?
  "ratmav/winresizer.vim"; -- TODO: lua?
  "ratmav/vim-fugitive"; -- TODO: lua?
  "sindrets/diffview.nvim"; -- TODO: lua?

  -- display
  "nvim-tree/nvim-web-devicons";
  "ratmav/vim-gitgutter"; -- TODO: lua?
  "ratmav/gruvbox"; -- TODO: lua?
  "ratmav/rainbow_parentheses.vim"; -- TODO: lua?
  "ratmav/vim-airline"; -- TODO: lua?

  -- treesitter
  {"nvim-treesitter/nvim-treesitter", build = ":TSUpdate"};
}

-- vim-airline
vim.g.airline_section_b =
  "%{fnamemodify(getcwd(), ':t\\')} %{airline#extensions#branch#get_head()}"
vim.g.airline_section_x = "l(%{line('.')}/%{line('$')}) c(%{virtcol('.')})"
vim.g.airline_section_y = "%{&fileformat}[%{&encoding}]"

-- rainbow parentheses
vim.cmd [[
  augroup rainbow_parentheses
    autocmd!
    autocmd BufEnter * RainbowParentheses
  augroup END
]]

-- telescope
-- ripgrep dependency check
local function check_ripgrep()
  if vim.fn.executable('rg') ~= 1 then
    vim.notify(
      "did not find ripgrep executable.",
      vim.log.levels.WARN
    )
  end
end

-- Check for ripgrep on startup
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    check_ripgrep()
  end,
})

local telescope = require('telescope')
telescope.setup {
  defaults = {
    file_ignore_patterns = { ".git/", "node_modules/" },
    vimgrep_arguments = {
      "rg",
      "--color=never",
      "--no-heading",
      "--with-filename",
      "--line-number",
      "--column",
      "--smart-case",
      "--hidden"
    },
  },
  pickers = {
    find_files = {
      hidden = true
    },
  }
}

-- nerdtree
vim.g.NERDTreeShowHidden = 1

-- treesitter
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

-- behavior

-- avoid vimception in terminal buffers (skip during plugin installation)
local error_msg = "Error: nvim in nvim terminal buffer"
if vim.env.NVIM and vim.env.NVIM_INSTALL_MODE ~= "1" then
  vim.cmd('echohl ErrorMsg')
  vim.cmd('echo "' .. error_msg .. '"')
  vim.cmd('echohl None')
  vim.cmd('sleep 3')
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

-- display

-- colors
vim.opt.termguicolors = true
vim.cmd [[colorscheme gruvbox]]
vim.cmd [[syntax on]]

-- highlight current line
vim.opt.cursorline = true

-- highlight search results
vim.opt.hlsearch = true
vim.opt.incsearch = true

-- display line numbers
vim.opt.number = true

-- always show the status line
vim.opt.laststatus = 2

-- embedded terminal
vim.cmd [[
  augroup terminal_settings
    autocmd!
    autocmd TermOpen * set bufhidden=hide
    autocmd TermOpen * setlocal nonumber norelativenumber
  augroup END
]]

-- bindings

-- window management
vim.g.winresizer_start_key = '<silent><C-w>r'
vim.keymap.set('n', '<C-w>z', ':MaximizerToggle<CR>', { silent = true })

-- buffer management
vim.keymap.set('n', '<C-b>h', ':bn<CR>', { silent = true })
vim.keymap.set('n', '<C-b>l', ':bp<CR>', { silent = true })
vim.keymap.set('n', '<C-b>r',
  ':edit!<bar>:echo "refreshed buffer"<CR>', { silent = true })
vim.keymap.set('n', '<C-b>q', ':BD!<CR>', { silent = true })

-- embedded terminal management
if vim.fn.has('win64') == 1 or vim.fn.has('win32') == 1 then
  vim.keymap.set('n', '<C-t>',
    ':terminal powershell -NoLogo<CR>', { silent = true })
else
  vim.keymap.set('n', '<C-t>', ':terminal<CR>', { silent = true })
end

vim.keymap.set('t', '<Esc>', '<C-\\><C-n>')
vim.keymap.set('t', '<A-h>', '<C-\\><C-N><C-w>h')
vim.keymap.set('t', '<A-j>', '<C-\\><C-N><C-w>j')
vim.keymap.set('t', '<A-k>', '<C-\\><C-N><C-w>k')
vim.keymap.set('t', '<A-l>', '<C-\\><C-N><C-w>l')
vim.keymap.set('i', '<A-h>', '<C-\\><C-N><C-w>h')
vim.keymap.set('i', '<A-j>', '<C-\\><C-N><C-w>j')
vim.keymap.set('i', '<A-k>', '<C-\\><C-N><C-w>k')
vim.keymap.set('i', '<A-l>', '<C-\\><C-N><C-w>l')
vim.keymap.set('n', '<A-h>', '<C-w>h')
vim.keymap.set('n', '<A-j>', '<C-w>j')
vim.keymap.set('n', '<A-k>', '<C-w>k')
vim.keymap.set('n', '<A-l>', '<C-w>l')

-- plugins (leader-driven)

-- use space as leader
vim.g.mapleader = " "

-- telescope
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<Leader>f', builtin.find_files, { desc = 'Find files' })
vim.keymap.set('n', '<Leader>b', builtin.buffers, { desc = 'Find buffers' })
vim.keymap.set('n', '<Leader>g', builtin.git_files, { desc = 'Find git files' })
vim.keymap.set('n', '<Leader>l', builtin.live_grep, { desc = 'Live grep' })

-- reload config
vim.keymap.set('n', '<Leader>r',
  ':source $MYVIMRC<bar>:edit!<bar>:echo "reloaded config"<CR>', { silent = true })

-- marv
vim.keymap.set('n', '<Leader>m',
  ':execute \'MarvToggle\'<CR>', { silent = true })

-- nerdtree
vim.keymap.set('n', '<Leader>n', ':NERDTreeToggle<CR>', { silent = true })

-- syfe
vim.keymap.set('n', '<Leader>w', ':execute \'Wisp\'<CR>', { silent = true })

-- diffview
vim.keymap.set('n', '<Leader>d',
  ':execute \'DiffviewOpen\'<CR>', { silent = true })
