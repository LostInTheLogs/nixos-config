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
  };
}
