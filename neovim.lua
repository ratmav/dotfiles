-- Main neovim configuration file

-- Get the path to dotfiles directory
local dotfiles_path = vim.fn.expand("~/Source/dotfiles")

-- Load plugin definitions
dofile(dotfiles_path .. "/neovim/plugins/init.lua")

-- Load core Neovim configurations
dofile(dotfiles_path .. "/neovim/behavior.lua")
dofile(dotfiles_path .. "/neovim/display.lua")
dofile(dotfiles_path .. "/neovim/keybindings.lua")

-- Load plugin configurations with VimEnter to ensure plugins are available
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    -- Wait for plugins to be loaded
    vim.defer_fn(function()
      -- Get all plugin config files
      local plugin_dir = dotfiles_path .. "/neovim/plugins"
      local files = vim.fn.glob(plugin_dir .. "/*.lua", false, true)

      -- Skip init.lua
      for _, file in ipairs(files) do
        local basename = vim.fn.fnamemodify(file, ":t")
        if basename ~= "init.lua" then
          -- Try to load each plugin config
          pcall(dofile, file)
        end
      end
    end, 100)
  end,
  once = true
})