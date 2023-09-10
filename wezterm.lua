--[[
  Behavior:
    each wez tab starts neovim by default, if neovim is installed and in path.

    if neovim is not installed:
      * on windows:
        * use powershell by default.
        * include powershell in the launch menu.
        * include git bash in the launch menu if git is installed.
      * on *nix:
        * use bash by default.

  Keybindings:
    * Ctrl-e:   leader ("e" for terminal (e)mulator).
    * leader-n: new wezterm tab.
    * leader-h: select tab on left.
    * leader-l: select tab on right.
    * leader-c: activate wez copy mode, similar to vi-style visual mode. esc to exit.
    * leader-y: yank text from wez tab.
    * leader-p: paste text from wez tab.
]]

local wezterm = require 'wezterm';

config = {
  -- display
  color_scheme = "Gruvbox dark, medium (base16)",
  font_size = 16,
  warn_about_missing_glyphs = false,

  -- behavior
  disable_default_key_bindings = true,
  leader = { key="e", mods="CTRL" },
  keys = {
    {
      key="n",
      mods="LEADER",
      action=wezterm.action{SpawnTab="DefaultDomain"},
    },
    {
      key="h",
      mods="LEADER",
      action=wezterm.action{ActivateTabRelative=-1},
    },
    {
      key="l",
      mods="LEADER",
      action=wezterm.action{ActivateTabRelative=1},
    },
    {
      key="c",
      mods="LEADER",
      action="ActivateCopyMode",
    },
    {
      key="y",
      mods="LEADER",
      action=wezterm.action{CopyTo="Clipboard"},
    },
    {
      key="p",
      mods="LEADER",
      action=wezterm.action{PasteFrom="Clipboard"},
    },
  },
}

function add_neovim_to_launch_menu(launch_menu)
  add_to_launch_menu(launch_menu, "neovim",{"nvim"})
end

function add_git_bash_to_launch_menu(launch_menu)
  -- can't just get-command, at least not in a straightforward way.
  local git_bash_path = "C:\\Program Files\\Git\\bin\\bash.exe"
  if io.open(git_bash_path) ~= nil then
    add_to_launch_menu(launch_menu, "git bash",{git_bash_path})
  end
end

function add_to_launch_menu(launch_menu, label, args)
  table.insert(launch_menu, {
    label = label,
    args = args,
  })
end

function add_powershell_to_launch_menu(launch_menu)
  add_to_launch_menu(launch_menu, "powershell",{"powershell", "-NoLogo"})
end

function has_neovim(windows)
  -- determine check command based on os.
  local check_command
  if windows then
    check_command = '(Get-Command nvim -ErrorAction "SilentlyContinue").Path'
  else
    check_command = 'type -P nvim'
  end

  -- check for neovim install.
  local check = io.popen(check_command)
  local result = check:read('*a'); check:close()

  if result ~= nil then
    return true
  else
    return false
  end
end

function is_windows()
  -- package.config:sub(1,1) returns '\' for windows and '/' for *nix.
  if package.config:sub(1,1) == '\\' then
    return true
  else
    return false
  end
end

-- wez defaults to bash on *nix systems.
function set_default_prog(neovim, windows)
  if neovim then
    config.default_prog = {"nvim"}
  elseif windows then
    config.default_prog = {"powershell", "-NoLogo"}
  end
end

function main()
  local neovim      = has_neovim(windows)
  local windows     = is_windows()
  local launch_menu = {}

  if neovim then
    add_neovim_to_launch_menu(launch_menu)
  end

  if windows then
    add_powershell_to_launch_menu(launch_menu)
    add_git_bash_to_launch_menu(launch_menu)
  end

  set_default_prog(neovim, windows)

  config.launch_menu = launch_menu
end

main()

return config
