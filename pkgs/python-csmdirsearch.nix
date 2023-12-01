{ pkgs }:
with pkgs;
python3.pkgs.buildPythonPackage rec {
  pname = "csmdirsearch";
  version = "0.1.1";

  src = python3.pkgs.fetchPypi {
    inherit pname version;
    sha256 = "b44539ab0fbd135aade9c99d9c0c4508870cafd4fcec70a01a1c760a5731a760";
  };

  propagatedBuildInputs = with python3Packages; [ beautifulsoup4 requests ];

  doCheck = false;
  checkPhase = "";
}
