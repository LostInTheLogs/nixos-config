{
  lib,
  config,
  ...
}: let
  cfg = config.my.syncthing;
in {
  options.my.syncthing.enable = lib.mkEnableOption "syncthing";

  config = lib.mkIf cfg.enable {
    services.syncthing.enable = true;
  };
}
