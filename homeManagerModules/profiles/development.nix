{
  pkgs,
  lib,
  osConfig,
  ...
}: {
  config = lib.mkIf osConfig.my.profiles.development.enable {
    home.packages = with pkgs; [
      vscodium-fhs
      neovim
      nixd
    ];
  };
}
