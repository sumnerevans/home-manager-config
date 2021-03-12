{ config, lib, pkgs, ... }: let
  # TODO use lib.mkMerge
  mkAccount =
    { config
    , name
    , color
    , folders ? {}
    , alternates ? []
    , msmtpExtraConfig ? {}
    , neomuttExtraConfig ? ""
    }: {
      realName = "Sumner Evans";
      userName = config.address;
      passwordCommand = "${pkgs.pass}/bin/pass Mail/${config.address}";

      folders = {
        inbox = "INBOX";
      } // folders;

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

      msmtp = { enable = true; extraConfig = msmtpExtraConfig; };

      mbsync = {
        enable = true;
        create = "both";
        remove = "both";
      };

      neomutt = {
        enable = true;
        sendMailCommand = "offlinemsmtp -a ${name}";
        extraConfig = ''
          color status ${color} default
          ${neomuttExtraConfig}
        '' + (
          lib.strings.optionalString (alternates != [])
            "alternates '^${lib.strings.concatStringsSep "|" alternates}$'"
        );
      };
    } // config;

  mkMigaduAccount = accountConfig: {
    imap.host = "imap.migadu.com";
    smtp.host = "smtp.migadu.com";
  } // (mkAccount accountConfig);
in
{
  accounts.email.maildirBasePath = "${config.home.homeDirectory}/Mail";
  accounts.email.accounts = {
    Personal = mkMigaduAccount {
      name = "Personal";
      color = "green";
      config = {
        address = "me@sumnerevans.com";
        aliases = [ "alerts@sumnerevans.com" "resume@sumnerevans.com" ];
        primary = true;
      };
      neomuttExtraConfig = ''
        set signature="python3 ~/.mutt/signatures/personal|";
      '';
    };

    Gmail = mkAccount {
      name = "Gmail";
      color = "yellow";
      folders = {
        drafts = "[Gmail]/Drafts";
        sent = "[Gmail]/Sent Mail";
        trash = "[Gmail]/Trash";
      };
      config = {
        address = "sumner.evans98@gmail.com";
        flavor = "gmail.com";
      };
      neomuttExtraConfig = ''
        set signature="python3 ~/.mutt/signatures/gmail|";
      '';
    };

    Mines = mkAccount {
      # This one is a bit annoying since I want to send from my @mines.edu
      # account not @mymail.mines.edu.
      name = "Mines";
      alternates = [ "jonathanevans@mymail.mines.edu" ];
      color = "cyan";
      folders = {
        drafts = "[Gmail]/Drafts";
        sent = "[Gmail]/Sent Mail";
        trash = "[Gmail]/Trash";
      };
      config = {
        address = "jonathanevans@mymail.mines.edu";
        realName = "Jonathan Sumner Evans";
        passwordCommand = "${pkgs.pass}/bin/pass Mail/Offlineimap/Mines";
        imap.host = "imap.gmail.com";
        smtp.host = "smtp.mines.edu";
      };
      msmtpExtraConfig = {
        from = "jonathanevans@mines.edu";
        passwordeval = "${pkgs.pass}/bin/pass School/Mines/MultiPass";
        user = "jonathanevans";
      };
      neomuttExtraConfig = ''
        set from="jonathanevans@mines.edu"
        set signature="python3 ~/.mutt/signatures/mines|";
      '';
    };

    Admin = mkMigaduAccount {
      name = "Admin";
      color = "green";
      config = {
        address = "admin@sumnerevans.com";
        aliases = [
          "abuse@sumnerevans.com"
          "hostmaster@sumnerevans.com"
          "postmaster@sumnerevans.com"
        ];
      };
    };

    Comments = mkMigaduAccount {
      name = "Comments";
      color = "green";
      config.address = "comments@sumnerevans.com";
    };

    Inquiries = mkMigaduAccount {
      name = "Inquiries";
      color = "green";
      config.address = "inquiries@sumnerevans.com";
    };

    Junk = mkMigaduAccount {
      name = "Junk";
      color = "green";
      config.address = "junk@sumnerevans.com";
    };
  };
}
