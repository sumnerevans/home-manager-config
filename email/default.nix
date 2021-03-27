{ pkgs, ... }: with pkgs; {
  imports = [
    ./accounts
    ./mailcap.nix
    ./mbsync.nix
    ./neomutt.nix
  ];

  services.imapnotify.enable = true;
  programs.msmtp.enable = true;
}
