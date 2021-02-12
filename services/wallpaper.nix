{ pkgs, ... }:
{
  systemd.user.services.wallpaper = {
    Unit = {
      Description = "Set the wallpaper.";
      PartOf = [ "graphical-session.target" ];
    };

    Service = {
      Type = "oneshot";
      ExecStart = "/home/sumner/bin/set_wallpaper.sh";
      Environment = "DISPLAY=:0";
    };

    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };

  systemd.user.timers.wallpaper = {
    Unit = { Description = "Set the wallpaper"; };

    Timer = {
      OnCalendar = "*:0/10";
      Unit = "wallpaper.service";
    };

    Install = { WantedBy = [ "timers.target" ]; };
  };
}
