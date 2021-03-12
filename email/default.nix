{ pkgs, ... }: with pkgs; {
  imports = [
    ./accounts.nix
    ./mailcap.nix
    ./mbsync.nix
    ./neomutt.nix
  ];

  services.imapnotify.enable = true;
  programs.msmtp.enable = true;
}
