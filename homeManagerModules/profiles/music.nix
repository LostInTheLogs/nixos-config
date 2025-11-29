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
      systemd-inhibit --who=run-carla --why="piano-playing" sleep 1h &
      INHIBIT_PID=$!

      PIPEWIRE_LATENCY="2048/48000" carla "$HOME/Documents/music/all.carxp"
      kill "$INHIBIT_PID" 2>/dev/null
      wait "$INHIBIT_PID" 2>/dev/null
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
