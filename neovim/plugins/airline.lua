-- Vim-Airline plugin configuration

-- Behavior

-- Display
vim.g.airline_section_b =
  "%{fnamemodify(getcwd(), ':t\\')} %{airline#extensions#branch#get_head()}"
vim.g.airline_section_x = "l(%{line('.')}/%{line('$')}) c(%{virtcol('.')})"
vim.g.airline_section_y = "%{&fileformat}[%{&encoding}]"

-- Keybindings