{
  pkgs,
  lib,
  osConfig,
  ...
}: {
  config = lib.mkIf osConfig.my.profiles.workstation.enable {
    home.packages = with pkgs; [
      vesktop
      firefox
      brave
      obsidian
      teams-for-linux
    ];

    systemd.user.sessionVariables = {
      MOZ_USE_XINPUT2 = "1";
    };
  };
}
