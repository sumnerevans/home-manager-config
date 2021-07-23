{ lib, pkgs }: with pkgs;
python3Packages.buildPythonApplication rec {
  pname = "tracktime";
  version = "0.9.20";
  format = "pyproject";

  nativeBuildInputs = [
    python3Packages.poetry
  ];

  propagatedBuildInputs = with python3Packages; [
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
    rev = "v${version}";
    sha256 = "sha256-jpl6kg+M9D+JWSOp6o6sUbdbVqdiQrv0Oez8hNaoat4=";
  };

  meta = with lib; {
    description = "Time tracking library with command line interface.";
    homepage = "https://git.sr.ht/~sumner/tracktime";
    license = licenses.gpl3Plus;
  };
}
