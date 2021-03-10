{ pkgs, ... }: let
  chromeCommandLineArgs = "-high-dpi-support=0 -force-device-scale-factor=1";
in
{
  home.packages = with pkgs; [
    (google-chrome.override { commandLineArgs = chromeCommandLineArgs; })
    firefox-bin
    elinks
    w3m
  ];
}
