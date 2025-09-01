{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.wayland;
  common = import ./common.nix { inherit config lib pkgs; };
  clipmanHistpath = ''--histpath="${config.xdg.cacheHome}/clipman.json"'';
  clipmanCmd = "${pkgs.clipman}/bin/clipman";

  swaylockCmd = concatStringsSep " " [
    "${pkgs.swaylock-effects}/bin/swaylock"
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
  ];
in {
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
      timeouts = [{
        timeout = 300;
        command = swaylockCmd;
      }];
      events = [
        {
          event = "before-sleep";
          command = "${pkgs.playerctl}/bin/playerctl pause";
        }
        {
          event = "before-sleep";
          command = swaylockCmd;
        }
      ];
    };

    wayland.windowManager.sway = mkMerge [
      common.i3SwayConfig
      {
        wrapperFeatures.gtk = true;
        config.focus.wrapping = "yes";
        config.startup = let
          wlpaste = "${pkgs.wl-clipboard}/bin/wl-paste";
          inactive-windows-transparency =
            pkgs.writers.writePyPy3Bin "inactive-windows-transparency" {
              libraries = [ pkgs.python3Packages.i3ipc ];
            } (builtins.readFile ./bin/inactive-windows-transparency.py);
        in [
          # Clipboard Manager
          {
            command =
              "${wlpaste} -t text --watch ${clipmanCmd} store --max-items=10000 ${clipmanHistpath}";
          }
          {
            command =
              "${wlpaste} -p -t text --watch ${clipmanCmd} store -P --max-items=10000 ${clipmanHistpath}";
          }

          # Window transparency
          {
            command =
              "${inactive-windows-transparency}/bin/inactive-windows-transparency";
          }

          # Make all the pinentry stuff work
          # See: https://github.com/NixOS/nixpkgs/issues/119445#issuecomment-820507505
          # and: https://github.com/NixOS/nixpkgs/issues/57602#issuecomment-820512097
          {
            command = "dbus-update-activation-environment WAYLAND_DISPLAY";
          }

          # Wallpaper
          {
            command = "systemctl restart --user wallpaper.service";
            always = true;
          }
        ];

        config.input = let
          useUS = [
            # My Ergodox has a hardware 3l implementation.
            "12951:18806:ZSA_Technology_Labs_ErgoDox_EZ_Glow"
            "12951:18806:ZSA_Technology_Labs_ErgoDox_EZ_Glow_Consumer_Control"
            "12951:18806:ZSA_Technology_Labs_ErgoDox_EZ_Glow_Keyboard"
            "12951:18806:ZSA_Technology_Labs_ErgoDox_EZ_Glow_System_Control"
            # My Voyager has a hardware 3l implementation.
            "12951:6519:ZSA_Technology_Labs_Voyager"
            "12951:6519:ZSA_Technology_Labs_Voyager_Consumer_Control"
            "12951:6519:ZSA_Technology_Labs_Voyager_System_Control"
            "12951:6519:ZSA_Technology_Labs_Voyager_Keyboard"
            # Use normal layout for Yubikey
            "4176:1031:Yubico_YubiKey_OTP+FIDO+CCID"
          ];
        in {
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
        } // (listToAttrs (map (identifier: {
          name = identifier;
          value = {
            xkb_layout = "us";
            xkb_variant = ''""'';
          };
        }) useUS));

        config.keybindings = let
          modifier = config.windowManager.modKey;
          screenshotOutfile =
            "${config.home.homeDirectory}/tmp/$(${pkgs.coreutils}/bin/date +%Y-%m-%d-%T).png";
          flameshotCopyScript = pkgs.writeShellScriptBin "flameshot-copy" ''
            filename=${screenshotOutfile}
            ${pkgs.flameshot}/bin/flameshot gui -p $filename
            ${pkgs.wl-clipboard}/bin/wl-copy <$filename
          '';
          screenshotFullscreenScript = pkgs.writeShellScriptBin "screenshot" ''
            filename=${screenshotOutfile}
            ${pkgs.grim}/bin/grim $filename
            ${pkgs.wl-clipboard}/bin/wl-copy <$filename
          '';
        in {
          # Popup Clipboard Manager
          "${modifier}+c" =
            "exec ${clipmanCmd} pick -t rofi ${clipmanHistpath}";

          # Lock screen
          "${modifier}+Shift+x" = "exec ${swaylockCmd}";

          # exit sway (logs you out of your session)
          "${modifier}+Shift+e" =
            "exec ${pkgs.sway}/bin/swaynag -t warning -m 'You pressed the exit shortcut. Do you really want to exit sway? This will end your Wayland session.' -b 'Yes, exit sway' 'swaymsg exit'";

          # Screenshots
          "${modifier}+shift+c" =
            "exec ${flameshotCopyScript}/bin/flameshot-copy";
          Print = "exec ${screenshotFullscreenScript}/bin/screenshot";
        };

        config.window.commands = [{
          command = "fullscreen enable global";
          criteria = {
            title = "flameshot";
            app_id = "flameshot";
          };
        }];

        config.seat."*" = {
          hide_cursor = "when-typing enable";
          xcursor_theme = "phinger-cursors-light 32";
        };
      }
      cfg.extraSwayConfig
    ];

    home.sessionVariables = {
      MOZ_ENABLE_WAYLAND = "1";
      XDG_CURRENT_DESKTOP = "sway";
      XDG_SESSION_TYPE = "wayland";
      NIXOS_OZONE_WL = "1";

      # Make IDEA work
      _JAVA_AWT_WM_NONREPARENTING = "1";
    };

    home.packages = with pkgs; [
      clipman
      flameshot
      glib
      grim
      slurp
      v4l-utils
      wf-recorder
      wl-clipboard # clipboard management
      # TODO use wofi?
    ];

    programs.mpv.config = { gpu-context = "wayland"; };

    # Gammastep
    services.gammastep = common.redshiftGammastepCfg;

    services.mako = {
      enable = true;

      settings = {
        border-radius = "5";
        border-size = "2";
        default-timeout = "8000";
        font = "Iosevka 12";
        group-by = "app-name,summary";
        sort = "-priority";
        width = "400";
        background-color = "#191311";
        border-color = "#5B8234";
        text-color = "#5B8234";

        "urgency=critical" = {
          border-color = "#B7472A";
          text-color = "#B7472A";
          background-color = "#191311";
          default-timeout = "60000";
        };

        "urgency=low" = {
          border-color = "#777777";
          text-color = "#777777";
          background-color = "#191311";
        };
      };
    };
  };
}
