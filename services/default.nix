{ pkgs, ... }: {
  imports = [
    ./offlinemsmtp.nix
    ./vdirsyncer.nix
    ./wallpaper.nix
    ./writeping.nix
  ];

  services.blueman-applet.enable = true;

  # TODO clipmenu if on X11
  # services.clipmenu.enable = true;
  # home.sessionVariables = {
  #   CM_HISTLENGTH = "20";
  #   CM_LAUNCHER = "rofi";
  # };

  # TODO dunst on i3

  # TODO use redshift when on i3
  services.gammastep = {
    enable = true;
    provider = "geoclue2";
    tray = true;

    temperature = {
      day = 5500;
      night = 4000;
    };
  };

  # TODO gnome-keyring

  # Make the gpg-agent work
  services.gpg-agent = let
    ttl = 60 * 60 * 4; # 4 hours
  in
    {
      enable = true;
      defaultCacheTtl = ttl;
      maxCacheTtl = ttl;
      pinentryFlavor = "gnome3";
      verbose = true;
    };

  # TODO kanshi for sway?

  services.kdeconnect = { enable = true; indicator = true; };

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
