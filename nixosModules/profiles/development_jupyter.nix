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
        pkgs.python3.pkgs.black
        pkgs.python3.pkgs.isort
        unstable.python3.pkgs.jupyter-themes
        (python3.pkgs.rpy2.override {extraRPackages = with pkgs.rPackages; [formatR styler];})
        python3.pkgs.jupyterlab-lsp
        (python3.pkgs.buildPythonPackage rec {
          pname = "jupyterlab-vim";
          version = "4.1.4";
          pyproject = true;
          doChecks = false;

          build-system = with python3Packages; [
            hatchling
            hatch-jupyter-builder
            hatch-nodejs-version
          ];
          dependencies = [python3.pkgs.jupyter];
          src = fetchPypi {
            pname = "jupyterlab_vim";
            inherit version;
            hash = "sha256-q/KJGq+zLwy5StmDIa5+vL4Mq+Uj042A1WnApQuFIlo=";
          };
        })
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

    environment.systemPackages = with pkgs; [
      Renv
      python313Packages.nbconvert
      (texliveSmall.withPackages (ps: with ps; [tcolorbox pdfcol adjustbox titling enumitem soul rsfs]))
    ];
  };
}
