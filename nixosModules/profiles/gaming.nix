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
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };

    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
      dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
      localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
    };

    environment.systemPackages = with pkgs; [
      # steam
      steam-run
      # minecraft
      prismlauncher
      modrinth-app
      ferium
    ];
  };
}
