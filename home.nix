{ config, pkgs, ... }:
{
  imports = [
    ./email
    ./programs
    ./services
  ];

  qt = { enable = true; platformTheme = "gtk"; };

  nixpkgs.overlays = [];
}
