{ lib, config, pkgs, ... }: with lib; let
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
