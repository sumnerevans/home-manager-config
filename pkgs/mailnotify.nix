{ lib, pkgs }: with pkgs;
python3Packages.buildPythonApplication rec {
  pname = "mailnotify";
  version = "unstable-2021-08-29";
  format = "pyproject";

  nativeBuildInputs = [
    gobject-introspection
    python3Packages.poetry
    wrapGAppsHook
  ];

  buildInputs = [
    libnotify
  ];

  propagatedBuildInputs = with python3Packages; [
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
    rev = "8393742b22a0ff18ab03b28eaeed5d1e0e27099d";
    sha256 = "sha256-ecI6ITx9dWjyov2/gx8NGsvlHiNfrGdGgx30CeWrw8E=";
  };

  meta = with lib; {
    description = "A small program that notifies when mail has arrived in your mail directory.";
    homepage = "https://git.sr.ht/~sumner/mailnotify";
    license = licenses.gpl3Plus;
  };
}
