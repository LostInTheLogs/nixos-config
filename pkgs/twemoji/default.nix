{stdenvNoCC}:
stdenvNoCC.mkDerivation {
  pname = "twemoji";
  version = "1.0.0";

  dontConfigure = true;
  src = ./TwitterColorEmoji.tar.gz;

  unpackPhase = ''
    tar -xzf $src
  '';

  installPhase = ''
    runHook preInstall
    install -Dm755 TwitterColorEmoji.ttf $out/share/fonts/truetype/TwitterColorEmoji.ttf
    install -Dm644 fontconfig/46-twemoji-color.conf $out/etc/fonts/conf.d/46-twemoji-color.conf
    runHook postInstall
  '';

  meta = {
    description = "twemoji font";
  };
}
