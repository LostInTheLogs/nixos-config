# https://github.com/TLATER/dotfiles/blob/4b2b93c4724265f387af7062ad7e59f6f504f506/nixos-modules/nvidia/vaapi.nix
{
  pkgs,
  config,
  lib,
  ...
}: {
  # boot.kernelPackages = pkgs.unstable.linuxPackages_6_12; # 6.11 breaks nvidia

  # boot.kernelPackages = pkgs.linuxKernel.packages.linux_xanmod;

  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {
    # package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
    #   version = "565.77";
    #   sha256_64bit = "sha256-CnqnQsRrzzTXZpgkAtF7PbH9s7wbiTRNcM0SPByzFHw=";
    #   sha256_aarch64 = lib.fakeHash;
    #   openSha256 = "sha256-Fxo0t61KQDs71YA8u7arY+503wkAc1foaa51vi2Pl5I=";
    #   settingsSha256 = "sha256-VUetj3LlOSz/LB+DDfMCN34uA4bNTTpjDrb6C6Iwukk=";
    #   persistencedSha256 = lib.fakeHash;
    # };
    modesetting.enable = true;
    powerManagement.enable = true;
    powerManagement.finegrained = false;
    open = true;
  };

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      nvidia-vaapi-driver
    ];
  };

  environment.variables = {
    # Required to run the correct GBM backend for nvidia GPUs on wayland
    GBM_BACKEND = "nvidia-drm";
    # Apparently, without this nouveau may attempt to be used instead
    # (despite it being blacklisted)
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    # Hardware cursors are currently broken on wlroots
    # WLR_NO_HARDWARE_CURSORS = "1";

    # va api
    NVD_BACKEND = "direct";
    LIBVA_DRIVER_NAME = "nvidia";
    MOZ_DISABLE_RDD_SANDBOX = "1";
  };

  environment.systemPackages = with pkgs; [libva-utils nvtopPackages.nvidia];

  # va api
  programs.firefox.preferences = {
    "media.hardware-video-decoding.force-enabled" = true;
    "media.ffmpeg.vaapi.enabled" = true;
    "media.rdd-ffmpeg.enabled" = true;
    "media.av1.enabled" = true;
    "gfx.x11-egl.force-enabled" = true;
    "widget.dmabuf.force-enabled" = true;
  };
}
