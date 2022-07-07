{ lib, config, pkgs, ... }: {
  home.packages = [
    pkgs.khal
    # Workaround from https://github.com/pimutils/khal/issues/1092
    # (pkgs.khal.overridePythonAttrs (
    #   attrs: rec {
    #     # fixes https://github.com/pimutils/khal/issues/1092
    #     tzlocal21 = pkgs.python39Packages.tzlocal.overridePythonAttrs (old: rec {
    #       pname = "tzlocal";
    #       version = "2.1";
    #       propagatedBuildInputs = [ pkgs.python39Packages.pytz ];
    #       src = pkgs.python39Packages.fetchPypi {
    #         inherit pname version;
    #         sha256 = "sha256-ZDyXxSlK7cc3eApJ2d8wiJMhy+EgTqwsLsYTQDWpLkQ=";
    #       };
    #       doCheck = false;
    #       pythonImportsCheck = [ "tzlocal" ];
    #     });
    #     propagatedBuildInputs = (builtins.filter (i: i.pname != "tzlocal")
    #       attrs.propagatedBuildInputs) ++ [ tzlocal21 ];
    #   }
    # ))
  ];

  xdg.configFile."khal/config".text = ''
    [calendars]

    [[xandikos_calendar_local]]
    path = ${config.xdg.dataHome}/vdirsyncer/calendars/*
    type = discover

    [[xandikos_contacts_local]]
    path = ${config.xdg.dataHome}/vdirsyncer/contacts/addressbook
    type = birthdays

    [[beeper_calendar_local]]
    path = ${config.xdg.dataHome}/vdirsyncer/work-calendars/*
    type = discover

    [locale]
    timeformat = %H:%M
    dateformat = %Y-%m-%d
    longdateformat = %Y-%m-%d
    datetimeformat = %Y-%m-%d %H:%M
    longdatetimeformat = %Y-%m-%d %H:%M
    firstweekday = 6
  '';
}
