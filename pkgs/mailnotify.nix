{ lib, pkgs }: with pkgs;
python3Packages.buildPythonApplication rec {
  pname = "mailnotify";
  version = "0.0.1";
  format = "pyproject";

  nativeBuildInputs = [
    gobject-introspection
    python3Packages.poetry
    wrapGAppsHook
  ];

  buildInputs = [
    libnotify
  ];

  propagatedBuildInputs = with python38Packages; [
    bleach
    pygobject3
    watchdog
  ];

  # no tests
  doCheck = false;

  # hook for gobject-introspection doesn't like strictDeps
  # https://github.com/NixOS/nixpkgs/issues/56943
  strictDeps = false;

  src = fetchFromSourcehut {
    owner = "~sumner";
    repo = pname;
    rev = "06499f01ba9b86a0e5ce0099305f012476bea391";
    sha256 = "sha256-cmAILZ3QUBTCkKonsVQcJ8DW4DWwvaKWTE6eCPNAnmU=";
  };

  meta = with lib; {
    description = "A small program that notifies when mail has arrived in your mail directory.";
    homepage = "https://git.sr.ht/~sumner/mailnotify";
    license = licenses.gpl3Plus;
  };
}
