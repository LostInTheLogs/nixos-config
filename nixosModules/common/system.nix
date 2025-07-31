{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.nix-index-database.nixosModules.nix-index
  ];

  system = {
    # TODO: <https://github.com/NixOS/nixpkgs/issues/349734>
    # autoUpgrade = {
    #   flake = "path:${inputs.self}";
    #   enable = true;
    #   flags = [
    #     "-T-${inputs.self}"
    #     "-D-${./.}"
    #     "--update-input nixpkgs"
    #     "--commit-lock-file"
    #     "-L"
    #     "-j 1"
    #     "--cores 1"
    #   ];
    #   dates = "21:00";
    #   randomizedDelaySec = "15min";
    # };

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
