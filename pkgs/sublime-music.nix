{ fetchFromGitLab, lib, python3Packages, gobject-introspection, gtk3, pango, wrapGAppsHook

, chromecastSupport ? true
, serverSupport ? true
, keyringSupport ? true
, notifySupport ? true, libnotify
, networkSupport ? true, networkmanager
}:

python3Packages.buildPythonApplication rec {
  pname = "sublime-music";
  version = "0.11.11";

  # src = /home/sumner/projects/sublime-music/sublime-music;
  src = fetchFromGitLab {
    owner = "sublime-music";
    repo = pname;
    rev = "v${version}";
    sha256 = "1147szdkvwvxslsby9scv1i8r4p5rj1if95f06y7q3l6n3zyg15g";
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
