{ config, lib, pkgs, ... }: with lib; let
  beeper-desktop = pkgs.callPackage ../pkgs/beeper-desktop.nix { };
in
{
  home.packages = with pkgs; [
    gomuks
  ] ++ optionals (config.wayland.enable || config.xorg.enable)
    [
      (if config.wayland.enable then
        pkgs.writeShellScriptBin "beeper-desktop" ''
          ${beeper-desktop}/bin/beeper-beta --ozone-platform-hint=auto --enable-features=WaylandWindowDecorations
        '' else beeper-desktop)
      discord
      element-desktop
      fractal
      mumble
      neochat
      nheko
      zoom-us
    ];
}
