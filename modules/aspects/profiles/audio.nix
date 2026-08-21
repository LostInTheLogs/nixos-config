{
  inputs,
  lib,
  ...
}: {
  flake-file.inputs = {
    musnix.url = "github:musnix/musnix";
  };

  den.aspects.profiles.audio.nixos = {pkgs, ...}: let
    yabridge-wine = pkgs.writeShellScriptBin "yabridge-wine" ''
      exec ${pkgs.wineWow64Packages.yabridge}/bin/wine "$@"
    '';
  in {
    imports = [
      inputs.musnix.nixosModules.musnix
    ];

    musnix = {
      enable = true;
      rtcqs.enable = true;
    };

    security.rtkit.enable = true;

    environment.systemPackages = with pkgs; [
      yabridge
      yabridgectl
      yabridge-wine
    ];

    services.pipewire.extraConfig.pipewire = {
      "91-null-sinks" = {
        "context.objects" = [
          {
            factory = "adapter";
            args = {
              "factory.name" = "support.null-audio-sink";
              "node.name" = "NoNoiseMic";
              "node.description" = "Virtual mic: NoNoiseMic";
              "media.class" = "Audio/Source/Virtual";
              "audio.position" = "FL,FR";
            };
          }
        ];
        # "91-quantum-1024" = {
        #   "context.properties" = {
        #     "default.clock.quantum" = 1024;
        #     "default.clock.min-quantum" = 1024;
        #     "default.clock.max-quantum" = 2048;
        #   };
        # };
      };
    };
  };

  den.aspects.profiles.audio.homeManager = {
    pkgs,
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
