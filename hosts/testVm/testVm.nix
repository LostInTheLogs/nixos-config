{
  inputs,
  pkgs,
  lib,
  ...
}: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  my.profiles.testVm.enable = true;

  # home-manager = {
  #   useUserPackages = true;
  #   extraSpecialArgs = {inherit inputs;};
  #   users = {
  #     lost = import ./home.nix;
  #   };
  # };

  programs.zsh.enable = true;
  users.users.lost = {
    isNormalUser = true;
    extraGroups = ["wheel"];
    initialPassword = "testVm";
    shell = pkgs.zsh;
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  # system.stateVersion = "24.05"; TODO: set this
}
