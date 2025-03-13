-- Rainbow Parentheses plugin configuration

-- Behavior
vim.cmd [[
  augroup rainbow_parentheses
    autocmd!
    autocmd BufEnter * RainbowParentheses
  augroup END
]]

-- Display

-- Keybindings
