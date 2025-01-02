{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.my.profiles.gaming;
in {
  options.my.profiles.gaming.enable = lib.mkEnableOption "the gaming profile";

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      steam
      # minecraft
      prismlauncher
      modrinth-app
      ferium
    ];
  };
}
