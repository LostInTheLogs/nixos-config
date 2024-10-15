{inputs, ...}: {
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

  environment.sessionVariables = rec {
    XDG_CACHE_HOME = "$HOME/.cache";
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_STATE_HOME = "$HOME/.local/state";

    # Not officially in the specification
    XDG_BIN_HOME = "$HOME/.local/bin";
    PATH = [
      "${XDG_BIN_HOME}"
    ];

    EDITOR = "nvim";
  };

  services.tailscale.enable = true;
  services.openssh.enable = true;

  services.automatic-timezoned.enable = true;
}
