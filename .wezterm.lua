local wezterm = require 'wezterm';

function os_shell()
  -- typical install local of git bash on windows.
  local git_bash_path = "C:\\Program Files\\Git\\bin\\bash.exe"

  -- package.config:sub(1,1) returns '/' for *nix and '\' for *windows.
  if package.config:sub(1,1) ~= '/' then
    -- if git bash is present, default to it.
    if io.open(git_bash_path) ~= nil then
      return {git_bash_path}
    -- if git bash is not present, fallback to powershell.
    else
      return {"powershell", "-NoLogo"}
    end
  -- on *nix, open a bash login shell.
  else
    return {"bash", "-l"}
  end
end

function os_launch()
  -- typical install local of git bash on windows.
  local git_bash_path = "C:\\Program Files\\Git\\bin\\bash.exe"
  local launch_menu = {}

  -- package.config:sub(1,1) returns '/' for *nix and '\' for *windows.
  if package.config:sub(1,1) ~= '/' then
    -- if we're on windows, add powershell.
    table.insert(launch_menu, {
      label = "powershell",
      args = {"powershell", "-NoLogo"},
    })
    -- if git bash is installed, add git bash.
    if io.open(git_bash_path) ~= nil then
    table.insert(launch_menu, {
      label = "git bash",
      args = {git_bash_path},
    })      
    end
  -- on *nix, add bash.
  else
    table.insert(launch_menu, {
      label = "WEZbash",
      args = {"bash", "-l"},
    })
  end
  
  return launch_menu
end

return {
  -- set the default shell based on the os.
  default_prog = os_shell(),

  -- set the launch menu based on the os.
  launch_menu = os_launch(),

  -- display
  color_scheme = "Gruvbox Dark",
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
