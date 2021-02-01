{ pkgs, ... }: with pkgs; {
  imports = [
    ./accounts.nix
    ./mailcap.nix
  ];
}
