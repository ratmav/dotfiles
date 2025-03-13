-- NERDTree plugin configuration

-- Behavior
vim.g.NERDTreeShowHidden = 1

-- Display

-- Keybindings
vim.keymap.set('n', '<Leader>n', ':NERDTreeToggle<CR>', { silent = true })