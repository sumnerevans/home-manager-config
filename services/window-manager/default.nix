{ config, lib, pkgs, ... }: with lib; let
  editor = "${pkgs.neovim}/bin/nvim";
  terminal = "${pkgs.alacritty}/bin/alacritty";
  waylandCfg = config.wayland;
  xorgCfg = config.xorg;
in
{
  imports = [
    ./wayland.nix
    ./xorg.nix
  ];

  options = {
    windowManager.modKey = mkOption {
      type = types.enum [ "Shift" "Control" "Mod1" "Mod2" "Mod3" "Mod4" "Mod5" ];
      default = "Mod4";
      description = "Modifier key that is used for all default keybindings.";
    };
  };

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
