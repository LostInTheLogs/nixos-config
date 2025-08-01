{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch2,
  alsa-lib,
  file,
  fluidsynth,
  jack2,
  liblo,
  libpulseaudio,
  libsndfile,
  pkg-config,
  python3Packages,
  which,
  gtk2 ? null,
  gtk3 ? null,
  qtbase ? null,
  withFrontend ? true,
  withGtk2 ? true,
  withGtk3 ? true,
  withQt ? true,
  wrapQtAppsHook ? null,
}:
assert withQt -> qtbase != null;
assert withQt -> wrapQtAppsHook != null;
  stdenv.mkDerivation (finalAttrs: {
    pname = "carla";
    version = "2.5.9";

    src = fetchFromGitHub {
      owner = "falkTX";
      repo = "carla";
      rev = "v${finalAttrs.version}";
      hash = "sha256-FM/6TtNhDml1V9C5VisjLcZ3CzXsuwCZrsoz4yP3kI8=";
    };

    patches = [
      (fetchpatch2 {
        # https://github.com/falkTX/Carla/pull/1933
        name = "prefer-pyliblo3-over-pyliblo.patch";
        url = "https://github.com/falkTX/Carla/commit/a81a2a545d2529233a6e0faa776fbd2d851442fb.patch?full_index=1";
        hash = "sha256-CHK3Aq/W9PdfMGsJunLN/WAxOmWJHc0jr/3TdEaIcMM=";
      })
    ];

    nativeBuildInputs = [
      python3Packages.wrapPython
      pkg-config
      which
      wrapQtAppsHook
    ];

    pythonPath = with python3Packages;
      [
        rdflib
        pyliblo3
      ]
      ++ lib.optional withFrontend pyqt5;

    buildInputs =
      [
        file
        liblo
        alsa-lib
        fluidsynth
        jack2
        libpulseaudio
        libsndfile
      ]
      ++ lib.optional withQt qtbase
      ++ lib.optional withGtk2 gtk2
      ++ lib.optional withGtk3 gtk3;

    propagatedBuildInputs = finalAttrs.pythonPath;

    enableParallelBuilding = true;

    installFlags = ["PREFIX=$(out)"];

    postPatch =
      ''
        # --with-appname="$0" is evaluated with $0=.carla-wrapped instead of carla. Fix that.
        for file in $(grep -rl -- '--with-appname="$0"'); do
            filename="$(basename -- "$file")"
            substituteInPlace "$file" --replace '--with-appname="$0"' "--with-appname=\"$filename\""
        done
      ''
      + lib.optionalString withGtk2 ''
        # Will try to dlopen() libgtk-x11-2.0 at runtime when using the bridge.
        substituteInPlace source/bridges-ui/Makefile \
            --replace '$(CXX) $(OBJS_GTK2)' '$(CXX) $(OBJS_GTK2) -lgtk-x11-2.0'
      '';

    dontWrapQtApps = true;
    postFixup = ''
      # Also sets program_PYTHONPATH and program_PATH variables
      wrapPythonPrograms
      wrapPythonProgramsIn "$out/share/carla/resources" "$out $pythonPath"

      find "$out/share/carla" -maxdepth 1 -type f -not -name "*.py" -print0 | while read -d "" f; do
        patchPythonScript "$f"
      done
      # patchPythonScript "$out/share/carla/carla_settings.py" COMMENTING FIXES https://github.com/NixOS/nixpkgs/issues/273403

      for program in $out/bin/*; do
        wrapQtApp "$program" \
          --prefix PATH : "$program_PATH:${which}/bin" \
          --set PYTHONNOUSERSITE true
      done

      find "$out/share/carla/resources" -maxdepth 1 -type f -not -name "*.py" -print0 | while read -d "" f; do
        wrapQtApp "$f" \
          --prefix PATH : "$program_PATH:${which}/bin" \
          --set PYTHONNOUSERSITE true
      done
    '';

    meta = with lib; {
      homepage = "https://kx.studio/Applications:Carla";
      description = "Audio plugin host";
      longDescription = ''
        It currently supports LADSPA (including LRDF), DSSI, LV2, VST2/3
        and AU plugin formats, plus GIG, SF2 and SFZ file support.
        It uses JACK as the default and preferred audio driver but also
        supports native drivers like ALSA, DirectSound or CoreAudio.
      '';
      license = licenses.gpl2Plus;
      maintainers = [maintainers.minijackson];
      platforms = platforms.linux;
    };
  })
