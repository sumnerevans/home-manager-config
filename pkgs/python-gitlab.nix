{ lib, pkgs }: with pkgs;
pkgs.python3.pkgs.buildPythonPackage rec {
  pname = "python-gitlab";
  version = "2.5.0";

  src = pkgs.python3.pkgs.fetchPypi {
    inherit pname version;
    sha256 = "68b42aafd4b620ab2534ff78a52584c7f799e4e55d5ac297eab4263066e6f74b";
  };

  propagatedBuildInputs = with python3Packages; [
    requests
  ];
  doCheck = false;
  checkPhase = "";
}
