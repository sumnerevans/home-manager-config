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
    rev = "724b55115234709236356b9a9028664d073e4a87";
    sha256 = "sha256-rtsLQsmXbv4743v+qm4hbnA517yXEU4xt8pna5VPnkE=";
  };

  meta = with lib; {
    description = "Time tracking library with command line interface.";
    homepage = "https://git.sr.ht/~sumner/tracktime";
    license = licenses.gpl3Plus;
  };
}
