# https://github.com/NotAShelf/nyx/blob/d407b4d6e5ab7f60350af61a3d73a62a5e9ac660/modules/core/common/system/nix/module.nix
{
  inputs,
  pkgs,
  ...
}: {
  nix = {
    # Lix, the higher performance Nix fork.
    # package = pkgs.lix;

    # Collect garbage
    gc = {
      automatic = true;
      dates = "Sat *-*-* 22:00";
      options = "--delete-older-than 30d";
    };

    # Automatically optimize nix store, do it after the gc.
    optimise = {
      automatic = true;
      dates = ["Sat *-*-* 22:30"];
    };

    settings = {
      # Tell nix to use the xdg spec for base directories
      # while transitioning, any state must be carried over
      # manually, as Nix won't do it for us.
      use-xdg-base-directories = true;

      # Free up to 10GiB whenever there is less than 5GB left.
      # this setting is in bytes, so we multiply with 1024 thrice
      min-free = "${toString (5 * 1024 * 1024 * 1024)}";
      max-free = "${toString (10 * 1024 * 1024 * 1024)}";

      # Automatically optimise symlinks to save disk space
      auto-optimise-store = true;

      # Allow sudo users to mark the following values as trusted
      allowed-users = ["root" "@wheel" "nix-builder"];

      # Only allow sudo users to manage the nix store
      trusted-users = ["root" "@wheel" "nix-builder"];

      # Let the system decide the number of max jobs
      # based on available system specs. Usually this is
      # the same as the number of cores your CPU has.
      max-jobs = "auto";

      # Always build inside sandboxed environments
      sandbox = true;
      sandbox-fallback = false;

      # Fallback to local builds after remote builders are unavailable.
      # Setting this too low on a slow network may cause remote builders
      # to be discarded before a connection can be established.
      connect-timeout = 5;

      # If we haven't received data for >= 20s, retry the download
      stalled-download-timeout = 20;

      # Show more logs when a build fails and decides to display
      # a bunch of lines. `nix log` would normally provide more
      # information, but this may save us some time and keystrokes.
      log-lines = 90;

      # Extra features of Nix that are considered unstable
      # and experimental. By default we should always include
      # `flakes` and `nix-command`, while others are usually
      # optional.
      extra-experimental-features = [
        "flakes" # flakes
        "nix-command" # experimental nix commands
        "recursive-nix" # let nix invoke itself
        "ca-derivations" # content addressed nix
        "impure-derivations" # __impure derivations
        "auto-allocate-uids" # allow nix to automatically pick UIDs, rather than creating nixbld* user accounts
        "cgroups" # allow nix to execute builds inside cgroups
        # "repl-flake" # lix only, allow passing installables to nix repl
        "no-url-literals" # disallow deprecated url-literals, i.e., URLs without quotation
        "dynamic-derivations" # allow "text hashing" derivation outputs, so we can build .drv files.

        # Those don't actually exist on Lix so they have to be disabled
        # configurable-impure-env" # allow impure environments
        # "git-hashing" # allow store objects which are hashed via Git's hashing algorithm
        # "verified-fetches" # enable verification of git commit signatures for fetchGit
      ];

      # Ensures that the result of Nix expressions is fully determined by
      # explicitly declared inputs, and not influenced by external state.
      # In other words, fully stateless evaluation by Nix at all times.
      pure-eval = false; # pain

      # Don't warn me that my git tree is dirty, I know.
      # warn-dirty = false;

      # Maximum number of parallel TCP connections
      # used to fetch imports and binary caches.
      # 0 means no limit, default is 25.
      http-connections = 35; # lower values fare better on slow connections

      # Whether to accept nix configuration from a flake
      # without displaying a Y/N prompt. For those obtuse
      # enough to keep this true, I wish the best of luck.
      # tl;dr: this is a security vulnerability.
      accept-flake-config = false;

      # Whether to execute builds inside cgroups. cgroups are
      # "a Linux kernel feature that limits, accounts for, and
      # isolates the resource usage (CPU, memory, disk I/O, etc.)
      # of a collection of processes."
      # See:
      # <https://en.wikipedia.org/wiki/Cgroups>
      use-cgroups = pkgs.stdenv.isLinux; # only supported on Linux

      # Use binary cache, this is not Gentoo
      # external builders can also pick up those substituters
      builders-use-substitutes = true;

      # Substituters to pull from. While sigs are disabled, we must
      # make sure the substituters listed here are trusted.
      substituters = [
        "https://cache.nixos.org"
        "https://nix-community.cachix.org"
        "https://nixpkgs-unfree.cachix.org"
        "https://ai.cachix.org"
        "https://cuda-maintainers.cachix.org"
        "https://numtide.cachix.org"
      ];

      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "nixpkgs-unfree.cachix.org-1:hqvoInulhbV4nJ9yJOEr+4wxhDV4xq2d1DK7S6Nj6rs="
        "ai.cachix.org-1:N9dzRK+alWwoKXQlnn0H6aUx0lU/mspIoz8hMvGvbbc="
        "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
        "numtide.cachix.org-1:2ps1kLBUWjxIneOy1Ik6cQjb41X0iXVXeHigGmycPPE="
      ];
    };
  };

  # Global nixpkgs configuration. This is ignored if nixpkgs.pkgs is set
  # which is a case that should be avoided. Everything that is set to configure
  # nixpkgs must go here.
  nixpkgs = {
    # Configuration reference:
    # <https://nixos.org/manual/nixpkgs/unstable/#chap-packageconfig>
    config = {
      # Allow broken packages to be built. Setting this to false means packages
      # will refuse to evaluate sometimes, but only if they have been marked as
      # broken for a specific reason. At that point we can either try to solve
      # the breakage, or get rid of the package entirely.
      allowBroken = false;
      allowUnsupportedSystem = false;

      # Really a pain in the ass to deal with when disabled. True means
      # we are able to build unfree packages without explicitly allowing
      # each unfree package.
      allowUnfree = true;

      # Default to none, add more as necessary. This is usually where
      # electron packages go when they reach EOL.
      permittedInsecurePackages = [
        # "electron-33.4.11" # teams-for-linux
      ];

      # Nixpkgs sets internal package aliases to ease migration from other
      # distributions easier, or for convenience's sake. Even though the manual
      # and the description for this option recommends this to be true, I prefer
      # explicit naming conventions, i.e., no aliases.
      allowAliases = false;

      # Enable parallel building by default. This, in theory, should speed up building
      # derivations, especially rust ones. However setting this to true causes a mass rebuild
      # of the *entire* system closure, so it must be handled with proper care.
      enableParallelBuildingByDefault = false;

      # List of derivation warnings to display while rebuilding.
      #  See: <https://github.com/NixOS/nixpkgs/blob/master/pkgs/stdenv/generic/check-meta.nix>
      # NOTE: "maintainerless" can be added to emit warnings
      # about packages without maintainers but it seems to me
      # like there are more packages without maintainers than
      # with maintainers, so it's disabled for the time being.
      showDerivationWarnings = [];
    };

    overlays = [
      inputs.self.outputs.overlays.unstable
      inputs.self.outputs.overlays.my
    ];
  };

  # By default nix-gc makes no effort to respect battery life by avoiding
  # GC runs on battery and fully commits a few cores to collecting garbage.
  # This will drain the battery faster than you can say "Nix, what the hell?"
  # and contribute heavily to you wanting to build a desktop (do that anyway.)
  # For those curious (such as myself) desktops are always seen as "AC powered"
  # so the service will not fail to fire if you are on a desktop system.
  systemd.services.nix-gc = {
    unitConfig.ConditionACPower = true;
  };
}
