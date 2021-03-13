{ config, lib, pkgs, ... }: with lib; let
  editor = "${pkgs.neovim}/bin/nvim";
  terminal = "${pkgs.alacritty}/bin/alacritty";
  waylandCfg = config.wayland;
  xorgCfg = config.xorg;

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
in
{
  config = mkIf (waylandCfg.enable || xorgCfg.enable) {
    home.packages = with pkgs; [
      brightnessctl
      rofi
      rofi-pass
      screenkey
    ];

    home.sessionVariables = {
      VISUAL = "${editor}";
      EDITOR = "${editor}";
      TERMINAL = "${terminal}";
    };

    services = {
      # Redshift/gammastep
      gammastep = mkIf waylandCfg.enable redshiftGammastepCfg;
      redshift = mkIf xorgCfg.enable redshiftGammastepCfg;

      # Dunst
      dunst.settings = mkIf xorgCfg.enable notificationColorConfig;
    };

    # Mako
    programs.mako.extraConfig = mkIf waylandCfg.enable (
      generators.toINI {} (
        mapAttrs' (
          name: val: nameValuePair
            (builtins.replaceStrings "_" "=" name)
            (
              mapAttrs' (
                k: v:
                  nameValuePair
                    (
                      if k == "timeout" then "default-timeout"
                      else if k == "frame_color" then "border-color"
                      else if k == "foreground" then "text-color"
                      else if k == "background" then "background-color"
                      else k
                    )
                    (
                      if k == "timeout" then v * 1000
                      else if k == "background" then v + "CC"
                      else v
                    )
              ) val
            )
        ) notificationColorConfig
      )
    );

    gtk = {
      enable = true;
      iconTheme = {
        package = pkgs.arc-icon-theme;
        name = "Arc";
      };

      theme = {
        package = pkgs.arc-theme;
        name = "Arc-Dark";
      };

      gtk3.extraConfig = {
        gtk-application-prefer-dark-theme = 1;
        gtk-toolbar-style = "GTK_TOOLBAR_ICONS";
        gtk-toolbar-icon-size = "GTK_ICON_SIZE_LARGE_TOOLBAR";
      };
    };
  };
}
