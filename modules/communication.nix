{ config, lib, pkgs, ... }:
with lib;
let beeper-desktop = pkgs.callPackage ../pkgs/beeper-desktop.nix { };
in {
  home.packages = with pkgs;
    (optionals (config.wayland.enable || config.xorg.enable)
      ([ beeper-desktop discord element-desktop mumble zoom-us ]
        ++ optionals config.work.enable [ slack ]));
}
