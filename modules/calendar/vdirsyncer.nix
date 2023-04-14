{ lib, config, pkgs, ... }: with lib; let
  vdirsyncer = "${pkgs.vdirsyncer}/bin/vdirsyncer";
  vdirsyncerScript = pkgs.writeShellScript "vdirsyncer" ''
    ${vdirsyncer} discover
    ${vdirsyncer} sync
    ${vdirsyncer} metasync
  '';

  passwordFetchCommand = passwordName:
    ''["command", "${pkgs.coreutils}/bin/cat", "${config.xdg.configHome}/home-manager/secrets/vdirsyncer/${passwordName}"]'';
in
{
  home.packages = [ pkgs.vdirsyncer ];
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

  xdg.configFile."vdirsyncer/config".text =
    let
      typeToFileExt = type: if type == "contacts" then ".vcf" else ".ics";
      typeToRemoteType = type: if type == "contacts" then "carddav" else "caldav";
      mkPair = { name, metadata ? [ "displayname" ] }: ''
        [pair xandikos_${name}]
        a = "xandikos_${name}_local"
        b = "xandikos_${name}_remote"
        collections = ["from a", "from b"]
        conflict_resolution = "b wins"
        metadata = [${concatMapStringsSep ", " (x: ''"${x}"'') metadata}]

        [storage xandikos_${name}_local]
        type = "filesystem"
        path = "${config.xdg.dataHome}/vdirsyncer/${name}/"
        fileext = "${typeToFileExt name}"

        [storage xandikos_${name}_remote]
        type = "${typeToRemoteType name}"
        url = "https://dav.sumnerevans.com/"
        username = "sumner"
        password.fetch = ${passwordFetchCommand "xandikos"}
      '';
    in
    ''
      [general]
      # A folder where vdirsyncer can store some metadata about each pair.
      status_path = "${config.xdg.dataHome}/vdirsyncer/status/"

      # Contacts
      ${mkPair { name = "contacts"; }}

      # Calendar
      ${mkPair { name = "calendars"; metadata = [ "displayname" "color" ]; }}

      # Work Calendar
      [pair beeper_google_calendar]
      a = "beeper_google_calendar_local"
      b = "beeper_google_calendar_remote"
      collections = ["from a", "from b"]
      conflict_resolution = "b wins"
      metadata = [ "displayname", "color" ]

      [storage beeper_google_calendar_local]
      type = "filesystem"
      path = "${config.xdg.dataHome}/vdirsyncer/work-calendars/"
      fileext = ".ics"

      [storage beeper_google_calendar_remote]
      type = "google_calendar"
      token_file = "${config.xdg.dataHome}/vdirsyncer/beeper_google_calendar_token_file"
      client_id.fetch = ${passwordFetchCommand "gcp_client_id"}
      client_secret.fetch = ${passwordFetchCommand "gcp_client_secret"}
    '';
}
