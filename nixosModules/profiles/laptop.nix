{
  lib,
  config,
  ...
}: let
  cfg = config.my.profiles.laptop;
in {
  options.my.profiles.laptop.enable = lib.mkEnableOption "the laptop profile";

  config = lib.mkIf cfg.enable {
    services.tlp.enable = true;
  };
}
