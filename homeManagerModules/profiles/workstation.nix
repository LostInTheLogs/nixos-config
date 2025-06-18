{
  pkgs,
  lib,
  osConfig,
  inputs,
  ...
}: let
  ai-krita = pkgs.writeShellApplication {
    name = "ai-krita";
    runtimeInputs = [
      pkgs.krita
      pkgs.steam-run
    ];
    text = ''
      SSL_CERT_FILE=/etc/ssl/certs/ca-bundle.crt steam-run krita
    '';
  };
in {
  imports = [
    inputs.dimland.homeManagerModules.dimland
  ];
  config = lib.mkIf osConfig.my.profiles.workstation.enable {
    home.packages = with pkgs; [
      brave

      youtube-music

      vesktop
      discord
      obsidian
      # teams-for-linux
      josm
      unstable.deskflow

      krita
      ai-krita
      gimp-with-plugins
      inkscape

      tenacity
      kdePackages.kdenlive
      losslesscut-bin
      ffmpeg-full
      yt-dlp
      # subtitleedit
      # unstable.aegisub

      obs-studio

      libreoffice
      pdfarranger
      vlc
    ];

    programs.dimland.enable = true;

    systemd.user.sessionVariables = {
      MOZ_USE_XINPUT2 = "1";
    };
  };
}
