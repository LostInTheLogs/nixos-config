{
  pkgs,
  lib,
  osConfig,
  ...
}: {
  config = lib.mkIf osConfig.my.profiles.development.enable {
    home.packages = with pkgs; [
      stow
      just
      gnumake

      zellij
      vscodium-fhs
      neovim
      nixd
      alejandra
      gh

      # tmp
      nodejs
      pnpm
      gcc
      unzip

      conda
      (pkgs.python3.withPackages (python-pkgs:
        with python-pkgs; [
          conda
          pip
        ]))

      tokei
    ];

    programs.atuin = {
      enable = true;
      flags = [
        "--disable-up-arrow"
      ];
      settings = {
        auto_sync = true;
        sync_frequency = "5m";
        sync_address = "https://api.atuin.sh";
        search_mode = "fuzzy";
      };
    };
  };
}
