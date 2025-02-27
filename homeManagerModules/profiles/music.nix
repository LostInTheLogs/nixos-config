{
  pkgs,
  lib,
  osConfig,
  ...
}: {
  config = lib.mkIf osConfig.my.profiles.gaming.enable {
    home.packages = with pkgs; [
      carla
      lsp-plugins
      calf
      yabridge
      yabridgectl
      bottles

      gmetronome
    ];
  };
}
