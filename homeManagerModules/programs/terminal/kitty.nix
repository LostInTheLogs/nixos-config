{...}: {
  programs.kitty = {
    enable = true;
    themeFile = "gruvbox-dark-hard";
    settings = {
      font_size = "10.5";
      disable_ligatures = "cursor";
      cursor_blink_interval = 0;
      paste_actions = "filter";
      window_padding_width = "0 0 0 0";
      confirm_window_close = 2;
      background_opacity = "0.92";
      dynamic_background_opacity = true;
    };
  };
  programs.kitty.keybindings = {
    "ctrl+tab" = "no_op";
    "ctrl+equal" = "change_font_size all +1.0";
    "ctrl+plus" = "change_font_size all +1.0";
    "ctrl+minus" = "change_font_size all -1.0";
    "ctrl+0" = "change_font_size all 0";
  };
}
