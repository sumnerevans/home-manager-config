{ pkgs, ... }: {
  services.blueman-applet.enable = true;

  # TODO clipmenu

  # TODO dunst on i3

  # TODO gammastep/redshift/wlsunset

  # TODO getmail?

  # TODO gnome-keyring

  # TODO gpg-agent

  # TODO imapnotify?

  # TODO kanshi for sway?

  services.kdeconnect = { enable = true; indicator = true; };

  # TODO mbsync

  services.network-manager-applet.enable = true;

  # TODO
  # services.password-store-sync.enable

  # TODO picom when on X11

  # TODO syncthing

  # TODO udiskie

  # TODO convert to using systemd.user.services

  # TODO use systemd.user.sessionVariables

  # use systemd.user.startServices?

  # use systemd.user.tmpfiles.rules?

  # usewayland.windowManager.sway.enable

  xdg = {
    enable = true;
    # TODO mimeTypes?
    # TODO userDirs?
  };
}
