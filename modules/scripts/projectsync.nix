{ config, pkgs, ... }:
with pkgs;
let
  # Clones projects into the ~/projects directory.
  git-get = pkgs.callPackage ../../pkgs/git-get.nix { };

  tput = "${ncurses}/bin/tput";
  projectsyncScript = pkgs.writeShellScriptBin "projectsync" ''
    set -xe
    while read -ra project; do
      ${git-get}/bin/git-get -r $(git config gitget.root) $project
    done <"${config.home.homeDirectory}/Syncthing/projectlist"
  '';
in
{ home.packages = [ projectsyncScript ]; }
