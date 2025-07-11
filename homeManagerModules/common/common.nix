{...}: {
  # Allow HM to manage itself when in standalone mode.
  # This makes the home-manager command available to users.
  programs.home-manager.enable = true;

  # Try to save some space by not installing variants of the home-manager
  # manual, which I don't use at all. Unlike what the name implies, this
  # section is for home-manager related manpages only, and does not affect
  # whether or not manpages of actual packages will be installed.
  manual = {
    manpages.enable = false;
    html.enable = false;
    json.enable = false;
  };
  # nixpkgs.overlays = [];
  xdg.enable = true;

  home.sessionVariables = {
    PATH = "$HOME/.local/bin:$HOME/repos/scripts:$PATH";
  };

  systemd.user.startServices = "sd-switch";
}
