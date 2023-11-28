{ config, pkgs, lib, ... }:
with lib; {
  programs.neovim.extraConfig = ''
    set clipboard+=unnamed${if config.isLinux then "plus" else ""}
  '';
}
