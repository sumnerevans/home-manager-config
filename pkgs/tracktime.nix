{ lib, pkgs }: with pkgs;
python38Packages.buildPythonApplication rec {
  pname = "tracktime";
  version = "unstable-2021-06-03";
  format = "pyproject";

  nativeBuildInputs = [
    python3Packages.poetry
  ];

  propagatedBuildInputs = with python38Packages; [
    argcomplete
    chromedriver
    docutils
    pass
    pdfkit
    pyyaml
    requests
    selenium
    tabulate
    wkhtmltopdf
  ];

  doCheck = false;

  src = fetchFromSourcehut {
    owner = "~sumner";
    repo = pname;
    rev = "0aee0686b11d3f202a0dbabe03650da47ec22b06";
    sha256 = "sha256-WL8qSL6KQeF1BDs+Ul8l24ZiSPzfRaOLz7EzJAZRM5k=";
  };

  meta = with lib; {
    description = "Time tracking library with command line interface.";
    homepage = "https://git.sr.ht/~sumner/tracktime";
    license = licenses.gpl3Plus;
  };
}
