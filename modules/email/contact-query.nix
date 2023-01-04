{ lib, pkgs, ... }:
let
  contact-query = pkgs.writeScriptBin "contact-query" (builtins.readFile ./bin/contact-query.py);
  contact-search = pkgs.writeScriptBin "contact-search" (builtins.readFile ./bin/contact-search.py);
in
{
  home.packages = [
    contact-query
    contact-search
  ];

  programs.neomutt.extraConfig = ''
    set query_command="${contact-query}/bin/contact-query %s"
  '';

  xdg.configFile."contact-query/config".text = ''
    ${lib.removeSuffix "\n" (builtins.readFile ../../secrets/gitlab-email-key)}
    ColoradoSchoolOfMines
  '';
}
