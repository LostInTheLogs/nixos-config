{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.my.profiles.development;
in {
  options.my.profiles.development.enable = lib.mkEnableOption "the development profile";

  config = lib.mkIf cfg.enable {
    virtualisation.containers.enable = true;
    virtualisation = {
      podman = {
        enable = true;

        # Create a `docker` alias for podman, to use it as a drop-in replacement
        dockerCompat = true;

        # Required for containers under podman-compose to be able to talk to each other.
        defaultNetwork.settings.dns_enabled = true;
      };
    };

    fonts = {
      packages = with pkgs; [nerd-fonts.fira-code my.iosevka-custom];
      fontconfig = {
        enable = true;
        defaultFonts = {
          sansSerif = ["Noto Sans"];
          monospace = ["Iosevka Custom"];
        };
      };
    };

    # TODO: for uni only
    systemd.tmpfiles.rules = ["L+ /usr/sbin/ipsec - - - - ${pkgs.strongswan}/sbin/ipsec"];

    networking.firewall = {
      allowedTCPPorts = [3306];
    };

    # services.jupyter = let
    #   Renv = pkgs.rWrapper.override {
    #     packages = with pkgs.rPackages; [
    #       IRkernel
    #       tidyverse
    #       MASS
    #       ggplot2
    #       languageserver
    #       languageserversetup
    #     ];
    #   };
    # in {
    #   enable = true;
    #   password = "";
    #   notebookConfig = ''
    #     c.NotebookApp.token = ""
    #   '';
    #   extraPackages = with pkgs; [
    #     # rWrapper.override
    #     # {
    #     #   packages = with pkgs.rPackages; [
    #     #     IRkernel
    #     #     languageserver
    #     #     languageserversetup
    #     #   ];
    #     # }
    #     python3.pkgs.jupyterlab-lsp
    #     python3.pkgs.jupyterlab-vim
    #     (python3.pkgs.buildPythonPackage rec {
    #       pname = "jupyterlab-code-formatter";
    #       version = "3.0.2";
    #       pyproject = true;
    #       doChecks = false;
    #
    #       build-system = with python3Packages; [
    #         hatchling
    #         hatch-jupyter-builder
    #         hatch-nodejs-version
    #       ];
    #       dependencies = [python3.pkgs.jupyter];
    #       src = fetchPypi {
    #         pname = "jupyterlab_code_formatter";
    #         inherit version;
    #         hash = "sha256-Va24+oub1Y8LOefT6tbB6GLp68FESmbNtCM9jcY1HUs=";
    #       };
    #     })
    #   ];
    #   kernels = {
    #     R = {
    #       displayName = "R kernel";
    #       argv = [
    #         "${Renv}/bin/R"
    #         "--slave"
    #         "-e"
    #         "IRkernel::main()"
    #         "--args"
    #         "{connection_file}"
    #       ];
    #       language = "R";
    #       logo64 = "${pkgs.rPackages.IRkernel}/library/IRkernel/kernelspec/logo-64x64.png";
    #     };
    #   };
    # };

    environment.systemPackages = with pkgs; [
      xclip
      wl-clipboard
      trashy
      podman-compose

      #uni
      mariadb
      unstable.dbeaver-bin
      (pkgs.rWrapper.override {
        packages = with pkgs.rPackages; [
          tidyverse
          MASS
          ggplot2
        ];
      })
      (rstudioWrapper.override {packages = with rPackages; [ggplot2 MASS tidyverse];})

      # alejandra
      # nixd
      # gcc
      # nodejs
      # lua
      # lua-language-server
    ];
  };
}
