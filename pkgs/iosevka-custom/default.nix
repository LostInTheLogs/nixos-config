{stdenvNoCC}:
stdenvNoCC.mkDerivation {
  pname = "iosevka-custom";
  version = "1.0.0";

  dontConfigure = true;
  src = ./iosevka_custom.tar.gz;

  unpackPhase = ''
    tar -xzf $src
  '';

  installPhase = ''
    mkdir -p $out/share/fonts
    cp -r . $out/share/fonts/
  '';

  meta = {
    description = "iosevka custom font";
  };
}
