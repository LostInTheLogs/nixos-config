# this module is used for lsp completion of options form my nixos and home-manager modules
{
  lib,
  inputs,
  ...
} @ args: {
  nixosModules =
    (lib.evalModules {
      modules =
        (import "${inputs.nixpkgs}/nixos/modules/module-list.nix")
        ++ [
          {nixpkgs.hostPlatform = "x86_64-linux";}
          (inputs.home-manager.nixosModules.home-manager)
          (import ../nixosModules args).default
        ];
      class = "nixos";
      specialArgs = {inherit inputs;};
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
      specialArgs = {inherit inputs;};
    })
    .options;
}
