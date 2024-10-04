{
  lib,
  config,
  ...
}: let
  cfg = config.my.profiles.music;
in {
  options.my.profiles.music.enable = lib.mkEnableOption "the music profile";

  config = lib.mkIf cfg.enable {
    # sth
  };
}
