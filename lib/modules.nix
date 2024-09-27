{
  lib,
  inputs,
  ...
} @ args: {
  nixosModules =
    (lib.evalModules {
      modules =
        (import "${inputs.nixpkgs}/nixos/modules/module-list.nix")
        ++ [{nixpkgs.hostPlatform = "x86_64-linux";} (import ../nixosModules args).default];
      class = "nixos";
    })
    .options;

  homeManagerModules =
    (lib.evalModules {
      modules =
        import "${inputs.home-manager}/modules/modules.nix" {
          inherit lib;
          pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
        }
        ++ [
          {home.stateVersion = "24.05";}
          /*
          (import ./homeManagerModules args).default
          */
        ];
      class = "homeManager";
    })
    .options;
}
