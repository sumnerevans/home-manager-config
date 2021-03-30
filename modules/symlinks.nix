{ config, lib, pkgs, ... }: with lib; let
  cu = "${pkgs.coreutils}/bin";
  homedir = "${config.home.homeDirectory}";
  configdir = "${config.xdg.configHome}";
  syncthing = "${homedir}/Syncthing";
  symlinks = [
    {
      target = "${syncthing}/.ssh/config";
      destination = "${homedir}/.ssh/config";
    }
    {
      target = "${syncthing}/.config/neomutt/aliases";
      destination = "${homedir}/.config/neomutt/aliases";
    }
    {
      target = "${syncthing}/.config/neomutt/mailboxes";
      destination = "${homedir}/.config/neomutt/mailboxes";
    }
  ];

  toSymlinkCmd = { target, destination }: ''
    $DRY_RUN_CMD ${cu}/mkdir -p $(${cu}/dirname ${destination})
    $DRY_RUN_CMD ${cu}/ln -sf $VERBOSE_ARG \
      ${target} ${destination}
  '';
in
{
  home.activation.symlinks = hm.dag.entryAfter [ "writeBoundary" ]
    (concatMapStringsSep "\n" toSymlinkCmd symlinks);
}
