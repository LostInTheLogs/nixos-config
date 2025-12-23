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
      protontricks.enable = true;

      package = pkgs.steam.override {
        extraPkgs = pkgs:
          with pkgs; [
            # Workaround xorg cursor issue
            kdePackages.breeze
          ];
      };
    };

    programs.gamemode.enable = true;

    environment.systemPackages = with pkgs; [
      # fixes cursor in steam
      # (pkgs.runCommandLocal "breeze-cursor-default-theme" {} ''
      #   mkdir -p $out/share/icons
      #   ln -s ${pkgs.kdePackages.breeze}/share/icons/breeze_cursors $out/share/icons/default
      # '')
      xsettingsd
      xorg.xrdb

      steam-run
      prismlauncher
      (lutris.override
        {
          extraLibraries = pkgs:
            with pkgs; [
              # sth here fixed gstreamer
              libgudev
              libvdpau
              libwebp
              libvpx
              openal
              gst_all_1.gstreamer
              gst_all_1.gst-plugins-base
              gst_all_1.gst-plugins-good
              gst_all_1.gst-plugins-ugly
              gst_all_1.gst-plugins-bad
              gst_all_1.gst-libav
              # libadwaita
              # gtk4
            ];
        })
    ];
  };
}
