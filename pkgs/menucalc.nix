{ lib, pkgs }:
with pkgs;
stdenv.mkDerivation rec {
  pname = "menucalc";
  version = "v1.3.0";

  src = fetchFromGitHub {
    owner = "sumnerevans";
    repo = "menu-calc";
    rev = "1728157d4e06966f6ecfcd5c5cb1216291a0ff78";
    sha256 = "sha256-Gx5SXg20mYvz0jZTmelJZIuI8hNEWSt+cViPSMl4W6Q=";
  };

  buildInputs = [ makeWrapper ];

  dontBuild = true;

  installPhase = ''
    mkdir -p "$out/bin"
    install -D -m755 ./= "$out/bin/="
    mkdir -p "$out/share/man/man1"
    install -D -m644 ./=.1 "$out/share/man/man1/=.1"
    install -D -m644 ./menu-calc.1 "$out/share/man/man1/menu-calc.1"
  '';

  wrapperPath = with lib; makeBinPath [ bc rofi xclip wl-clipboard ];

  fixupPhase = ''
    patchShebangs $out/bin
    wrapProgram $out/bin/= --prefix PATH : "${wrapperPath}"
  '';

  meta = {
    description = "A calculator for Rofi/dmenu(2)";
    homepage = "https://github.com/sumnerevans/menu-calc";
    # maintainers = with stdenv.lib.maintainers; [ sumnerevans ];
    license = lib.licenses.mit;
    platforms = with lib.platforms; linux;
  };
}
