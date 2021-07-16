local wezterm = require 'wezterm';

config = {
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

-- package.config:sub(1,1) returns '/' for *nix and '\' for *windows.
if package.config:sub(1,1) ~= '/' then
  -- add powershell to the launch menu and default to it.
  local launch_menu = {{
    label = "powershell",
    args = {"powershell", "-NoLogo"},
  }}
  config.default_prog = {"powershell", "-NoLogo"}

  -- if git bash is found, add it to the launch menu.
  local git_bash_path = "C:\\Program Files\\Git\\bin\\bash.exe"
  if io.open(git_bash_path) ~= nil then
    table.insert(launch_menu, {
      label = "git-bash",
      args = {git_bash_path},
    })
  end

  config.launch_menu = launch_menu
end

return config
