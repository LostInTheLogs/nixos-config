{inputs, config, lib, ...}: {
  imports = with inputs.nixos-hardware.nixosModules; 
    [ common-gpu-amd
      common-gpu-nvidia 
    ];

  # √(2560² + 1600²) px / 16 in ≃ 189 dpi
  services.xserver.dpi = 189;

  # Enable OpenGL 
  hardware.opengl = { enable = true; };

  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {

    # Modesetting is required.
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to
    # fail. Enable this if you have graphical corruption issues or application
    # crashes after waking up from sleep. This fixes it by saving the entire
    # VRAM memory to /tmp/ instead of just the bare essentials.
    powerManagement.enable = false;

    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = true;

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver). Support is limited
    # to the Turing and later architectures. Full list of supported GPUs is at:
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus Only
    # available from driver 515.43.04+ Currently alpha-quality/buggy, so false
    # is currently the recommended setting.
    open = false;

    # Enable the Nvidia settings menu, accessible via `nvidia-settings`.
    nvidiaSettings = true;

    prime = { 
      offload = { enable = true; enableOffloadCmd = true; };
      amdgpuBusId = "PCI:52:0:0"; 
      nvidiaBusId = "PCI:1:0:0";
    };

    # Optionally, you may need to select the appropriate driver version for
    # your specific GPU.
    # package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  # # Still needs to load at some point if we want X11 to work
  # boot.kernelModules = ["amdgpu"];
  # hardware = { amdgpu.initrd.enable = false;

  specialisation = {
    # This specialisation is for the case where "DDG" (Dual-Direct GFX, A
    # hardware feature that can enable in bios) is enabled, since the amd igpu
    # is blocked at hardware level and the built-in display is directly
    # connected to the dgpu, we no longer need the amdgpu and prime
    # configuration.
    nvidia-only-ddg.configuration = { system.nixos.tags = ["nvidia-only-ddg"];
      services.xserver.videoDrivers = ["nvidia"]; hardware = {
        nvidia.prime.offload.enable = lib.mkForce false;
        nvidia.prime.offload.enableOffloadCmd = lib.mkForce false;
        nvidia.powerManagement.finegrained = lib.mkForce false;
        amdgpu.opencl.enable = false; 
      }; 
    }; 
  };
}
