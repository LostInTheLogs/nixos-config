{
  lib,
  self,
  inputs,
  ...
}: {
  flake-file.inputs = {
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
  };

  perSystem = {pkgs, ...}: {
    devShells = {
      default = pkgs.mkShell {packages = with pkgs; [alejandra nixd deadnix];};
    };
    packages = import ../../pkgs {
      pkgs = pkgs;
      inherit lib;
      config = {};
    };
  };

  flake.overlays = {
    unstable = final: prev: {
      unstable = import inputs.nixpkgs-unstable {
        system = prev.stdenv.hostPlatform.system;
        inherit (prev) config;
      };
    };

    my = final: prev: {
      my = self.packages.${prev.stdenv.hostPlatform.system};
    };
  };
}
