{inputs, ...}: {
  imports = with inputs.nixos-hardware.nixosModules; [
    common-gpu-amd
    common-gpu-nvidia
    common-gpu-nvidia-ampere
    common-gpu-nvidia-prime
  ];

  # √(2560² + 1600²) px / 16 in ≃ 189 dpi
  services.xserver.dpi = 189;

  # Still needs to load at some point if we want X11 to work
  boot.kernelModules = ["amdgpu"];

  hardware = {
    amdgpu.initrd.enable = false;

    nvidia = {
      modesetting.enable = true;
      powerManagement.enable = true;
      open = false;

      prime = {
        amdgpuBusId = "PCI:52:0:0";
        nvidiaBusId = "PCI:1:0:0";
      };
    };
  };

  specialisation = {
    # This specialisation is for the case where "DDG" (Dual-Direct GFX, A
    # hardware feature that can enable in bios) is enabled, since the amd igpu
    # is blocked at hardware level and the built-in display is directly
    # connected to the dgpu, we no longer need the amdgpu and prime
    # configuration.
    nvidia-only-ddg.configuration = {
      system.nixos.tags = ["nvidia-only-ddg"];
      services.xserver.videoDrivers = ["nvidia"];
      hardware = {
        nvidia.prime.offload.enable = false;
        amdgpu.opencl.enable = false;
      };
    };
  };
}
