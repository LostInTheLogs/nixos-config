{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.my.profiles.development;
  Renv = pkgs.rWrapper.override {
    packages = with pkgs.rPackages; [
      IRkernel
      tidyverse
      MASS
      ggplot2
      languageserver
      languageserversetup
    ];
  };
in {
  config = lib.mkIf cfg.enable {
    systemd.services.jupyter.path = [
      pkgs.bash
      Renv
    ];
    services.jupyter = let
    in {
      enable = true;
      password = "";
      notebookConfig = ''
        c.NotebookApp.token = ""
      '';
      extraPackages = with pkgs; [
        unstable.python3.pkgs.jupyter-themes
        unstable.python3.pkgs.jupyterlab-vim
        python3.pkgs.jupyterlab-lsp
        (python3.pkgs.buildPythonPackage rec {
          pname = "jupyterlab-code-formatter";
          version = "3.0.2";
          pyproject = true;
          doChecks = false;

          build-system = with python3Packages; [
            hatchling
            hatch-jupyter-builder
            hatch-nodejs-version
          ];
          dependencies = [python3.pkgs.jupyter];
          src = fetchPypi {
            pname = "jupyterlab_code_formatter";
            inherit version;
            hash = "sha256-Va24+oub1Y8LOefT6tbB6GLp68FESmbNtCM9jcY1HUs=";
          };
        })
      ];
      kernels = {
        R = {
          displayName = "R kernel";
          argv = [
            "${Renv}/bin/R"
            "--slave"
            "-e"
            "IRkernel::main()"
            "--args"
            "{connection_file}"
          ];
          language = "R";
          logo64 = "${pkgs.rPackages.IRkernel}/library/IRkernel/kernelspec/logo-64x64.png";
        };
      };
    };

    environment.systemPackages = [
      Renv
    ];
  };
}
