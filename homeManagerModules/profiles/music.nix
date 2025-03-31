{
  pkgs,
  lib,
  osConfig,
  ...
}: {
  config = lib.mkIf osConfig.my.profiles.gaming.enable {
    home.packages = with pkgs; [
      my.carla
      lsp-plugins
      calf

      gmetronome
      qpwgraph
    ];
  };
}
