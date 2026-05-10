{
  config,
  osConfig,
  ...
}: {
  imports = [];
  home = {
    username = "lost";
    homeDirectory = "/home/${config.home.username}";
    stateVersion = osConfig.system.stateVersion;
    sessionPath = ["$HOME/.local/bin"];
  };
  xdg.configFile."nixpkgs/config.nix".text = ''
    {
      allowUnfree = true;
    }
  '';
}
