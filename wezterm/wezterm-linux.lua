local wezterm = require("wezterm")
return {
  window_close_confirmation = 'NeverPrompt',
  color_scheme = 'Gruvbox Material (Gogh)',
  font = wezterm.font('UbuntuMono Nerd Font'),
  font_size = 28,
  term = "xterm-256color",
  animation_fps = 60,
  enable_wayland = false,
  front_end = "OpenGL",
  prefer_egl = false,
  max_fps = 60,
  hide_tab_bar_if_only_one_tab = true,
}
