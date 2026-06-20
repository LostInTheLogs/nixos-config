# enables `nix run .#run-test-vm`. it is very useful to have a VM
# you can edit your config and launch the VM to test stuff
# instead of having to reboot each time.
{
  inputs,
  lib,
  den,
  ...
}: {
  den.aspects.test-vm = {
    includes = [
      den.aspects.common
      den.aspects.profiles._
      den.aspects.kitty
      den.aspects.zsh
    ];

    nixos = {pkgs, ...}: {
      fileSystems."/".device = "/dev/noroot";
      fileSystems."/".fsType = "auto";
      boot.loader.grub.enable = false;

      virtualisation.vmVariant.virtualisation = {
        memorySize = 8192;
        cores = 6;
      };

      system.stateVersion = lib.mkForce "26.05";
    };
  };

  perSystem = {pkgs, ...}: {
    packages.run-test-vm = pkgs.writeShellApplication {
      name = "run-test-vm";
      text = let
        host = inputs.self.nixosConfigurations.test-vm.config;
      in ''
        NIX_DISK_IMAGE="$(mktemp -d)/image.qcow2"
        export NIX_DISK_IMAGE
        ${host.system.build.vm}/bin/run-${host.networking.hostName}-vm "$@"
      '';
    };
  };
}
