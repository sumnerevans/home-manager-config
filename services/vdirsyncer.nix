{ lib, config, pkgs, ... }: with lib; let
  vdirsyncer = "${pkgs.vdirsyncer}/bin/vdirsyncer";
  vdirsyncerScript = pkgs.writeShellScript "vdirsyncer" ''
    ${vdirsyncer} discover
    ${vdirsyncer} sync
    ${vdirsyncer} metasync
  '';

  # ICS import settings
  icsSubscriptions = [
    { uri = "https://lug.mines.edu/schedule/ical.ics"; importTo = "LUG"; }
    { uri = "https://acm.mines.edu/schedule/ical.ics"; importTo = "ACM"; }
  ];
  icsImportCurl = { uri, importTo }:
    "${pkgs.curl}/bin/curl '${uri}' | ${pkgs.khal}/bin/khal import --batch -a ${importTo}";
  icsSubscriptionImport = pkgs.writeShellScript "ics-subscription-import" ''
    set -xe
    ${concatMapStringsSep "\n" icsImportCurl icsSubscriptions}
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

  systemd.user.services."ics-subscription-import" = {
    Unit.Description = "Download the icsSubscriptions and import using khal.";

    Service = {
      Type = "oneshot";
      ExecStart = "${icsSubscriptionImport}";
    };
  };

  systemd.user.timers."ics-subscription-import" = {
    Unit.Description = "Download the icsSubscriptions and import using khal.";

    Timer = {
      OnCalendar = "*:0"; # Every hour
      Unit = "ics-subscription-import.service";
    };

    Install = { WantedBy = [ "timers.target" ]; };
  };
}
