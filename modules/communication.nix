{ config, lib, pkgs, ... }:
with lib;
let beeper-desktop = pkgs.callPackage ../pkgs/beeper-desktop.nix { };
in {
  home.packages = with pkgs;
    [ gomuks ] ++ optionals (config.wayland.enable || config.xorg.enable) [
      beeper-desktop
      discord
      element-desktop
      mumble
      neochat
      nheko
      slack
      zoom-us
    ];
}
