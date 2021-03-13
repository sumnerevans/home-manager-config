{ fetchFromGitLab
, gobject-introspection
, gtk3
, lib
, networkmanager
, python3
, pango
, python
, python3Packages
, wrapGAppsHook

, chromecastSupport ? true
, serverSupport ? true
, keyringSupport ? true
, notifySupport ? true
, libnotify
, networkSupport ? true
}:
python3Packages.buildPythonApplication rec {
  pname = "sublime_music";
  version = "0.11.11";

  src = python3.pkgs.fetchPypi {
    inherit pname version;
    sha256 = "0h5fhsl7zcvdrgawa0p118jzjs5ws1rlwbwv05klvdhzzrx2xwrs";
  };

  nativeBuildInputs = [
    gobject-introspection
    python3Packages.setuptools
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
    mpv
    peewee
    pygobject3
    python-dateutil
    python-Levenshtein
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
    maintainers = with maintainers; [ albakham ];
  };
}
