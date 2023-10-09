{ fetchFromGitHub
, lib
, python3Packages
, gobject-introspection
, gtk3
, pango
, wrapGAppsHook
, dbus
, xvfb-run
, chromecastSupport ? false
, serverSupport ? false
, keyringSupport ? true
, notifySupport ? true
, libnotify
, networkSupport ? true
, networkmanager
}:

python3Packages.buildPythonApplication rec {
  pname = "sublime-music";
  version = "0.12.0rc1";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "sublime-music";
    repo = pname;
    rev = "50fe929fc296c4671c963e04b893d5704eba2aea";
    sha256 = "sha256-F76htBwQnjvnwBSMgyG7QOi17BaihR1EJ//uJMFanP4=";
  };

  nativeBuildInputs = [
    python3Packages.flit-core
    gobject-introspection
    python3Packages.poetry-core
    wrapGAppsHook
  ];

  postPatch = ''
    sed -i "/--cov/d" setup.cfg
    sed -i "/--no-cov-on-fail/d" setup.cfg

    # https://github.com/sublime-music/sublime-music/commit/f477659d24e372ed6654501deebad91ae4b0b51c
    sed -i "s/python-mpv/mpv/g" pyproject.toml
  '';

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
    mpv
    peewee
    pygobject3
    python-dateutil
    python-Levenshtein
    requests
    semver
    thefuzz
  ]
  ++ lib.optional chromecastSupport PyChromecast
  ++ lib.optional keyringSupport keyring
  ++ lib.optional serverSupport bottle
  ;

  # hook for gobject-introspection doesn't like strictDeps
  # https://github.com/NixOS/nixpkgs/issues/56943
  strictDeps = false;

  # Skip checks
  doCheck = false;

  # Also run the python import check for sanity
  pythonImportsCheck = [ "sublime_music" ];

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
