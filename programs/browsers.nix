{ pkgs, ... }:
{
  home.packages = with pkgs; [
    elinks
    w3m
  ];
}
