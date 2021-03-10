{ config, lib, pkgs, ... }: with lib; let
  cfg = config.wayland;
in
{
  options = {
    wayland.enable = mkOption {
      type = types.bool;
      description = "Enable the wayland stack";
      default = false;
    };
  };

  config = mkIf cfg.enable {
    services.gammastep = {
      enable = true;
      provider = "geoclue2";
      tray = true;

      temperature = {
        day = 5500;
        night = 4000;
      };
    };

    home.sessionVariables = {
      GTK_THEME = "Arc-Dark";
      MOZ_ENABLE_WAYLAND = "1";
      XDG_CURRENT_DESKTOP = "sway";
      XDG_SESSION_TYPE = "wayland";
    };

    home.packages = with pkgs; [
      clipman
    ];

    programs.mako = {
      enable = true;

      borderRadius = 5;
      borderSize = 2;
      defaultTimeout = 8000;
      font = "Iosevka 12";
      groupBy = "app-name,summary";
      sort = "-priority";
      width = 400;

      # Colors
      backgroundColor = "#191311CC";
      borderColor = "#5B8234";
      textColor = "#5B8234";

      extraConfig = ''
        [urgency=low]
        border-color=#777777
        text-color=#777777
        default-timeout=4000

        [urgency=high]
        border-color=#B7472A
        text-color=#B7472A
        background-color=#191311CC
        default-timeout=12000
      '';
    };

    # wayland.windowManager.sway.enable = true;
  };
}
