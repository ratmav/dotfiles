-- Telescope plugin configuration

-- Behavior
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

-- Setup telescope
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

-- Display

-- Keybindings
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<Leader>f', builtin.find_files, { desc = 'Find files' })
vim.keymap.set('n', '<Leader>b', builtin.buffers, { desc = 'Find buffers' })
vim.keymap.set('n', '<Leader>g', builtin.git_files, { desc = 'Find git files' })
vim.keymap.set('n', '<Leader>l', builtin.live_grep, { desc = 'Live grep' })