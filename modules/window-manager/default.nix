{ config, lib, pkgs, ... }:
with lib;
let
  terminal = "${pkgs.kitty}/bin/kitty";
  waylandCfg = config.wayland;
  xorgCfg = config.xorg;
in {
  imports = [
    ./autorandr.nix
    ./i3status-rust.nix
    ./kanshi.nix
    ./kitty.nix
    ./rofi.nix
    ./wallpaper.nix
    ./wayland.nix
    ./writeping.nix
    ./xorg.nix
  ];

  options = {
    windowManager.modKey = mkOption {
      type =
        types.enum [ "Shift" "Control" "Mod1" "Mod2" "Mod3" "Mod4" "Mod5" ];
      default = "Mod4";
      description = "Modifier key that is used for all default keybindings.";
    };
  };

  config = mkIf (waylandCfg.enable || xorgCfg.enable) {
    home.packages = with pkgs; [ brightnessctl menucalc wmctrl ];

    home.sessionVariables = {
      TERMINAL = "${terminal}";
      GTK_THEME = "Arc-Dark";
    };

    home.pointerCursor = {
      package = pkgs.phinger-cursors;
      name = "phinger-cursors-light";
      size = 32;

      gtk.enable = true;
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

      gtk4.extraConfig = { gtk-application-prefer-dark-theme = 1; };
    };

    qt = {
      enable = true;
      platformTheme.name = "gtk";
    };

    # Enable GUI services
    services.blueman-applet.enable = true;
    services.kdeconnect = {
      enable = true;
      indicator = true;
    };
    services.network-manager-applet.enable = true;
  };
}
