# https://github.com/EdenEast/nyx/blob/main/lib/default.nix
{inputs, ...} @ args: let
  lib = inputs.nixpkgs.lib;
in {
  forAllSystems = lib.genAttrs [
    "aarch64-linux"
    "i686-linux"
    "x86_64-linux"
    "aarch64-darwin"
    "x86_64-darwin"
  ];

  mkHost = name:
    lib.nixosSystem {
      modules = [
        inputs.self.nixosModules.default
        ../hosts/${name}/${name}.nix
        ({...}: {
          networking.hostName = lib.mkDefault name;
        })
      ];
      specialArgs = {
        inherit inputs;
        mylib = inputs.self.lib;
      };
    };

  fs = import ./fs.nix args;
}
