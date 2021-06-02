{ lib, pkgs }: with pkgs;
python38Packages.buildPythonApplication rec {
  pname = "tracktime";
  version = "0.9.19";

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

  src = python38.pkgs.fetchPypi {
    inherit pname version;
    sha256 = "sha256-iHshWTPTIX4ztC2EQeWJ/fb/8I1f5q/eNA6JE4IwlKo=";
  };

  meta = with lib; {
    description = "Time tracking library with command line interface.";
    homepage = "https://git.sr.ht/~sumner/tracktime";
    license = licenses.gpl3Plus;
  };
}
