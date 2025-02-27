{pkgs, ...}: {
  environment.systemPackages = with pkgs; [git pciutils btop];
}
