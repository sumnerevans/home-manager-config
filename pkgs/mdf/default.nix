{ lib, fetchFromGitHub, buildGoPackage, olm }:

buildGoPackage rec {
  pname = "mdf";
  version = "0.1.0";

  goPackagePath = "github.com/sumnerevans/mdf";
  src = fetchFromGitHub {
    owner = "sumnerevans";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Dnr5p4riCEDeEgvcm1vkN3jOVP29k2FiKP3l/UknbqU=";
  };

  goDeps = ./deps.nix;

  meta = with lib; {
    description = "A simple service for helping redirect URLs.";
    homepage = "https://github.com/sumnerevans/mdf";
    license = licenses.gpl3Plus;
  };
}
