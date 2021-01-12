{ config, pkgs, ... }:
{
  imports = [
    ./programs
    ./email.nix
    ./services
  ];

  qt = { enable = true; platformTheme = "gtk"; };

  nixpkgs.overlays = [];
}
