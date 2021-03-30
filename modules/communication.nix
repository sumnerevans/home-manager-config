{ config, lib, pkgs, ... }: with lib; with pkgs; {
  home.packages = optionals (config.wayland.enable || config.xorg.enable) [
    discord
    element-desktop
    mumble
    zoom-us
  ];
}
