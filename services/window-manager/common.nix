{ config, lib, pkgs }: with lib; {
  redshiftGammastepCfg = {
    enable = true;
    provider = "geoclue2";
    tray = true;

    temperature = {
      day = 5500;
      night = 4000;
    };
  };

  notificationColorConfig = {
    urgency_low = {
      frame_color = "#777777";
      foreground = "#777777";
      background = "#191311";
      timeout = 4;
    };

    urgency_normal = {
      frame_color = "#5B8234";
      foreground = "#5B8234";
      background = "#191311";
      timeout = 8;
    };

    urgency_critical = {
      frame_color = "#B7472A";
      foreground = "#B7472A";
      background = "#191311";
      timeout = 12;
    };
  };

  i3SwayConfig = let
    resizeStr = "  ";
    gapSize = 6;
    workspaces = [ "1: " "2" "3" "4" "5" "6" "7" "8" "9" "10" ];
    extraWorkspaces = [
      { name = "11: "; keycode = 20; }
      { name = "12: "; keycode = 21; }
    ];

    left = "h";
    down = "j";
    up = "k";
    right = "l";
    fonts = [ "Iosevka" "FontAwesome 12" ];

    menucalc = pkgs.callPackage ../../pkgs/menucalc.nix {};
  in
    {
      enable = true;
      config = rec {
        inherit fonts;
        gaps.inner = gapSize;
        modifier = config.windowManager.modKey;
        terminal = config.home.sessionVariables.TERMINAL;

        assigns = {
          # Browsers
          "${elemAt workspaces 0}" = [
            { class = "Pale moon"; }
            { class = "Firefox"; }
          ];

          # Chat Clients
          "${(elemAt extraWorkspaces 0).name}" = [
            { class = "discord"; }
            { class = "Element"; }
            { class = "HexChat"; }
            { class = "quassel"; }
            { class = "Slack"; }
            { class = "Telegram"; }
            { title = "Mutt"; }
          ];

          # Music
          "${(elemAt extraWorkspaces 1).name}" = [
            { class = "sublime-music"; }
          ];
        };

        bars = [
          {
            inherit fonts;
            position = "top";
            statusCommand = "${pkgs.i3status-rust}/bin/i3status-rs ${config.xdg.configHome}/i3status-rust/config-top.toml";
            colors = {
              background = "#00000090";
              separator = "#aaaaaa";
            };
          }
        ];

        floating.criteria = [
          { instance = "pinentry"; }
          { title = "Firefox - Sharing Indicator"; }
        ];

        keybindings = listToAttrs (
          # Switch to workspace
          (imap1 (i: name: { name = "${modifier}+${toString (mod i 10)}"; value = ''workspace "${name}"''; }) workspaces)
          # Move to workspace
          ++ (imap1 (i: name: { name = "${modifier}+Shift+${toString (mod i 10)}"; value = ''move container to workspace "${name}"''; }) workspaces)
        ) // {
          "${modifier}+Return" = "exec ${terminal}";
          "${modifier}+Shift+q" = "kill";

          # RESTART SWAY IN-PLACE (PRESERVES YOUR LAYOUT/SESSION, CAN BE USED TO UPGRADE SWAY)
          "${modifier}+Shift+R" = "reload";

          # LAUNCHERS
          "${modifier}+d" = "exec ${pkgs.rofi}/bin/rofi -show run";
          "${modifier}+space" = "exec ${pkgs.rofi}/bin/rofi -show drun -show-icons";
          F4 = "exec ${menucalc}/bin/= -- -lines 3"; # menu-calc
          F3 = "exec ${pkgs.rofi-pass}/bin/rofi-pass -- -i";

          # MOVEMENT
          "${modifier}+${left}" = "focus left";
          "${modifier}+${down}" = "focus down";
          "${modifier}+${up}" = "focus up";
          "${modifier}+${right}" = "focus right";

          # SPLIT IN HORIZONTAL/VERTICAL ORIENTATION
          "${modifier}+semicolon" = "split h";
          "${modifier}+v" = "split v";

          # CHANGE CONTAINER LAYOUT (STACKED, TABBED, TOGGLE SPLIT)
          "${modifier}+s" = "layout stacking";
          "${modifier}+w" = "layout tabbed";
          "${modifier}+e" = "layout toggle split";

          # ENTER FULLSCREEN MODE FOR THE FOCUSED CONTAINER
          "${modifier}+f" = "fullscreen toggle";

          # TOGGLE TILING / FLOATING
          button2 = "floating toggle";
          "${modifier}+Shift+space" = "floating toggle";

          # FOCUS THE PARENT CONTAINER
          "${modifier}+a" = "focus parent";

          # RESIZE
          "${modifier}+r" = ''mode "${resizeStr}"'';

          # GAPS
          "${modifier}+F3" = "gaps inner all set 0";
          "${modifier}+Shift+F3" = "gaps inner all set ${toString gapSize}";

          # VOLUME KEYS
          XF86AudioLowerVolume = "exec amixer set Master playback 2%-";
          XF86AudioRaiseVolume = "exec amixer set Master playback 2%+";
        };

        keycodebindings = listToAttrs (
          # Switch to workspace
          (imap1 (i: { name, keycode }: { name = "${modifier}+${toString keycode}"; value = ''workspace "${name}"''; }) extraWorkspaces)
          # Move to workspace
          ++ (imap1 (i: { name, keycode }: { name = "${modifier}+Shift+${toString keycode}"; value = ''move container to workspace "${name}"''; }) extraWorkspaces)
        ) // {
          "${modifier}+34" = "exec ${config.home.homeDirectory}/bin/mutt_helper.sh"; # Launch mutt
          "${modifier}+35" = "exec ${pkgs.element-desktop}/bin/element-desktop"; # Launch Element
        };

        modes = {
          "${resizeStr}" = {
            "${left}" = "resize shrink width 10 px";
            "${down}" = "resize grow height 10 px";
            "${up}" = "resize shrink height 10 px";
            "${right}" = "resize grow width 10 px";
            "Left" = "resize shrink width 10 px";
            "Down" = "resize grow height 10 px";
            "Up" = "resize shrink height 10 px";
            "Right" = "resize grow width 10 px";
            "Escape" = "mode default";
            "Return" = "mode default";
            "${modifier}+r" = "mode default";
          };
        };

        startup = let
          gsettings = "${pkgs.glib}/bin/gsettings";
          gnomeSchema = "org.gnome.desktop.interface";
        in
          [
            { command = "${config.home.homeDirectory}/bin/inactive-windows-transparency.py"; }

            # GTK
            { command = "${gsettings} set ${gnomeSchema} gtk-theme 'Arc-Dark'"; always = true; }
            { command = "${gsettings} set ${gnomeSchema} icon-theme 'Arc'"; always = true; }
            { command = "${gsettings} set ${gnomeSchema} cursor-theme 'breeze_cursors'"; always = true; }
          ];

        window = {
          border = 0;
          hideEdgeBorders = "both";
        };
      };
      extraConfig = ''
        seat * hide_cursor 2000
        # TODO REMOVE
        # vim ft=i3config
      '';
    };
}
