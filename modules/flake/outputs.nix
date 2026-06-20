{...}: {
  perSystem = {pkgs, ...}: {
    devShells = {
      default = pkgs.mkShell {packages = with pkgs; [alejandra nixd deadnix];};
    };
  };
}
