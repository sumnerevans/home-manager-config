{ fetchFromGitLab
, lib
, pkgs
, python3Packages
, gobject-introspection
, gtk3
, pango
, wrapGAppsHook
, xvfb_run
, chromecastSupport ? false
, serverSupport ? false
, keyringSupport ? true
, notifySupport ? true, libnotify
, networkSupport ? true, networkmanager
}:

python3Packages.buildPythonApplication rec {
  pname = "sublime-music";
  version = "0.11.11";
  format = "pyproject";

  src = fetchFromGitLab {
    owner = "sublime-music";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-r4Tn/7CGDny8Aa4kF4PM5ZKMYthMJ7801X3zPdvXh4Q=";
  };

  nativeBuildInputs = [
    gobject-introspection
    python3Packages.poetry
    wrapGAppsHook
  ];

  buildInputs = [
    gtk3
    pango
  ]
   ++ lib.optional notifySupport libnotify
   ++ lib.optional networkSupport networkmanager
  ;

  propagatedBuildInputs = with python3Packages; [
    bleach
    dataclasses-json
    deepdiff
    fuzzywuzzy
    (mpv.overrideAttrs (old: {
      postPatch = ''
        substituteInPlace mpv.py \
          --replace "sofile = ctypes.util.find_library('mpv')" \
                    'sofile = "${pkgs.mpv}/lib/libmpv${pkgs.stdenv.targetPlatform.extensions.sharedLibrary}"'
      '';
    }))
    peewee
    pygobject3
    python-Levenshtein
    python-dateutil
    requests
    semver
  ]
   ++ lib.optional chromecastSupport PyChromecast
   ++ lib.optional keyringSupport keyring
   ++ lib.optional serverSupport bottle
  ;

  # hook for gobject-introspection doesn't like strictDeps
  # https://github.com/NixOS/nixpkgs/issues/56943
  strictDeps = false;

  # Use the test suite provided by the upstream project.
  checkInputs = with python3Packages; [
    pytest
    pytest-cov
  ];
  checkPhase = "${xvfb_run}/bin/xvfb-run pytest";

  postInstall = ''
    install -Dm444 sublime-music.desktop      -t $out/share/applications
    install -Dm444 sublime-music.metainfo.xml -t $out/share/metainfo

    for size in 16 22 32 48 64 72 96 128 192 512 1024; do
        install -Dm444 logo/rendered/"$size".png \
          $out/share/icons/hicolor/"$size"x"$size"/apps/sublime-music.png
    done
  '';

  meta = with lib; {
    description = "GTK3 Subsonic/Airsonic client";
    homepage = "https://sublimemusic.app/";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ albakham sumnerevans ];
  };
}
