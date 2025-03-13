-- Core Neovim keybindings (not specific to any plugin)

-- Use space as leader key
vim.g.mapleader = " "

-- Buffer management (without plugin dependencies)
vim.keymap.set('n', '<C-b>h', ':bn<CR>', { silent = true })
vim.keymap.set('n', '<C-b>l', ':bp<CR>', { silent = true })
vim.keymap.set('n', '<C-b>r', ':edit!<bar>:echo "refreshed buffer"<CR>', { silent = true })

-- Embedded terminal management
if vim.fn.has('win64') == 1 or vim.fn.has('win32') == 1 then
  vim.keymap.set('n', '<C-t>', ':terminal powershell -NoLogo<CR>', { silent = true })
else
  vim.keymap.set('n', '<C-t>', ':terminal<CR>', { silent = true })
end

-- Terminal navigation
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>')
vim.keymap.set('t', '<A-h>', '<C-\\><C-N><C-w>h')
vim.keymap.set('t', '<A-j>', '<C-\\><C-N><C-w>j')
vim.keymap.set('t', '<A-k>', '<C-\\><C-N><C-w>k')
vim.keymap.set('t', '<A-l>', '<C-\\><C-N><C-w>l')

-- Window navigation
vim.keymap.set('i', '<A-h>', '<C-\\><C-N><C-w>h')
vim.keymap.set('i', '<A-j>', '<C-\\><C-N><C-w>j')
vim.keymap.set('i', '<A-k>', '<C-\\><C-N><C-w>k')
vim.keymap.set('i', '<A-l>', '<C-\\><C-N><C-w>l')
vim.keymap.set('n', '<A-h>', '<C-w>h')
vim.keymap.set('n', '<A-j>', '<C-w>j')
vim.keymap.set('n', '<A-k>', '<C-w>k')
vim.keymap.set('n', '<A-l>', '<C-w>l')

-- Reload config
vim.keymap.set('n', '<Leader>r',
  ':source $MYVIMRC<bar>:edit!<bar>:echo "reloaded config"<CR>', { silent = true })
