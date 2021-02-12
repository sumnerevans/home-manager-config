{ config, pkgs, ... }: let
  mailnotify = pkgs.callPackage ../pkgs/mailnotify.nix {};
in
{
  systemd.user.services.mailnotify = {
    Unit = {
      Description = "Run a daemon for notifications for email.";
      PartOf = [ "graphical-session.target" ];
    };

    Service = {
      ExecStart = "${mailnotify}/bin/mailnotify";
      Restart = "always";
      RestartSec = 5;
      Environment = [
        "ICON_PATH=${pkgs.gnome-icon-theme}/share/icons/gnome/48x48/status/mail-unread.png"
      ];
    };

    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };
}
