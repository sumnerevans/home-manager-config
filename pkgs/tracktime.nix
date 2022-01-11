{ lib, pkgs }: with pkgs;
python3Packages.buildPythonApplication rec {
  pname = "tracktime";
  version = "0.10.0";
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
    rev = "cd3bbb228f5d7b7037223ca34755ec2be05d0535";
    sha256 = "sha256-86o4wBJwkFgsc2+WS7mGijkgU139e2CJyFuXcWVOK78=";
  };

  meta = with lib; {
    description = "Time tracking library with command line interface.";
    homepage = "https://git.sr.ht/~sumner/tracktime";
    license = licenses.gpl3Plus;
  };
}
