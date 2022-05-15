{ config, lib, options, pkgs, ... }: with lib; let
  cfg = config.wayland;
  common = import ./common.nix { inherit config lib pkgs; };
  clipmanHistpath = ''--histpath="${config.xdg.cacheHome}/clipman.json"'';
  clipmanCmd = "${pkgs.clipman}/bin/clipman";

  swaylock-effects = pkgs.swaylock-effects.overrideAttrs (old: rec {
    pname = "swaylock-effects";
    version = "unstable-2022-03-05";

    src = pkgs.fetchFromGitHub {
      owner = "mortie";
      repo = "swaylock-effects";
      rev = "a8fc557b86e70f2f7a30ca9ff9b3124f89e7f204";
      sha256 = "sha256-GN+cxzC11Dk1nN9wVWIyv+rCrg4yaHnCePRYS1c4JTk=";
    };

    patches = [ ];

    postPatch = ''
      sed -iE "s/version: '1\.3',/version: '${version}',/" meson.build
    '';
  });

  swaylockCmd = concatStringsSep " " [
    "${swaylock-effects}/bin/swaylock"
    "--daemonize"
    "--screenshots"
    "--color 000000"
    "--clock"
    "--ignore-empty-password"
    "--indicator"
    "--indicator-radius 100"
    "--indicator-thickness 7"
    "--effect-blur 7x5"
    "--effect-vignette 0.7:0.7"
    "--fade-in 0.5"
  ];
in
{
  options = {
    wayland.enable = mkEnableOption "the Wayland stack";
    wayland.extraSwayConfig = mkOption {
      type = types.attrsOf types.anything;
      description = "Extra config for Sway";
      default = { };
    };
  };

  config = mkIf cfg.enable {
    # Lock screen & screen off
    services.swayidle = {
      enable = true;
      timeouts = [
        { timeout = 300; command = swaylockCmd; }
        {
          timeout = 360;
          command = ''${pkgs.sway}/bin/swaymsg "output * dpms off"'';
          resumeCommand = ''${pkgs.sway}/bin/swaymsg "output * dpms on"'';
        }
      ];
      events = [
        { event = "before-sleep"; command = "${pkgs.playerctl}/bin/playerctl pause"; }
        { event = "before-sleep"; command = swaylockCmd; }
      ];
    };

    wayland.windowManager.sway = mkMerge [
      common.i3SwayConfig
      {
        wrapperFeatures.gtk = true;
        config.focus.forceWrapping = true;
        config.startup =
          let
            wlpaste = "${pkgs.wl-clipboard}/bin/wl-paste";
            gsettings = "${pkgs.glib}/bin/gsettings";
            gnomeSchema = "org.gnome.desktop.interface";
            inactive-windows-transparency = pkgs.writeScriptBin "inactive-windows-transparency"
              (builtins.readFile ./bin/inactive-windows-transparency.py);
          in
          [
            # Clipboard Manager
            { command = "${wlpaste} -t text --watch ${clipmanCmd} store --max-items=10000 ${clipmanHistpath}"; }
            { command = "${wlpaste} -p -t text --watch ${clipmanCmd} store -P --max-items=10000 ${clipmanHistpath}"; }

            # Window transparency
            { command = "${inactive-windows-transparency}/bin/inactive-windows-transparency"; }

            # Make all the pinentry stuff work
            # See: https://github.com/NixOS/nixpkgs/issues/119445#issuecomment-820507505
            # and: https://github.com/NixOS/nixpkgs/issues/57602#issuecomment-820512097
            { command = "dbus-update-activation-environment WAYLAND_DISPLAY"; }

            # Wallpaper
            { command = "systemctl restart --user wallpaper.service"; always = true; }
          ];

        config.input = {
          "*" = {
            # Always use natural scrolling
            natural_scroll = "enabled";

            # Get right click (2 finger) and middle click (3 finger) on touchpad
            click_method = "clickfinger";
          };

          "type:keyboard" = {
            # Use 3l by default for all keyboards that get attached
            xkb_layout = "us";
            xkb_variant = "3l";
          };

          # Use normal layout for Yubikey so that we don't get weirdness
          "4176:1031:Yubico_YubiKey_OTP+FIDO+CCID" = {
            xkb_layout = "us";
            xkb_variant = ''""'';
          };
        };

        config.keybindings =
          let
            modifier = config.windowManager.modKey;
            grim = "${pkgs.grim}/bin/grim";
            slurp = "${pkgs.slurp}/bin/slurp";
            screenshotOutfile = "${config.home.homeDirectory}/tmp/$(${pkgs.coreutils}/bin/date +%Y-%m-%d-%T).png";
            screenshotSlurpScript = pkgs.writeShellScriptBin "screenshot" ''
              filename=${screenshotOutfile}
              ${grim} -g "$(${slurp})" $filename
              ${pkgs.wl-clipboard}/bin/wl-copy <$filename
            '';
            screenshotFullscreenScript = pkgs.writeShellScriptBin "screenshot" ''
              filename=${screenshotOutfile}
              ${grim} $filename
              ${pkgs.wl-clipboard}/bin/wl-copy <$filename
            '';
          in
          {
            # Popup Clipboard Manager
            "${modifier}+c" = "exec ${clipmanCmd} pick -t rofi ${clipmanHistpath}";

            # Lock screen
            "${modifier}+Shift+x" = "exec ${swaylockCmd}";

            # exit sway (logs you out of your session)
            "${modifier}+Shift+e" = "exec ${pkgs.sway}/bin/swaynag -t warning -m 'You pressed the exit shortcut. Do you really want to exit sway? This will end your Wayland session.' -b 'Yes, exit sway' 'swaymsg exit'";

            # Screenshots
            "${modifier}+shift+c" = "exec ${screenshotSlurpScript}/bin/screenshot";
            Print = "exec ${screenshotFullscreenScript}/bin/screenshot";
          };

        config.seat."*" = {
          hide_cursor = "when-typing enable";
          xcursor_theme = "capitaine-cursors 24";
        };
      }
      cfg.extraSwayConfig
    ];

    home.sessionVariables = {
      GTK_THEME = "Arc-Dark";
      MOZ_ENABLE_WAYLAND = "1";
      XDG_CURRENT_DESKTOP = "sway";
      XDG_SESSION_TYPE = "wayland";

      # Make IDEA work
      _JAVA_AWT_WM_NONREPARENTING = "1";
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

    programs.mpv.config = {
      gpu-context = "wayland";
    };

    # Gammastep
    services.gammastep = common.redshiftGammastepCfg;

    programs.mako = {
      enable = true;
      package = pkgs.mako.overrideAttrs (old: rec {
        pname = "mako";
        version = "unstable-2022-05-14";

        src = pkgs.fetchFromGitHub {
          owner = "emersion";
          repo = pname;
          rev = "55104d36575230d57af007cd9e7d53cb3a92a96e";
          sha256 = "sha256-n5KsA/PmH+wE/6RHP4ACG9b7xmF48AqjEPnuIptofLQ=";
        };
      });

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

      extraConfig = generators.toINI { } (
        mapAttrs'
          (
            name: val: nameValuePair
              (builtins.replaceStrings [ "_" "critical" ] [ "=" "high" ] name)
              (
                mapAttrs'
                  (
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
                  )
                  val
              )
          )
          common.notificationColorConfig
      );
    };
  };
}
