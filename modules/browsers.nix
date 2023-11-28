{ config, lib, pkgs, ... }:
with lib;
let
  chromeCommandLineArgs = "-high-dpi-support=0 -force-device-scale-factor=1";
  hasGui = config.wayland.enable || config.xorg.enable;
in {
  home.packages = with pkgs;
    [ elinks w3m ] ++ optionals hasGui [
      (google-chrome.override { commandLineArgs = chromeCommandLineArgs; })

      nyxt
    ];

  programs.chromium.enable = hasGui;
  programs.firefox.enable = hasGui;

  home.sessionVariables = mkIf hasGui {
    # Enable touchscreen in Firefox
    MOZ_USE_XINPUT2 = "1";
    MOZ_DBUS_REMOTE = "1";
  };
}
