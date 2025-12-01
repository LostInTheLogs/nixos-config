{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.my.profiles.workstation;
  timeoutConfig = ''
  '';
in {
  options.my.profiles.workstation.enable = lib.mkEnableOption "the workstation profile";

  config = lib.mkIf cfg.enable {
    my.users = {
      enable = true;
      home-manager.enable = true;
    };

    fonts.packages = with pkgs; [noto-fonts-cjk-sans noto-fonts noto-fonts-lgc-plus noto-fonts-color-emoji];

    environment.systemPackages = with pkgs; [
      kdePackages.plasma-pa
      kdePackages.filelight
      kdePackages.partitionmanager
      protonvpn-gui
      mullvad
      mullvad-vpn
      tor-browser
      bottles
    ];

    services.sunshine = {
      enable = true;
      autoStart = true;
      capSysAdmin = true;
      openFirewall = true;
    };

    programs.firefox.enable = true;

    services.earlyoom = {
      enable = true;
      enableNotifications = true;
      freeMemThreshold = 3;
    };
    systemd.services.earlyoom.serviceConfig.User = "lost"; # TODO: remove https://github.com/NixOS/nixpkgs/pull/375649

    systemd.settings.Manager = {
      DefaultTimeoutStartSec = "10s";
      DefaultTimeoutStopSec = "10s";
      DefaultTimeoutAbortSec = "10s";
      DefaultDeviceTimeoutSec = "10s";
    };

    services.flatpak.enable = true;
    xdg.portal.enable = true;

    services.xserver.enable = true;
    services.displayManager.sddm.enable = true;
    services.desktopManager.plasma6.enable = true;
    services.displayManager.sddm.wayland.enable = true;
    services.displayManager.defaultSession = "plasma";

    services.printing.enable = true;
    services.printing.drivers = with pkgs; [
      gutenprint
      gutenprint-bin
      brgenml1lpr
      brgenml1cupswrapper
      pkgs.cnijfilter2
      hplip
      hplipWithPlugin # NIXPKGS_ALLOW_UNFREE=1 nix-shell -p hplipWithPlugin --run 'sudo -E hp-setup'
      splix
      brlaser
    ];
    services.avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };

    hardware.bluetooth.enable = true; # enables support for Bluetooth
    hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot

    hardware.enableAllFirmware = true;
  };
}
