local wezterm = require("wezterm")
return {
  window_close_confirmation = 'NeverPrompt',
  default_prog = {'/opt/homebrew/bin/bash','--login'}, 
  color_scheme = 'Gruvbox Material (Gogh)',
  font = wezterm.font('UbuntuMono Nerd Font'),
  font_size = 30,
  term = "xterm-256color",
  animation_fps = 60,
  max_fps = 60,
  hide_tab_bar_if_only_one_tab = true,
}
