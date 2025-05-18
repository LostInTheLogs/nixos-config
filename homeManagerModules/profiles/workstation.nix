{
  pkgs,
  lib,
  osConfig,
  ...
}: {
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
      gimp-with-plugins
      inkscape

      tenacity
      unstable.kdePackages.kdenlive
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

    systemd.user.sessionVariables = {
      MOZ_USE_XINPUT2 = "1";
    };
  };
}
