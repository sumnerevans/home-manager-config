{ config, lib, pkgs, ... }: with lib; with pkgs; {
  nixpkgs.overlays = [
    (self: super: {
      element-desktop = super.element-desktop.overrideAttrs (old: rec {
        version = "1.7.29";
        src = fetchFromGitHub {
          owner = "vector-im";
          repo = "element-desktop";
          rev = "v${version}";
          sha256 = "sha256-nCtgVVOdjZ/OK8gMInBbNeuJadchDYUO2UQxEmcOm4s=";
        };

        packageJSON = ./element-desktop-package.json;
      });

      element-web = super.element-web.overrideAttrs (old: rec {
        version = "1.7.29";
        src = fetchurl {
          url = "https://github.com/vector-im/element-web/releases/download/v${version}/element-v${version}.tar.gz";
          sha256 = "sha256-wFC0B9v0V3JK9sLKH7GviVO/JEjePOJ06PwRq/MVqDE=";
        };
      });
    })
  ];

  home.packages = optionals
    (config.wayland.enable || config.xorg.enable)
    [
      discord
      element-desktop
      fractal
      mumble
      zoom-us
    ];
}
