{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.my.profiles.development;
in {
  options.my.profiles.development.enable = lib.mkEnableOption "the development profile";

  config = lib.mkIf cfg.enable {
    virtualisation.containers.enable = true;
    virtualisation = {
      podman = {
        enable = true;

        # Create a `docker` alias for podman, to use it as a drop-in replacement
        dockerCompat = true;

        # Required for containers under podman-compose to be able to talk to each other.
        defaultNetwork.settings.dns_enabled = true;
      };
    };

    fonts = {
      packages = with pkgs; [nerd-fonts.fira-code my.iosevka-custom];
      fontconfig = {
        enable = true;
        defaultFonts = {
          sansSerif = ["Noto Sans"];
          monospace = ["Iosevka Custom"];
        };
      };
    };

    # TODO: for uni only
    systemd.tmpfiles.rules = ["L+ /usr/sbin/ipsec - - - - ${pkgs.strongswan}/sbin/ipsec"];

    networking.firewall = {
      allowedTCPPorts = [3306];
    };

    environment.systemPackages = with pkgs; [
      xclip
      wl-clipboard
      trashy
      podman-compose
      unstable.dbeaver-bin
      mariadb

      # alejandra
      # nixd
      # gcc
      # nodejs
      # lua
      # lua-language-server
    ];
  };
}
