{ config, pkgs, lib, ... }: with lib; let
in
{
  imports = [
    ./shortcuts.nix
  ];

  # TODO use programs.neovim
  home.packages = [ pkgs.neovim ];
}
