{
  pkgs,
  lib,
  osConfig,
  ...
}: {
  config = lib.mkIf osConfig.my.profiles.workstation.enable {
    home.packages = with pkgs; [
      brave

      vesktop
      obsidian
      teams-for-linux
      josm

      krita
      gimp-with-plugins
      inkscape

      unstable.kdePackages.kdenlive
      ffmpeg-full
      yt-dlp

      obs-studio

      pdfarranger
      vlc
    ];

    systemd.user.sessionVariables = {
      MOZ_USE_XINPUT2 = "1";
    };
  };
}
