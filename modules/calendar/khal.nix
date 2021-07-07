{ lib, config, pkgs, ... }: {
  nixpkgs.overlays = [
    # https://pr-tracker.nevarro.space/?pr=128942
    (
      self: super: {
        khal = super.khal.overridePythonAttrs (
          old: rec { doCheck = false; }
        );
      }
    )
  ];

  home.packages = [ pkgs.khal ];
  xdg.configFile."khal/config".text = ''
    [calendars]

    [[xandikos_calendar_local]]
    path = ${config.xdg.dataHome}/vdirsyncer/calendars/*
    type = discover

    [[xandikos_contacts_local]]
    path = ${config.xdg.dataHome}/vdirsyncer/contacts/addressbook
    type = birthdays

    [locale]
    timeformat = %H:%M
    dateformat = %Y-%m-%d
    longdateformat = %Y-%m-%d
    datetimeformat = %Y-%m-%d %H:%M
    longdatetimeformat = %Y-%m-%d %H:%M
    firstweekday = 6
  '';
}
