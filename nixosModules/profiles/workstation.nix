{
  lib,
  config,
  ...
}: let
  cfg = config.my.profiles.workstation;

  timeoutConfig = ''
    DefaultTimeoutStartSec=10s
    DefaultTimeoutStopSec=10s
    DefaultTimeoutAbortSec=10s
    DefaultDeviceTimeoutSec=10s
  '';
in {
  options.my.profiles.workstation.enable = lib.mkEnableOption "the workstation profile";

  config = lib.mkIf cfg.enable {
    services.earlyoom = {
      enable = true;
      enableNotifications = true;
    };

    systemd.extraConfig = timeoutConfig;
    systemd.user.extraConfig = timeoutConfig;

    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
    boot.loader.timeout = 2;

    services.flatpak.enable = true;
    xdg.portal.enable = true;

    services.xserver.enable = true;
    services.displayManager.sddm.enable = true;
    services.desktopManager.plasma6.enable = true;
    services.displayManager.sddm.wayland.enable = true;
    services.displayManager.defaultSession = "plasmax11";
  };
}
