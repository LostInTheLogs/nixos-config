{
  inputs,
  lib,
  ...
}: {
  flake-file.inputs = {
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
  };

  flake.overlays = {
    unstable = final: prev: {
      unstable = import inputs.nixpkgs-unstable {
        system = prev.stdenv.hostPlatform.system;
        inherit (prev) config;
      };
    };

    my = final: prev: {
      my = import ../../pkgs {
        pkgs = prev;
        inherit lib;
        config = {};
      };
    };
  };
}
