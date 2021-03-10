{ config, lib, pkgs, ... }: with lib; let
  waylandCfg = config.wayland;
  xorgCfg = config.xorg;
in
{
  config = mkIf (waylandCfg.enable || xorgCfg.enable) {
    home.packages = with pkgs; [
      brightnessctl
      rofi
      rofi-pass
      screenkey
    ];

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
