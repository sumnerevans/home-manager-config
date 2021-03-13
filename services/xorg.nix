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

    # TODO dunst on i3

    # TODO use redshift when on i3

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
