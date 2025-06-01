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
      alejandra
      gh

      conda
      (pkgs.python3.withPackages (python-pkgs:
        with python-pkgs; [
          conda
          pip
        ]))
    ];
  };
}
