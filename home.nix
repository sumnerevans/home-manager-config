{ pkgs, ... }:
{
  imports = [
    ./programs
    ./email.nix
  ];
}
