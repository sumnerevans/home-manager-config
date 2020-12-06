{ pkgs, ... }:
{
  imports = [
    ./git.nix
  ];

  programs.home-manager.enable = true;
}
