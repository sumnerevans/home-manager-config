{ config, lib, pkgs, ... }: with lib; {
  options = {
    laptop.enable = mkOption {
      type = types.bool;
      description = "Enable stuff that only applies to laptops";
      default = false;
    };
    networking.interfaces = mkOption {
      type = types.listOf types.str;
      description = "A list of the network interfaces on the machine";
      default = [];
    };
    programs.i3status-rust.extraBlocks = mkOption {
      type = types.listOf (types.attrsOf types.anything);
      description = "A list of extra blocks to add.";
      default = [];
    };
  };

  config = {
    programs.i3status-rust = {
      enable = true;

      bars = {
        top = let
          cu = "${pkgs.coreutils}/bin";
          dunstctl = "${pkgs.dunst}/bin/dunstctl";
          home = config.home.homeDirectory;
          homeTmp = "${config.home.homeDirectory}/tmp";
          nmcli = "${pkgs.networkmanager}/bin/nmcli";
        in
          {
            icons = "awesome";
            theme = "slick";

            blocks = map (x: builtins.removeAttrs x [ "priority" ]) (
              sort (a: b: a.priority < b.priority) (
                [
                  # Common blocks
                  {
                    block = "custom";
                    command = "echo  $(ls ${home}/.offlinemsmtp-outbox | ${cu}/wc -l)";
                    interval = 10;
                    priority = 0;
                  }
                  {
                    block = "maildir";
                    interval = 10;
                    inboxes = map (f: "${home}/Mail/${f}/INBOX") [ "Personal" "Mines" "Gmail" "TEF" ];
                    threshold_warning = 25;
                    threshold_critical = 50;
                    priority = 10;
                  }
                  {
                    block = "toggle";
                    text = "Send Email?";
                    command_state = "ls ${homeTmp}/offlinemsmtp-sendmail >/dev/null && echo 'Send Email'";
                    command_on = "${cu}/touch ${homeTmp}/offlinemsmtp-sendmail";
                    command_off = "${cu}/rm ${homeTmp}/offlinemsmtp-sendmail";
                    interval = 5;
                    priority = 20;
                  }
                  {
                    block = "memory";
                    format_mem = "{Mug}GiB";
                    format_swap = "{SUg}GiB";
                    warning_mem = 90;
                    warning_swap = 90;
                    critical_mem = 95;
                    critical_swap = 95;
                    priority = 30;
                  }
                  {
                    block = "music";
                    player = "sublimemusic";
                    buttons = [ (mkIf (!config.laptop.enable) "prev") "play" "next" ];
                    priority = 40;
                  }
                  {
                    block = "toggle";
                    text = "CSM";
                    command_state = "${nmcli} con show --active | ${pkgs.gnugrep}/bin/grep 'Mines VPN'";
                    command_on = "${nmcli} con up id 'Mines VPN'";
                    command_off = "${nmcli} con down id 'Mines VPN'";
                    interval = 5;
                    priority = 60;
                  }
                  {
                    # Ping time
                    block = "custom";
                    command = ''printf "P: %s" $(${home}/bin/parse-rolling-ping.sh)'';
                    interval = 1;
                    priority = 70;
                  }
                  {
                    block = "sound";
                    step_width = 2;
                    priority = 90;
                  }
                  {
                    block = "time";
                    format = "%F %R:%S";
                    interval = 1;
                    priority = 100;
                  }
                ] ++ (
                  # Include a "net" block for each of the network interfaces.
                  imap0 (
                    i: dev: {
                      block = "net";
                      device = dev;
                      ip = true;
                      speed_down = false;
                      graph_down = false;
                      speed_up = false;
                      graph_up = false;
                      interval = 5;
                      hide_missing = true;
                      hide_inactive = true;
                      priority = 80 + i;
                    }
                  ) config.networking.interfaces
                ) ++ (
                  optionals config.laptop.enable [
                    {
                      block = "backlight";
                      priority = 50;
                    }
                    {
                      block = "battery";
                      interval = 30;
                      format = "{percentage}% {time}";
                      device = "BAT0";
                      priority = 110;
                    }
                  ]
                ) ++ (
                  # TODO need to figure out how to do this for Sway
                  optionals config.xorg.enable [
                    {
                      block = "toggle";
                      text = "DND";
                      command_state = "[[ $(${dunstctl} is-paused) == true ]]";
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
