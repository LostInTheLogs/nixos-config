{
  description = "TODO";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-25.11";
    # nixpkgs.url = "nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      # url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";

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

    # music profile
    musnix = {
      url = "github:musnix/musnix";
    };

    # desktop profile
    dimland.url = "github:keifufu/dimland";
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

    overlays = {
      unstable = final: prev: {
        unstable = import inputs.nixpkgs-unstable {
          system = prev.stdenv.hostPlatform.system;
          config.allowUnfree = true;
        };
      };

      my = final: prev: {my = import ./pkgs {pkgs = prev;};};
    };

    devShells = mylib.forAllSystems (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
      in {
        default = pkgs.mkShell {packages = with pkgs; [alejandra nixd deadnix];};
      }
    );

    packages = mylib.forAllSystems (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
      in (import ./pkgs (args // {inherit pkgs;}))
    );

    formatter = mylib.forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);
  };
}
