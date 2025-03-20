-- Winresizer plugin configuration

-- Behavior
vim.g.winresizer_start_key = '<silent><C-w>r'

-- Display

-- Keybindings
vim.keymap.set('n', '<C-w>r', ':WinResizerStartResize<CR>', { silent = true })
