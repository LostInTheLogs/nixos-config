{
  description = "TODO";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-24.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {nixpkgs, ...} @ inputs: let
    inherit (nixpkgs) lib;
    args = {
      inherit inputs;
      inherit lib;
      inherit mylib;
    };
    mylib = import ./lib args;
  in {
    lib = mylib;

    nixosConfigurations = import ./hosts args;

    nixosModules = import ./nixosModules args;

    formatter = mylib.forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);
  };
}
