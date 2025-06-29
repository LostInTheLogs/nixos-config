{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.nix-index-database.nixosModules.nix-index
  ];

  system = {
    # Automatic/Unattended upgrades in general are one of the dumbest things you can set up
    # on virtually any Linux distribution. While NixOS would logically mitigate some of its
    # side effects, you are still risking a system that breaks without you knowing. If the
    # bootloader also breaks during the upgrade, you may not be able to roll back at all.
    # tl;dr: upgrade manually, review changelogs.
    autoUpgrade.enable = false;

    # Globally declare the configurationRevision from shortRev if the git tree is clean,
    # or from dirtyShortRev if it is dirty. This is useful for tracking the current
    # configuration revision in the system profile.
    configurationRevision = inputs.self.shortRev or inputs.self.dirtyShortRev;
  };

  # Preserve the flake that built the active system revision in /etc
  # for easier rollbacks with nixos-enter in case we contain changes
  # that are not yet staged.
  environment.etc."flake".source = inputs.self;

  boot.loader = {
    systemd-boot.enable = true;
    systemd-boot.configurationLimit = 5;
    efi.canTouchEfiVariables = true;
    timeout = 2;
  };

  environment.sessionVariables = {
    EDITOR = "nvim";
  };

  environment.systemPackages = with pkgs; [smartmontools busybox];
  programs.nix-index-database.comma.enable = true;

  services.tailscale.enable = true;
  services.openssh.enable = true;

  services.automatic-timezoned.enable = true;
  services.geoclue2.geoProviderUrl = "https://api.beacondb.net/v1/geolocate";

  programs.nix-ld.enable = true;

  services.xserver.xkb.layout = "pl";
  console.keyMap = "pl";
}
