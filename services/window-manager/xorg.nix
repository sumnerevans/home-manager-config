{ config, lib, pkgs, ... }: with lib; let
  cfg = config.xorg;
  common = import ./common.nix { inherit config lib pkgs; };
in
{
  options = {
    xorg.enable = mkOption {
      type = types.bool;
      description = "Enable Xorg stack";
      default = false;
    };
    xorg.extrai3wmConfig = mkOption {
      type = types.attrsOf types.anything;
      description = "Extra config for i3wm";
      default = {};
    };
  };

  config = mkIf cfg.enable {
    xsession.windowManager.i3 = mkMerge [
      common.i3SwayConfig
      {
        config.startup = [
          { command = "${config.home.homeDirectory}/bin/display-configuration.sh"; }
          { command = "systemctl --user import-environment; systemctl --user start graphical-session.target"; }
        ];

        config.keybindings = let
          modifier = config.windowManager.modKey;
          scrot = "${pkgs.scrot}/bin/scrot";
          i3lockcmd = "${pkgs.i3lock-fancy}/bin/i3lock-fancy --font Iosevka -- ${scrot} -z";
          tmpdir = "${config.home.homeDirectory}/tmp";
        in
          {
            # Popup Clipboard Manager
            "${modifier}+c" = "exec ${pkgs.clipmenu}/bin/clipmenu";

            # Lock screen
            "${modifier}+Shift+x" = "exec ${config.home.homeDirectory}/bin/fuzzy_lock_sleep.sh";

            # exit i3wm (logs you out of your session)
            "${modifier}+Shift+e" = "exec ${pkgs.i3-gaps}/bin/i3-nagbar -t warning -m 'You pressed the exit shortcut. Do you really want to exit i3? This will end your X session.' -b 'Yes, exit i3' 'i3-msg exit'";

            # Screenshots
            "${modifier}+shift+c" = "${scrot} -s '%Y-%m-%d-%T.png' -e 'mv $f ${tmpdir} && xclip -selection clipboard -i ${tmpdir}/$f -t image/png'";
            "${modifier}+shift+ctrl+c" = "exec ${scrot}";
            "${modifier}+shift+f" = "exec ${pkgs.flameshot}/bin/flameshot gui -p ${tmpdir}";
          };
      }
      cfg.extrai3wmConfig
    ];

    services.clipmenu.enable = true;
    home.sessionVariables = {
      CM_HISTLENGTH = "20";
      CM_LAUNCHER = "rofi";
    };

    # xsession.pointerCursor = {
    #   package = pkgs.capitaine-cursors;
    #   name = "Capitaine";
    # };

    services.redshift = common.redshiftGammastepCfg;

    services.dunst = {
      enable = true;
      iconTheme = {
        name = "hicolor";
        package = pkgs.paper-icon-theme;
        size = "32x32";
      };
      settings = {
        global = {
          corner_radius = 5;
          frame_color = "#8EC07C";
          geometry = "350x50-15+45";
          horizontal_padding = 6;
          idle_threshold = 30;
          markup = true;
          padding = 6;
          show_age_threshold = 20;
          show_indicators = false;
          transparency = 10;

          # Text
          font = "Iosevka 10";
          format = "<b>%s</b>\\n%b\\n%p";
          line_height = 3;
        };
      } // common.notificationColorConfig;
    };

    services.picom = {
      enable = true;
      vSync = true;

      fade = true;
      fadeDelta = 5;

      inactiveOpacity = "0.8";
      opacityRule = [
        "100:class_g = 'obs'"
        "100:class_g = 'i3lock'"
      ];

      shadow = true;
      shadowExclude = [
        "name = 'Notification'"
        "class_g = 'Conky'"
        "class_g ?= 'Notify-osd'"
        "class_g = 'Cairo-clock'"
        "class_g = 'i3-frame'"
        "_GTK_FRAME_EXTENTS@:c"
      ];
    };
  };
}
