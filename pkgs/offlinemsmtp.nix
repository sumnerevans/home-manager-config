{ lib, pkgs }: with pkgs;
python3Packages.buildPythonApplication rec {
  pname = "offlinemsmtp";
  version = "0.4.0";
  format = "pyproject";

  src = pkgs.fetchFromGitHub {
    owner = "sumnerevans";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-k9X7TCiBDq3fDlCZa0eyH3Z6IDCvVjpGvQCoO4bsw5Q=";
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
    inotify
    msmtp
    pass
    pygobject3
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
