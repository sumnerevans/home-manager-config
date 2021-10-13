{ config, lib, pkgs, ... }: with lib; with pkgs; let
  beeper-desktop = pkgs.callPackage ../pkgs/beeper-desktop.nix {};
in{
  home.packages = optionals (config.wayland.enable || config.xorg.enable)
    [
      beeper-desktop
      discord
      element-desktop
      fractal
      mumble
      neochat
      nheko
      zoom-us
    ];
}
