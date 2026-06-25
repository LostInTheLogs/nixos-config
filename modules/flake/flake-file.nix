{inputs, ...}: let
in {
  imports = [
    (inputs.flake-file.flakeModules.dendritic or {})
    (inputs.den.flakeModules.dendritic or {})
  ];

  # other inputs may be defined at a module using them.
  flake-file.inputs = {
    den.url = "github:denful/den";
    den-diagram = {
      url = "github:denful/den-diagram";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-file.url = "github:vic/flake-file";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs.url = "nixpkgs/nixos-26.05";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };

  flake-file.formatter = pkgs: pkgs.alejandra;

  perSystem = {pkgs, ...}: {
    formatter = pkgs.alejandra;
  };
}
