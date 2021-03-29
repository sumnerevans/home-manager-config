{ config, pkgs, ... }: with pkgs; {
  imports = [
    ./accounts
    ./mailcap.nix
    ./mbsync.nix
    ./neomutt.nix
    ./offlinemsmtp.nix
  ];

  services.imapnotify.enable = true;
  programs.msmtp.enable = true;

  home.file = let
    path = "${config.xdg.dataHome}/fortune/quotes";
  in
    rec {
      "${path}" = {
        source = ./quotes;
        onChange = "${pkgs.fortune}/bin/strfile -r ${path}";
      };
    };
}
