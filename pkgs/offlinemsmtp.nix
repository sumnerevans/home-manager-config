{ lib, pkgs }: with pkgs;
python3Packages.buildPythonApplication rec {
  pname = "offlinemsmtp";
  version = "0.3.11rc1";
  format = "pyproject";

  src = pkgs.fetchFromGitHub {
    owner = "sumnerevans";
    repo = pname;
    rev = "ee1318b8b8b3e9ae663909e384b2e6533b221946";
    sha256 = "sha256-49s/7M2RWX1uXxRQyxcDdx5iHISTzXqU7cu6BVpTWhw=";
  };

  nativeBuildInputs = [
    python3Packages.poetry-core
    gobject-introspection
    python3Packages.setuptools
    wrapGAppsHook
  ];

  buildInputs = [
    libnotify
  ];

  propagatedBuildInputs = with python3Packages; [
    msmtp
    pass
    pygobject3
    watchdog
  ];

  pythonImportsCheck = [
    "offlinemsmtp"
  ];

  # hook for gobject-introspection doesn't like strictDeps
  # https://github.com/NixOS/nixpkgs/issues/56943
  strictDeps = false;

  meta = with lib; {
    description = "msmtp wrapper allowing for offline use";
    homepage = "https://github.com/sumnerevans/offlinemsmtp";
    license = licenses.gpl3Plus;
  };
}
