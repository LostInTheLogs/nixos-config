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
      kdePackages.kdenlive
      obs-studio

      pdfarranger
      vlc

      yt-dlp
      ffmpeg
    ];

    systemd.user.sessionVariables = {
      MOZ_USE_XINPUT2 = "1";
    };
  };
}
