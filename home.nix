{ config, pkgs, ... }:
{
  imports = [
    ./email
    ./programs
    ./services
  ];

  qt = { enable = true; platformTheme = "gtk"; };

  nixpkgs.overlays = [];

  home = {
    stateVersion = "21.03";
    username = "sumner";
    homeDirectory = "/home/sumner";
  };
}
