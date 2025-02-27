{
  lib,
  config,
  inputs,
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
  };
}
