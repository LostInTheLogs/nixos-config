{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.my.profiles.laptop;
in {
  options.my.profiles.laptop.enable = lib.mkEnableOption "the laptop profile";

  config = lib.mkIf cfg.enable {
    # services.tlp.enable = true;
    # networking.wireless.enable = true;

    # environment.systemPackages = with pkgs; [input-leap];
  };
}
