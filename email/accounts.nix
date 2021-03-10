{ config, pkgs, ... }: let
  mkAccount = name: accountConfig: {
    realName = "Sumner Evans";
    userName = accountConfig.address;
    passwordCommand = "${pkgs.pass}/bin/pass Mail/${accountConfig.address}";

    folders = {
      inbox = "INBOX";
    };

    gpg = {
      encryptByDefault = true;
      key = "3F15C22BFD125095F9C072758904527AB50022FD";
      signByDefault = true;
    };

    imapnotify = {
      enable = true;
      boxes = [ "INBOX" ];
      onNotify = "${pkgs.isync}/bin/mbsync ${name}:%s";
      onNotifyPost = "${pkgs.libnotify}/bin/notify-send 'New mail in ${name}:%s'";
    };

    mbsync = {
      enable = true;
      create = "both";
      remove = "both";
    };
  } // accountConfig;

  mkMigaduAccount = name: accountConfig: {
    imap.host = "imap.migadu.com";
    smtp.host = "smtp.migadu.com";
  } // (mkAccount name accountConfig);
in
{
  accounts.email.maildirBasePath = "${config.home.homeDirectory}/Mail";
  accounts.email.accounts = {
    Personal = mkMigaduAccount "Personal" {
      address = "me@sumnerevans.com";
      aliases = [ "alerts@sumnerevans.com" "resume@sumnerevans.com" ];
      primary = true;
    };

    Gmail = mkAccount "Gmail" {
      address = "sumner.evans98@gmail.com";
      flavor = "gmail.com";
    };

    Mines = mkAccount "Mines" {
      address = "jonathanevans@mymail.mines.edu";
      flavor = "gmail.com";
      passwordCommand = "${pkgs.pass}/bin/pass Mail/Offlineimap/Mines";
    };

    Admin = mkMigaduAccount "Admin" {
      address = "admin@sumnerevans.com";
      aliases = [ "abuse@sumnerevans.com" "hostmaster@sumnerevans.com" "postmaster@sumnerevans.com" ];
    };

    Comments = mkMigaduAccount "Comments" {
      address = "comments@sumnerevans.com";
    };

    Inquiries = mkMigaduAccount "Inquiries" {
      address = "inquiries@sumnerevans.com";
    };

    Junk = mkMigaduAccount "Junk" {
      address = "junk@sumnerevans.com";
    };
  };
}
