{
  pkgs,
  lib,
  osConfig,
  ...
}: {
  config = lib.mkIf osConfig.my.profiles.gaming.enable {
    home.packages = with pkgs; [
      # sth
    ];
    # fixes cursor in steam
    # home.file.".icons/default".source = "${pkgs.kdePackages.breeze}/share/icons/breeze_cursors";
  };
}
