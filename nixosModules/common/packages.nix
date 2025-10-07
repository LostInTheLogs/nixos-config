{pkgs, ...}: {
  environment.systemPackages = with pkgs; [smartmontools busybox git pciutils btop p7zip];
}
