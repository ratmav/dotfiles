--[[
  Behavior:
    if neovim is installed:
      * each wez tab starts neovim by default.
      * included neovim on the launch menu.
      * on windows:
        * include powershell in the launch menu.
        * include git bash in the launch menu if git is installed.
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

function add_git_bash_to_launch_menu(launch_menu)
  -- can't just get-command, at least not in a straightforward way.
  local git_bash_path = "C:\\Program Files\\Git\\bin\\bash.exe"
  if io.open(git_bash_path) ~= nil then
    add_to_launch_menu(launch_menu, "git bash",{git_bash_path})
  end
end

function add_neovim_to_launch_menu(launch_menu)
  add_to_launch_menu(launch_menu, "neovim",{"nvim"})
end

function add_powershell_to_launch_menu(launch_menu)
  add_to_launch_menu(launch_menu, "powershell",{"powershell", "-NoLogo"})
end

function add_to_launch_menu(launch_menu, label, args)
  table.insert(launch_menu, {
    label = label,
    args = args,
  })
end

function detect_host_os()
  -- package.config:sub(1,1) returns '\' for windows and '/' for *nix.
  if package.config:sub(1,1) == '\\' then
    return 'windows'
  else
    -- uname should be available on *nix systems.
    local check = io.popen('uname -s')
    local result = check:read('*l'); check:close()

    if result == 'Darwin' then
      return 'macos'
    else
      return 'linux'
    end
  end
end

function has_neovim(host_os)
  -- determine check command based on os.
  local check_command
  if host_os == 'windows' then
    check_command = '(Get-Command nvim -ErrorAction "SilentlyContinue").Path'
  else
    -- type should be available on *nix systems.
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

-- wez defaults to bash on *nix systems.
function set_default_prog(neovim, host_os)
  if neovim then
    config.default_prog = {"nvim"}
  elseif host_os == 'windows' then
    config.default_prog = {"powershell", "-NoLogo"}
  end
end

function main()
  local host_os     = detect_host_os()
  local launch_menu = {}
  local neovim      = has_neovim(host_os)

  if host_os == 'windows' then
    add_powershell_to_launch_menu(launch_menu)
    add_git_bash_to_launch_menu(launch_menu)
  elseif host_os == 'macos' then
    -- check homebrew binary symlinks on startup.
    config.set_environment_variables = {
      PATH = '/opt/homebrew/bin/:' .. os.getenv('PATH')
    }
  end

  if neovim then
    add_neovim_to_launch_menu(launch_menu)
  end

  set_default_prog(neovim, host_os)

  config.launch_menu = launch_menu
end

main()

return config
