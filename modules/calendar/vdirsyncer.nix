{ lib, config, pkgs, ... }: with lib; let
  vdirsyncer = "${pkgs.vdirsyncer}/bin/vdirsyncer";
  vdirsyncerScript = pkgs.writeShellScript "vdirsyncer" ''
    ${vdirsyncer} discover
    ${vdirsyncer} sync
    ${vdirsyncer} metasync
  '';
in
{
  systemd.user.services.vdirsyncer = {
    Unit.Description = "Synchronize Calendar and Contacts";

    Service = {
      Type = "oneshot";
      ExecStart = "${vdirsyncerScript}";
    };
  };

  systemd.user.timers.vdirsyncer = {
    Unit.Description = "Synchronize Calendar and Contacts";

    Timer = {
      OnCalendar = "*:0/15"; # Every 15 minutes
      Unit = "vdirsyncer.service";
    };

    Install = { WantedBy = [ "timers.target" ]; };
  };
}
