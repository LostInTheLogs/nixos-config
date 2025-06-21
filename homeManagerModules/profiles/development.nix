{
  pkgs,
  lib,
  osConfig,
  ...
}: {
  config = lib.mkIf osConfig.my.profiles.development.enable {
    home.packages = with pkgs; [
      stow

      vscodium-fhs
      neovim
      nixd
      alejandra
      gh

      # tmp
      nodejs
      gcc
      unzip

      conda
      (pkgs.python3.withPackages (python-pkgs:
        with python-pkgs; [
          conda
          pip
        ]))
    ];
  };
}
