{ pkgs, ... }: let
  mkAccount = config: {
    realName = "Sumner Evans";
    userName = config.address;
    passwordCommand = "${pkgs.pass}/bin/pass ${config.address}";

    gpg = {
      encryptByDefault = true;
      key = "3F15C22BFD125095F9C072758904527AB50022FD";
      signByDefault = true;
    };

    imapnotify = {
      enable = true;
      boxes = [ "INBOX" ];
      onNotify = "${pkgs.libnotify}/bin/notify-send 'detected new mail'";
      onNotifyPost = ''${pkgs.libnotify}/bin/notify-send "New mail post";'';
    };

    mbsync = {
      enable = true;
      create = "both";
      remove = "both";
    };
  } // config;

  mkMigaduAccount = config: {
    imap.host = "imap.migadu.com";
    smtp.host = "smtp.migadu.com";
  } // (mkAccount config);
in
{
  # TODO look into astroid
  accounts.email.accounts = {
    Personal = mkMigaduAccount {
      address = "me@sumnerevans.com";
      aliases = [ "alerts@sumnerevans.com" "resume@sumnerevans.com" ];
      primary = true;
    };

    Gmail = mkAccount {
      address = "sumner.evans98@gmail.com";
      flavor = "gmail.com";
    };

    Mines = mkAccount {
      address = "jonathanevans@mymail.mines.edu";
      flavor = "gmail.com";
    };

    Admin = mkMigaduAccount {
      address = "admin@sumnerevans.com";
      aliases = [ "abuse@sumnerevans.com" "hostmaster@sumnerevans.com" "postmaster@sumnerevans.com" ];
    };

    Comments = mkMigaduAccount {
      address = "comments@sumnerevans.com";
    };

    Inquiries = mkMigaduAccount {
      address = "inquiries@sumnerevans.com";
    };

    Junk = mkMigaduAccount {
      address = "junk@sumnerevans.com";
    };
  };

  # services.imapnotify.enable = true;

  # mbsync
  programs.mbsync.groups = {};
  systemd.user.services.mbsync = let
    pingCmd = "/run/wrappers/bin/ping";
    pgrepCmd = "${pkgs.procps}/bin/pgrep";
    mbsyncCmd = "${pkgs.isync}/bin/mbsync";
    mbsyncScript = pkgs.writeShellScript "mbsync" ''
      # Check that the network is up.
      ${pingCmd} -c 1 8.8.8.8
      if [[ "$?" != "0" ]]; then
          echo "Couldn't contact the network. Exiting..."
          exit 1
      fi

      # Chcek to see if we are already syncing.
      pid=$(${pgrepCmd} mbsync)
      if ${pgrepCmd} mbsync &>/dev/null; then
          echo "Process $pid already running. Exiting..." >&2
          exit 1
      fi

      ${mbsyncCmd} -aV 2>&1 | tee ~/tmp/mbsync.log
    '';
  in
    {
      Unit = { Description = "mbsync mailbox synchronization"; };

      Service = {
        Type = "oneshot";
        ExecStart = "${mbsyncScript}";
      };
    };

  systemd.user.timers.mbsync = {
    Unit = { Description = "mbsync mailbox synchronization"; };

    Timer = {
      OnCalendar = "*:0/5";
      Unit = "mbsync.service";
    };

    Install = { WantedBy = [ "timers.target" ]; };
  };
}
