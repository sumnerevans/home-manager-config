{ pkgs, ... }: with pkgs; {
  imports = [
    ./accounts.nix
    ./mailcap.nix
    ./mbsync.nix
  ];

  # TODO look into astroid
  services.imapnotify.enable = true;
}
