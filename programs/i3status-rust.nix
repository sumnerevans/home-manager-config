{ config, lib, ... }: with lib; {
  options = {
    laptop.enable = mkOption {
      type = types.bool;
      description = "Enable stuff that only applies to laptops";
      default = false;
    };
  };

  config = {
    programs.i3status-rust = {
      enable = true;

      bars = {
        top = {
          icons = "awesome";
          theme = "slick";

          blocks = [
            {
              block = "custom";
              command = "echo  $(ls ~/.offlinemsmtp-outbox | wc -l)";
              interval = 10;
            }
            {
              block = "maildir";
              interval = 10;
              inboxes = map (f: "/home/sumner/Mail/${f}/INBOX")
                [ "Personal" "Mines" "Gmail" "TEF" ];
              threshold_warning = 25;
              threshold_critical = 50;
            }
            {
              block = "toggle";
              text = "Send Email?";
              command_state = "ls ~/tmp/offlinemsmtp-sendmail >/dev/null && echo 'Send Email'";
              command_on = "touch ~/tmp/offlinemsmtp-sendmail";
              command_off = "rm ~/tmp/offlinemsmtp-sendmail";
              interval = 5;
            }
            {
              block = "memory";
              format_mem = "{Mug}GiB";
              format_swap = "{SUg}GiB";
              warning_mem = 90;
              warning_swap = 90;
              critical_mem = 95;
              critical_swap = 95;
            }
            {
              block = "music";
              player = "sublimemusic";
              buttons = [ "play" "next" ];
            }

            (
              mkIf config.laptop.enable {
                block = "backlight";
              }
            )

            {
              block = "toggle";
              text = "CSM";
              command_state = "nmcli con show --active | grep 'Mines VPN'";
              command_on = "nmcli con up id 'Mines VPN'";
              command_off = "nmcli con down id 'Mines VPN'";
              interval = 5;
            }

            # Ping time
            {
              block = "custom";
              command = ''printf "P: %s" $(~/bin/parse-rolling-ping.sh)'';
              interval = 1;
            }

            {
              block = "net";
              device = "wlp0s20f3";
              ip = true;
              speed_down = false;
              graph_down = false;
              speed_up = false;
              graph_up = false;
              interval = 5;
              hide_missing = true;
              hide_inactive = true;
            }
            # TODO: include the second "net" block if on a computer with two net blocks.

            {
              block = "sound";
              step_width = 2;
            }
            {
              block = "time";
              format = "%F %R:%S";
              interval = 1;
            }
            {
              block = "battery";
              interval = 30;
              format = "{percentage}% {time}";
              device = "BAT0";
            }

            # TODO need to figure out how to do this for Sway
            (
              mkIf config.xorg.enable {
                block = "toggle";
                text = "DND";
                command_state = "ls ~/tmp/dnd >/dev/null && echo 'DND'";
                command_on = "notify-send 'DUNST_COMMAND_PAUSE' && touch ~/tmp/dnd";
                command_off = "notify-send 'DUNST_COMMAND_RESUME' && rm ~/tmp/dnd";
                interval = 60;
              }
            )
          ];
        };
      };
    };
  };
}
