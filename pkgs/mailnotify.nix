{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "mailnotify";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "sumnerevans";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-KPgOtNPK4tE9hzFd7sJwIxRbwh2KFXu/1/m4GT/MBYU=";
  };

  vendorHash = "sha256-KPAAAAAK4tE9hzFd7sJwIxRbwh2KFXu/1/m4GT/MBYU=";

  meta = with lib; {
    description = "A small program that notifies when mail has arrived in your mail directory.";
    homepage = "https://github.com/sumnerevans/mailnotify";
    license = licenses.gpl3Plus;
  };
}
