{pkgs, ...}: {
  carla = pkgs.libsForQt5.callPackage ./carla {};
}
