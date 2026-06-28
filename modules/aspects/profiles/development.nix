{
  den.aspects.profiles.development.nixos = {pkgs, ...}: {
    virtualisation.containers.enable = true;
    virtualisation = {
      docker = {
        enable = true;
      };
      podman = {
        enable = false;

        # Create a `docker` alias for podman, to use it as a drop-in replacement
        dockerCompat = true;

        # Required for containers under podman-compose to be able to talk to each other.
        defaultNetwork.settings.dns_enabled = true;
      };
    };

    networking.firewall = {
      allowedTCPPorts = [3306];
    };

    environment.systemPackages = with pkgs; [
      xclip
      wl-clipboard
      trashy
      # podman-compose

      #uni
      # mariadb
      unstable.dbeaver-bin
      # (rstudioWrapper.override {packages = with rPackages; [ggplot2 MASS tidyverse];})

      # alejandra
      # nixd
      # gcc
      # nodejs
      # lua
      # lua-language-server
    ];
  };

  den.aspects.profiles.development.homeManager = {pkgs, ...}: {
    home.packages = with pkgs; [
      stow
      just
      gnumake

      zellij
      vscodium-fhs

      unstable.neovim
      nixd
      alejandra
      gh

      # tmp
      nodejs
      pnpm
      gcc

      unstable.conda
      # (pkgs.python3.withPackages (python-pkgs:
      #   with python-pkgs; [
      #     conda
      #     pip
      #   ]))

      tokei
    ];

    programs.atuin = {
      enable = true;
      flags = [
        "--disable-up-arrow"
      ];
      settings = {
        auto_sync = true;
        sync_frequency = "5m";
        sync_address = "https://api.atuin.sh";
        search_mode = "fuzzy";
      };
    };
  };
}
