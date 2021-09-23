{ lib, pkgs }: with pkgs;
python3Packages.buildPythonApplication rec {
  pname = "tracktime";
  version = "0.9.21rc1";
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
    rev = "1c4cea12160505dab60c96d02dc1b40bfe929603";
    sha256 = "sha256-WkFCon9rj6+TyWQ326f7jEXx9cAJNMoUIp33fm4gnrk=";
  };

  meta = with lib; {
    description = "Time tracking library with command line interface.";
    homepage = "https://git.sr.ht/~sumner/tracktime";
    license = licenses.gpl3Plus;
  };
}
