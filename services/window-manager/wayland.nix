{ config, lib, options, pkgs, ... }: with lib; let
  cfg = config.wayland;
  common = import ./common.nix { inherit config lib pkgs; };
  clipmanHistpath = ''--histpath="${config.xdg.cacheHome}/clipman.json"'';
  clipmanCmd = "${pkgs.clipman}/bin/clipman";
in
{
  options = {
    wayland.enable = mkOption {
      type = types.bool;
      description = "Enable the wayland stack";
      default = false;
    };
    wayland.extraSwayConfig = mkOption {
      type = types.attrsOf types.anything;
      description = "Extra config for Sway";
      default = {};
    };
  };

  config = mkIf cfg.enable {
    wayland.windowManager.sway = mkMerge [
      common.i3SwayConfig
      {
        wrapperFeatures.gtk = true;
        config.focus.forceWrapping = true;
        config.startup = let
          wlpaste = "${pkgs.wl-clipboard}/bin/wl-paste";
          gsettings = "${pkgs.glib}/bin/gsettings";
          gnomeSchema = "org.gnome.desktop.interface";
        in
          [
            # Clipboard Manager
            { command = "${wlpaste} -t text --watch ${clipmanCmd} store ${clipmanHistpath}"; }
            { command = "${wlpaste} -p -t text --watch ${clipmanCmd} store -P ${clipmanHistpath}"; }

            # Window transparency
            { command = "${config.home.homeDirectory}/bin/inactive-windows-transparency.py"; }

            # GTK
            { command = "${gsettings} set ${gnomeSchema} gtk-theme 'Arc-Dark'"; always = true; }
            { command = "${gsettings} set ${gnomeSchema} icon-theme 'Arc'"; always = true; }
            { command = "${gsettings} set ${gnomeSchema} cursor-theme 'capitaine-cursors'"; always = true; }
            { command = "${gsettings} set ${gnomeSchema} cursor-size 24"; always = true; }
          ];

        config.keybindings = let
          modifier = config.windowManager.modKey;
          swaylockCmd = concatStringsSep " " [
            "${pkgs.swaylock-effects}/bin/swaylock"
            "--screenshots"
            "--clock"
            "--indicator"
            "--indicator-radius 100"
            "--indicator-thickness 7"
            "--effect-blur 7x5"
            "--effect-vignette 0.7:0.7"
            "--fade-in 0.5"
          ];
          grim = "${pkgs.grim}/bin/grim";
          slurp = "${pkgs.slurp}/bin/slurp";
          screenshotOutfile = "${config.home.homeDirectory}/tmp/$(${pkgs.coreutils}/bin/date +%Y-%m-%d-%T).png";
        in
          {
            # Popup Clipboard Manager
            "${modifier}+c" = "exec ${clipmanCmd} pick -t rofi ${clipmanHistpath}";

            # Lock screen
            "${modifier}+Shift+x" = "exec ${swaylockCmd}";

            # exit sway (logs you out of your session)
            "${modifier}+Shift+e" = "exec ${pkgs.sway}/bin/swaynag -t warning -m 'You pressed the exit shortcut. Do you really want to exit sway? This will end your Wayland session.' -b 'Yes, exit sway' 'swaymsg exit'";

            # Screenshots
            "${modifier}+shift+c" = ''exec ${grim} -g "$(${slurp})" ${screenshotOutfile}'';
            Print = "exec ${grim} ${screenshotOutfile}";
          };

        extraConfig = ''
          seat * hide_cursor 2000
          seat * xcursor_theme capitaine-cursors 24
        '';
      }
      cfg.extraSwayConfig
    ];

    home.sessionVariables = {
      GTK_THEME = "Arc-Dark";
      MOZ_ENABLE_WAYLAND = "1";
      XDG_CURRENT_DESKTOP = "sway";
      XDG_SESSION_TYPE = "wayland";
    };

    home.packages = with pkgs; [
      clipman
      glib
      grim
      slurp
      v4l-utils
      wf-recorder
      wl-clipboard # clipboard management
      capitaine-cursors
      # TODO use wofi?
    ];

    # Gammastep
    services.gammastep = common.redshiftGammastepCfg;

    programs.mako = {
      enable = true;

      borderRadius = 5;
      borderSize = 2;
      defaultTimeout = 8000;
      font = "Iosevka 12";
      groupBy = "app-name,summary";
      sort = "-priority";
      width = 400;
      backgroundColor = common.notificationColorConfig.urgency_normal.background + "CC";
      borderColor = common.notificationColorConfig.urgency_normal.frame_color;
      textColor = common.notificationColorConfig.urgency_normal.foreground;

      extraConfig = generators.toINI {} (
        mapAttrs' (
          name: val: nameValuePair
            (builtins.replaceStrings [ "_" "critical" ] [ "=" "high" ] name)
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
        ) common.notificationColorConfig
      );
    };
  };
}