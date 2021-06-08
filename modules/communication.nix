{ config, lib, pkgs, ... }: with lib; with pkgs; {
  nixpkgs.overlays = [
    (
      self: super: {
        element-desktop = super.element-desktop.overrideAttrs (
          old: rec {
            version = "1.7.30";
            src = fetchFromGitHub {
              owner = "vector-im";
              repo = "element-desktop";
              rev = "v${version}";
              sha256 = "09k1xxmzqvw8c1x9ndsdvwj4598rdx9zqraz3rmr3i58s51vycxp";
            };

            packageJSON = ./element/element-desktop-package.json;
            yarnNix = ./element/element-desktop-yarndeps.nix;
          }
        );

        element-web = super.element-web.overrideAttrs (
          old: rec {
            version = "1.7.30";
            src = fetchurl {
              url = "https://github.com/vector-im/element-web/releases/download/v${version}/element-v${version}.tar.gz";
              sha256 = "1pnmgdyacxfk8hdf930rqqvqrcvckc3m4pb5mkznlirsmw06nfay";
            };
          }
        );
      }
    )
  ];

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
