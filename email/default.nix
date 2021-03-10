{ pkgs, ... }: with pkgs; {
  imports = [
    ./accounts.nix
    ./mailcap.nix
    ./mbsync.nix
  ];

  services.imapnotify.enable = true;
}
