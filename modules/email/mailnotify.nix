{ config, pkgs, ... }: with pkgs; let
  mailnotify = callPackage ../../pkgs/mailnotify.nix { };
in
{
  systemd.user.services.mailnotify = {
    Unit = {
      Description = "mailnotify daemon";
      PartOf = [ "graphical-session.target" ];
    };

    Service = {
      ExecStart = ''
        ${mailnotify}/bin/mailnotify ${config.accounts.email.maildirBasePath}
      '';
      Environment = [
        "ICON_PATH=${pkgs.gnome-icon-theme}/share/icons/gnome/48x48/status/mail-unread.png"
      ];
      Restart = "always";
      RestartSec = 5;
    };

    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };
}
