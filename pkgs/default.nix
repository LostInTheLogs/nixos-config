{
  pkgs,
  lib,
  config,
  ...
}: {
  carla = pkgs.libsForQt5.callPackage ./carla {};
  iosevka-custom = pkgs.callPackage ./iosevka-custom {};
  twemoji = pkgs.callPackage ./twemoji {};
  jetbrains = (
    lib.recurseIntoAttrs (
      pkgs.callPackages ./applications/editors/jetbrains {
        vmopts = config.jetbrains.vmopts or null;
        jdk = pkgs.jetbrains.jdk;
      }
    )
  );
}
