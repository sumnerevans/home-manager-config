{ lib, pkgs, ... }: let
  set-contact-photo = pkgs.writeScriptBin "set-contact-photo"
    (builtins.readFile ./bin/set-contact-photo.py);
in
{
  imports = [
    ./projectsync.nix
    ./sl.nix
  ];

  home.packages = [
    set-contact-photo
  ];
}
