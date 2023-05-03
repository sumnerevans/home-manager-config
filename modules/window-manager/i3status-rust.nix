{ config, lib, pkgs, ... }: with lib; {
  options = {
    laptop.enable = mkEnableOption "configuration that only applies to laptops";
    networking.interfaces = mkOption {
      type = types.listOf types.str;
      description = "A list of the network interfaces on the machine";
      default = [ ];
    };
    programs.i3status-rust.extraBlocks = mkOption {
      type = types.listOf (types.attrsOf types.anything);
      description = "A list of extra blocks to add.";
      default = [ ];
    };
  };

  config = mkIf (config.wayland.enable || config.xorg.enable) {
    programs.i3status-rust = {
      enable = true;

      bars = {
        top =
          let
            cu = "${pkgs.coreutils}/bin";
            dunstctl = "${pkgs.dunst}/bin/dunstctl";
            home = config.home.homeDirectory;
            homeTmp = "${config.home.homeDirectory}/tmp";
            nmcli = "${pkgs.networkmanager}/bin/nmcli";
            parseRollingPingScript = pkgs.writeShellScriptBin "parse-rolling-ping" ''
              ${cu}/cat ${homeTmp}/rolling_ping | ${pkgs.gnugrep}/bin/grep "fail" > /dev/null
              [[ $? == 0 ]] && printf "∞" && exit 0
              printf "%0.3f" $(${cu}/cat ${homeTmp}/rolling_ping | ${pkgs.jq}/bin/jq -s add/length)
            '';
            outgoingMailScript = pkgs.writeShellScriptBin "parse-outgoing-mail" ''
              ls ${home}/.offlinemsmtp-outbox | ${cu}/wc -l | jq '{icon: "mail", text: .|tostring, state: (if (. > 0) then "Critical" else "Idle" end)}'
            '';
          in
          {
            # icons = "awesome";
            # theme = "nord-dark";
            settings = {
              icons.icons = "awesome4";
              theme.theme = "nord-dark";
            };

            blocks = map (x: builtins.removeAttrs x [ "priority" ]) (
              sort (a: b: a.priority < b.priority) (
                [
                  {
                    block = "custom";
                    command = "${outgoingMailScript}/bin/parse-outgoing-mail";
                    interval = 10;
                    priority = 0;
                    json = true;
                  }
                  {
                    block = "maildir";
                    interval = 10;
                    inboxes = map (f: "${home}/Mail/${f}/INBOX") [ "Personal" "Financial" ];
                    threshold_warning = 25;
                    threshold_critical = 50;
                    priority = 10;
                  }
                  {
                    block = "maildir";
                    interval = 10;
                    inboxes = map (f: "${home}/Mail/${f}/INBOX") [ "Teaching" ];
                    threshold_warning = 25;
                    threshold_critical = 50;
                    priority = 11;
                  }
                  {
                    block = "maildir";
                    interval = 10;
                    inboxes = map (f: "${home}/Mail/${f}/INBOX") [ "Work" ];
                    threshold_warning = 1;
                    threshold_critical = 5;
                    priority = 12;
                  }
                  {
                    block = "toggle";
                    format = " $icon Send Email? ";
                    command_state = "ls ${homeTmp}/offlinemsmtp-sendmail >/dev/null && echo 1";
                    command_on = "${cu}/touch ${homeTmp}/offlinemsmtp-sendmail";
                    command_off = "${cu}/rm ${homeTmp}/offlinemsmtp-sendmail";
                    interval = 5;
                    priority = 20;
                  }
                  {
                    block = "memory";
                    warning_mem = 90;
                    warning_swap = 90;
                    critical_mem = 95;
                    critical_swap = 95;
                    priority = 30;
                    format = " $icon $mem_used.eng(prefix:M) ";
                  }
                  {
                    block = "music";
                    player = "sublimemusic";
                    format =
                      if config.laptop.enable then
                        " $icon {$combo.str(max_w:20) $play $next |} "
                      else
                        " $icon {$combo.str(max_w:20) $prev $play $next |} ";
                    priority = 40;
                  }
                  {
                    # Ping time
                    block = "custom";
                    command = ''printf "P: %s" $(${parseRollingPingScript}/bin/parse-rolling-ping)'';
                    interval = 1;
                    priority = 70;
                  }
                  {
                    block = "sound";
                    format = " $icon {$volume.eng(w:2) |}";
                    step_width = 2;
                    priority = 90;
                  }
                  {
                    block = "time";
                    format = " $icon UTC $timestamp.datetime(f:'%H')";
                    timezone = "Etc/UTC";
                    interval = 1;
                    priority = 100;
                  }
                  {
                    block = "time";
                    format = " $icon UTC $timestamp.datetime(f:'%F %R:%S') ";
                    interval = 1;
                    priority = 101;
                  }
                ] ++ (
                  # Include a "net" block for each of the network interfaces.
                  # TODO look into using the networkmanager block here instead
                  imap0
                    (
                      i: dev: {
                        block = "net";
                        device = dev;
                        interval = 5;
                        format = " $icon $ip";
                        missing_format = "";
                        priority = 80 + i;
                      }
                    )
                    config.networking.interfaces
                ) ++ (
                  optionals config.laptop.enable [
                    {
                      block = "backlight";
                      priority = 50;
                    }
                    {
                      block = "battery";
                      interval = 30;
                      format = " $icon $percentage $time";
                      device = "BAT0";
                      priority = 110;
                    }
                  ]
                ) ++ (
                  # TODO need to figure out how to do this for Sway
                  optionals config.xorg.enable [
                    {
                      block = "toggle";
                      format = "DND";
                      command_state = "[[ $(${dunstctl} is-paused) == true ]] && echo 1";
                      command_on = "${dunstctl} set-paused true";
                      command_off = "${dunstctl} set-paused false";
                      interval = 60;
                      priority = 120;
                    }
                  ]
                ) ++ config.programs.i3status-rust.extraBlocks
              )
            );
          };
      };
    };
  };
}
