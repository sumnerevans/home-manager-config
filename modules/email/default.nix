{ config, pkgs, ... }:
let quotesPath = "${config.xdg.dataHome}/fortune/quotes";
in {
  imports = [
    ./accounts
    ./contact-query.nix
    ./mailcap.nix
    ./mailnotify.nix
    ./mbsync.nix
    ./neomutt.nix
    ./offlinemsmtp.nix
  ];

  services.imapnotify.enable = true;
  programs.msmtp.enable = true;

  home.file = {
    "${quotesPath}" = {
      source = ./quotes;
      onChange = "${pkgs.fortune}/bin/strfile -r ${quotesPath}";
    };
  };
}
