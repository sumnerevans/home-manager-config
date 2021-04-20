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
    rev = "77b19538f9cf40b10bf063df2f324b4f4fbf9667";
    sha256 = "sha256-mwS7FIcEDVecyD57C5YEMSW5LEvzF1ZgaEbfeC0c04k=";
  };

  meta = with lib; {
    description = "A small program that notifies when mail has arrived in your mail directory.";
    homepage = "https://git.sr.ht/~sumner/mailnotify";
    license = licenses.gpl3Plus;
  };
}
