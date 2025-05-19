{
  pkgs,
  lib,
  osConfig,
  ...
}: let
  run-carla = pkgs.writeShellApplication {
    name = "run-carla";
    runtimeInputs = [
      pkgs.my.carla
    ];
    text = ''
      PIPEWIRE_LATENCY="2048/48000" carla "$HOME/Documents/music/all.carxp"
    '';
  };
in {
  config = lib.mkIf osConfig.my.profiles.gaming.enable {
    home.packages = with pkgs; [
      my.carla
      run-carla
      lsp-plugins
      calf

      gmetronome
      qpwgraph
    ];
  };
}
