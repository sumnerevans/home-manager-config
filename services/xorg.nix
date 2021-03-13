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

      extraOptions = let
        # Basically a tinkered lib.generators.mkKeyValueDefault
        # It either serializes a top-level definition "key: { values };"
        # or an expression "key = { values };"
        mkAttrsString = top:
          mapAttrsToList (
            k: v:
              let
                sep = if (top && isAttrs v) then ":" else "=";
              in
                "${escape [ sep ] k}${sep}${mkValueString v};"
          );

        # This serializes a Nix expression to the libconfig format.
        mkValueString = v:
          if types.bool.check v then boolToString v
          else if types.int.check v then toString v
          else if types.float.check v then toString v
          else if types.str.check v then "\"${escape [ "\"" ] v}\""
          else if builtins.isList v then "[ ${concatMapStringsSep " , " mkValueString v} ]"
          else if types.attrs.check v then "{ ${concatStringsSep " " (mkAttrsString false v) } }"
          else throw ''
            invalid expression used in option services.picom.settings:
            ${v}
          '';

        toConf = attrs: concatStringsSep "\n" (mkAttrsString true attrs);
      in
        toConf {
          wintypes = {
            tooltip = { shadow = true; opacity = 0.9; focus = true; full-shadow = false; };
            dock = { shadow = false; };
            dnd = { shadow = false; };
            popup_menu = { opacity = 0.9; };
            dropdown_menu = { opacity = 0.9; };
          };
        };
    };
  };
}
