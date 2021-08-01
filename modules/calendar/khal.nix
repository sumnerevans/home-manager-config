{ lib, config, pkgs, ... }: {
  home.packages = [ pkgs.khal ];
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
