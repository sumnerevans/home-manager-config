{ config, lib, pkgs, ... }: with lib; let
  cfg = config.xorg;
in
{
  options = {
    xorg.enable = mkOption {
      type = types.bool;
      description = "Enable Xorg stack";
      default = false;
    };
  };

  config = mkIf cfg.enable {
    services.clipmenu.enable = true;
    home.sessionVariables = {
      CM_HISTLENGTH = "20";
      CM_LAUNCHER = "rofi";
    };

    # xsession.pointerCursor = {
    #   package = pkgs.capitaine-cursors;
    #   name = "Capitaine";
    # };

    services.dunst = {
      enable = true;
      iconTheme = {
        name = "hicolor";
        package = pkgs.paper-icon-theme;
        size = "32x32";
      };
      settings = {
        global = {
          geometry = "350x50-15+45";
          transparency = 10;
          padding = 6;
          horizontal_padding = 6;
          frame_color = "#8EC07C";
          corner_radius = 5;
          sort = false;
          idle_threshold = 30;
          show_age_threshold = 20;

          # Text
          font = "Iosevka Term 11";
          line_height = 3;
          format = "<b>%s</b>\\n%b\\n%p";
        };

        urgency_low = {
          frame_color = "#3B7C87";
          foreground = "#3B7C87";
          background = "#191311";
          timeout = 4;
        };

        urgency_normal = {
          frame_color = "#5B8234";
          foreground = "#5B8234";
          background = "#191311";
          timeout = 6;
        };

        urgency_critical = {
          frame_color = "#B7472A";
          foreground = "#B7472A";
          background = "#191311";
          timeout = 8;
        };
      };
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
