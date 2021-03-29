{ config, pkgs, ... }: with pkgs; let
  # Clones projects into the ~/projects directory.
  tput = "${ncurses}/bin/tput";
  projectsyncScript = pkgs.writeShellScriptBin "projectsync" ''
    set -e

    BOLD=$(${tput} bold)
    RED=$(${tput} setaf 1)
    CLR=$(${tput} sgr 0)

    while read -ra project; do
      url=''${project[0]}
      parentdir=''${project[1]}
      rename=''${project[2]}

      if [[ ''${rename} ]]; then
        dir="$HOME/projects/''${parentdir}/''${rename}"
      else
        IFS='/' read -ra parts <<< "''${url}"
        dir="$HOME/projects/''${parentdir}/''${parts[-1]}"
      fi

      if [[ ''${dir} =~ ^.*.git$ ]]; then
        dir=''${dir::-4}
      fi

      echo "''${BOLD}Checking $dir...''${CLR}"
      if [[ -d $dir ]]; then
        echo "$dir already exists. Will not override."
      elif [[ -f $dir ]]; then
        echo "''${BOLD}''${RED}''${dir} is a file! Aborting!''${CLR}" && exit 1
      else
        echo "Cloning ''${url} into ''${dir}."
        ${git}/bin/git clone --recurse-submodules -j8 ''${url} ''${dir}
      fi
      echo
    done <"${config.home.homeDirectory}/Syncthing/projectlist"
  '';
in
{
  home.packages = [ projectsyncScript ];
}
