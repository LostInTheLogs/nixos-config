{
  lib,
  config,
  inputs,
  pkgs,
  ...
}: let
  cfg = config.my.profiles.music;
in {
  imports = [
    inputs.musnix.nixosModules.musnix
  ];

  options.my.profiles.music.enable = lib.mkEnableOption "the music profile";

  config = lib.mkIf cfg.enable {
    musnix = {
      enable = true;
    };

    environment.systemPackages = with pkgs; [
      yabridge
      yabridgectl
      bottles
    ];

    services.pipewire.extraConfig.pipewire."91-null-sinks" = {
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
    };
  };
}
