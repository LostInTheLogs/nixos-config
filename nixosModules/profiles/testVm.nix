# https://github.com/jecaro/simple-nix-vm
# https://discourse.nixos.org/t/get-qemu-guest-integration-when-running-nixos-rebuild-build-vm/22621
# https://www.spice-space.org/spice-user-manual.html#agent
{
  pkgs,
  modulesPath,
  lib,
  config,
  ...
}: let
  cfg = config.my.profiles.testVm;
in {
  options.my.profiles.testVm.enable = lib.mkEnableOption "the testVm profile, used for `nixos-rebuild build-vm` VMs";

  config = lib.mkIf cfg.enable {
    #https://github.com/NixOS/nixpkgs/blob/5ad2def3ab0a690cdff75e584984a7a6911597ab/nixos/modules/profiles/qemu-guest.nix
    boot.initrd.availableKernelModules = ["virtio_net" "virtio_pci" "virtio_mmio" "virtio_blk" "virtio_scsi" "9p" "9pnet_virtio"];
    boot.initrd.kernelModules = ["virtio_balloon" "virtio_console" "virtio_rng" "virtio_gpu"];

    services.spice-vdagentd.enable = true;

    virtualisation.vmVariant.virtualisation = {
      memorySize = 8192;
      cores = 6;
      qemu.options = [
        "-machine vmport=off"
        "-vga qxl"
        "-spice port=3001,disable-ticketing=on "
        "-device virtio-serial"
        "-chardev spicevmc,id=vdagent,debug=0,name=vdagent"
        "-device virtserialport,chardev=vdagent,name=com.redhat.spice.0"
      ];
    };

    system.build.customVm = pkgs.writeShellApplication {
      name = "run-test-vm";
      runtimeInputs = [pkgs.virt-viewer];
      text = ''
        NIX_DISK_IMAGE="$(mktemp -d)/image.qcow2"
        export NIX_DISK_IMAGE
        ${config.system.build.vm}/bin/run-testVm-vm & PID_QEMU="$!"
        sleep 1
        remote-viewer spice://127.0.0.1:3001
        kill $PID_QEMU
        rm -rf "$NIX_DISK_IMAGE"
      '';
    };
  };
}
