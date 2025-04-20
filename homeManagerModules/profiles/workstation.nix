{
  pkgs,
  lib,
  osConfig,
  ...
}: {
  config = lib.mkIf osConfig.my.profiles.workstation.enable {
    home.packages = with pkgs; [
      brave

      libreoffice

      vesktop
      obsidian
      teams-for-linux
      josm

      krita
      gimp-with-plugins
      inkscape

      tenacity
      unstable.kdePackages.kdenlive
      ffmpeg-full
      yt-dlp
      subtitleedit
      unstable.aegisub

      obs-studio

      pdfarranger
      vlc
    ];

    systemd.user.sessionVariables = {
      MOZ_USE_XINPUT2 = "1";
    };
  };
}
