{
  description = "TODO";

  inputs = {
    # nixpkgs.url = "nixpkgs/nixos-24.11";
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    home-manager = {
      # url = "github:nix-community/home-manager/release-24.11";
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    # ./homeManagerModules/programs/terminal/zsh.nix
    fzf-tab = {
      url = "github:Aloxaf/fzf-tab";
      flake = false;
    };
    conda-zsh-completion = {
      url = "github:conda-incubator/conda-zsh-completion";
      flake = false;
    };

    # ./hosts/Aether
    legion-keyboard = {
      url = "github:4JX/L5P-Keyboard-RGB";
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
    # TODO: flake parts
    lib = mylib;

    nixosConfigurations = import ./hosts args;

    nixosModules = import ./nixosModules args;
    homeManagerModules = import ./homeManagerModules args;

    moduleOptions = mylib.moduleOptions; # my own field for completion in nixd, used in .neoconf.json

    overlays = {
      unstable = final: prev: {
        unstable = import inputs.nixpkgs-unstable {
          system = prev.stdenv.hostPlatform.system;
          config.allowUnfree = true;
        };
      };
    };

    devShells = mylib.forAllSystems (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
      in {
        default = pkgs.mkShell {packages = with pkgs; [alejandra nixd];};
      }
    );

    formatter = mylib.forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);
  };
}
