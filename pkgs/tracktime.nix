{ lib, pkgs }:
with pkgs;
python3Packages.buildPythonApplication rec {
  pname = "tracktime";
  version = "0.10.0";
  format = "pyproject";

  nativeBuildInputs = [ python3Packages.poetry-core ];

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
    # wkhtmltopdf
  ];

  doCheck = false;

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'requires = ["poetry>=0.12"]' 'requires = ["poetry-core>=1.0.0"]'
    substituteInPlace pyproject.toml \
      --replace 'build-backend = "poetry.masonry.api"' 'build-backend = "poetry.core.masonry.api"'
    substituteInPlace pyproject.toml \
      --replace 'tabulate = "^0.8.7"' 'tabulate = ">=0.8.7"'
  '';

  src = fetchFromGitHub {
    owner = "sumnerevans";
    repo = pname;
    rev = "bb965fb84c649ce1c57e5549dbdd69ffc3644014";
    sha256 = "sha256-1kwmBlZya71jFPS4G7lkVo7iwxrKv2W0GbP4onciBps=";
  };

  meta = with lib; {
    description = "Time tracking library with command line interface.";
    homepage = "https://github.com/sumnerevans/tracktime";
    license = licenses.gpl3Plus;
  };
}
