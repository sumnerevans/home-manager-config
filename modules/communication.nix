{ config, lib, pkgs, ... }: with lib; with pkgs; let
  beeper-desktop = pkgs.callPackage ../pkgs/beeper-desktop.nix { };
  element-desktop = pkgs.element-desktop.overrideAttrs (old: {
    fixupPhase = ''
      sed -i "s#exec#LD_PRELOAD=${pkgs.sqlcipher}/lib/libsqlcipher.so exec#g" "$out/bin/element-desktop"
    '';
  });
in
{
  home.packages = optionals (config.wayland.enable || config.xorg.enable)
    [
      beeper-desktop
      discord
      element-desktop
      teams
      fractal
      mumble
      neochat
      nheko
      zoom-us
    ];
}
