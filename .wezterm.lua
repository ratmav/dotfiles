local wezterm = require 'wezterm';
return {
  disable_default_key_bindings = true,
  color_scheme = "Gruvbox Dark",
  font = wezterm.font(
    "Source Code Pro for Powerline",
    {weight="Medium"}
  ),
  font_size = 16,
}
