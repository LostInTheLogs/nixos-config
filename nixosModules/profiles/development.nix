{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.my.profiles.development;
in {
  options.my.profiles.development.enable = lib.mkEnableOption "the development profile";

  config = lib.mkIf cfg.enable {
    fonts.packages = with pkgs; [fira-code-nerdfont];

    environment.systemPackages = with pkgs; [
      xclip
      wl-clipboard

      alejandra
      nixd
      gcc
      nodejs
      lua
      lua-language-server
    ];
    # sth
  };
}
