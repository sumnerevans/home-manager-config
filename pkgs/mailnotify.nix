{ lib, pkgs }: with pkgs;
python3Packages.buildPythonApplication rec {
  pname = "mailnotify";
  version = "0.3.8";
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
    rev = "8d64e6863c0e80bd0abf6918343879a76cda296a";
    sha256 = "sha256-jdsCnIxLJEZFrvdErO2MEjX8/v5ZH9f+qK+ARuZmNnc=";
  };

  meta = with lib; {
    description = "A small program that notifies when mail has arrived in your mail directory.";
    homepage = "https://git.sr.ht/~sumner/mailnotify";
    license = licenses.gpl3Plus;
  };
}
