{ config, lib, pkgs, ... }: with lib; with pkgs; {
  # nixpkgs.overlays = [
  #   (
  #     self: super: {
  #       element-desktop = super.element-desktop.overrideAttrs (
  #         old: rec {
  #           version = "1.7.30";
  #           src = fetchFromGitHub {
  #             owner = "vector-im";
  #             repo = "element-desktop";
  #             rev = "v${version}";
  #             sha256 = "0000000000000000000000000000000000000000000000000000";
  #           };

  #           packageJSON = ./element/element-desktop-package.json;
  #           yarnNix = ./element/element-desktop-yarndeps.nix;
  #         }
  #       );

  #       element-web = super.element-web.overrideAttrs (
  #         old: rec {
  #           version = "1.7.30";
  #           src = fetchurl {
  #             url = "https://github.com/vector-im/element-web/releases/download/v${version}/element-v${version}.tar.gz";
  #             sha256 = "0000000000000000000000000000000000000000000000000000";
  #           };
  #         }
  #       );
  #     }
  #   )
  # ];

  home.packages = optionals (config.wayland.enable || config.xorg.enable)
    [
      discord
      element-desktop
      fractal
      mumble
      neochat
      nheko
      zoom-us
    ];
}
