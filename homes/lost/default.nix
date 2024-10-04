{config, ...}: {
  imports = [];
  home = {
    username = "lost";
    homeDirectory = "/home/${config.home.username}";
    stateVersion = "24.05";
    sessionPath = ["$HOME/.local/bin"];
  };
}
