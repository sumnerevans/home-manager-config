{ config, lib, pkgs, ... }: with lib; let
  editor = "${pkgs.neovim}/bin/nvim";
  menucalc = pkgs.callPackage ../../pkgs/menucalc.nix { };
  terminal = "${pkgs.alacritty}/bin/alacritty";
  waylandCfg = config.wayland;
  xorgCfg = config.xorg;
in
{
  imports = [
    ./i3status-rust.nix
    ./rofi.nix
    ./wallpaper.nix
    ./wayland.nix
    ./writeping.nix
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
      menucalc
      screenkey
      wmctrl
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
        # Waiting for one of the fllowing PRs to be merged:
        # https://github.com/NixOS/nixpkgs/pull/122086
        # https://github.com/NixOS/nixpkgs/pull/122103
        package = pkgs.arc-theme.overrideAttrs (old: rec {
          pname = "arc-theme";
          version = "20210412";

          src = pkgs.fetchFromGitHub {
            owner = "jnsh";
            repo = pname;
            rev = version;
            sha256 = "BNJirtBtdWsIzQfsJsZzg1zFbJEzZPq1j2qZ+1QjRH8=";
            fetchSubmodules = false;
          };

          nativeBuildInputs = with pkgs; [
            meson
            ninja
            pkg-config
            sassc
            optipng
            inkscape
            gtk3
            cinnamon.cinnamon-common
            gnome.gnome-shell
          ];

          postInstall = ''
            install -Dm644 -t $out/share/doc/${pname} $src/AUTHORS $src/*.md
          '';
        });
        name = "Arc-Dark";
      };

      gtk3.extraConfig = {
        gtk-application-prefer-dark-theme = 1;
        gtk-toolbar-style = "GTK_TOOLBAR_ICONS";
        gtk-toolbar-icon-size = "GTK_ICON_SIZE_LARGE_TOOLBAR";
      };
    };

    qt = {
      enable = true;
      platformTheme = "gtk";
    };

    # Enable GUI services
    services.blueman-applet.enable = true;
    services.kdeconnect = { enable = true; indicator = true; };
    services.network-manager-applet.enable = true;
  };
}
