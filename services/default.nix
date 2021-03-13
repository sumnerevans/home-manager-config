{ pkgs, ... }: {
  imports = [
    ./offlinemsmtp.nix
    ./vdirsyncer.nix
    ./wallpaper.nix
    ./window-manager
    ./writeping.nix
  ];

  services.blueman-applet.enable = true;

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

  services.kdeconnect = { enable = true; indicator = true; };

  services.network-manager-applet.enable = true;

  services.syncthing.enable = true;

  services.udiskie.enable = true;

  systemd.user.startServices = "sd-switch";

  # use systemd.user.tmpfiles.rules?

  xdg = {
    enable = true;
    # TODO mimeTypes?
  };
}
