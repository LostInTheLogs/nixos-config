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
    hardware.bluetooth.enable = true; # enables support for Bluetooth
    hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot

    environment.systemPackages = with pkgs; [input-leap];
  };
}
