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
    -- typical install local of git bash on windows.
    local git_bash_path = "C:\\Program Files\\Git\\bin\\bash.exe"
    local launch_menu = {
      label = "powershell",
      args = {"powershell", "-NoLogo"},
    }

    -- if git bash is present, default to it.
    if io.open(git_bash_path) ~= nil then
      config.insert(default_prog, {git_bash_path})
      table.insert(launch_menu, {
        label = "git bash",
        args = {git_bash_path}, 
      })
    -- if git bash is not present, fallback to powershell.
    else
      config.insert(default_prog, {"powershell", "-NoLogo"})
    end

    config.insert(launch_menu, launch_menu)
end

return config
