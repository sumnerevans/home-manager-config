{ lib, fetchFromGitHub, buildGoPackage, olm }:

buildGoPackage rec {
  pname = "mdf";
  version = "0.1.0";

  goPackagePath = "github.com/sumnerevans/mdf";
  src = fetchFromGitHub {
    owner = "sumnerevans";
    repo = pname;
    rev = "b7d1a6264326f7d598252eecf8002329c6c68cd9";
    sha256 = "sha256-yV42TKzBwwY2iyCn33AwvlFO3KfKLb4hehjD+kXZnLE=";
  };

  goDeps = ./deps.nix;

  meta = with lib; {
    description = "A simple service for helping redirect URLs.";
    homepage = "https://github.com/sumnerevans/mdf";
    license = licenses.gpl3Plus;
  };
}
