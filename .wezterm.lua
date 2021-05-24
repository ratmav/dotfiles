local wezterm = require 'wezterm';

return {
  -- display
  color_scheme = "Gruvbox Dark",
  font = wezterm.font(
    "Source Code Pro for Powerline",
    { weight="Medium" }
  ),
  font_size = 16,
  warn_about_missing_glyphs = false,

  -- behavior
  disable_default_key_bindings = true,
  leader = { key="Control", mods="SHIFT" },
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
  },
}
