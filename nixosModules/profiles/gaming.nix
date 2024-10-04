{
  lib,
  config,
  ...
}: let
  cfg = config.my.profiles.gaming;
in {
  options.my.profiles.gaming.enable = lib.mkEnableOption "the gaming profile";

  config = lib.mkIf cfg.enable {
    # sth
  };
}
