{ pkgs, ... }:
let
  chromeCommandLineArgs = "-high-dpi-support=0 -force-device-scale-factor=1";
in
{
  home.packages = with pkgs; [
    (google-chrome.override { commandLineArgs = chromeCommandLineArgs; })
    firefox-bin # TODO use the module?
    elinks
    w3m
  ];

  home.sessionVariables = {
    # Enable touchscreen in Firefox
    MOZ_USE_XINPUT2 = "1";
    MOZ_DBUS_REMOTE = "1";
  };

  programs.chromium.enable = true;
}
