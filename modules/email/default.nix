{ config, pkgs, ... }: with pkgs; let
  quotesPath = "${config.xdg.dataHome}/fortune/quotes";
in
{
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

  nixpkgs.overlays = [
    (self: super: {
      notmuch = super.notmuch.overrideAttrs (old: {
        patches = (old.patches or [ ]) ++ [
          (super.fetchpatch {
            url = "https://raw.githubusercontent.com/stigtsp/nixpkgs/b0770408976ec309f70e19dd78599bf8f2ad7145/pkgs/applications/networking/mailreaders/notmuch/test-fix-support-for-gpgsm-in-gnupg-2.3.patch";
            sha256 = "sha256-Zaushz7+/b+P3Fcjb4huENTN74QUbJ6c3fVPuZd75kk=";
          })
        ];
      });
    })
  ];

  home.file = {
    "${quotesPath}" = {
      source = ./quotes;
      onChange = "${pkgs.fortune}/bin/strfile -r ${quotesPath}";
    };
  };
}
