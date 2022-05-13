{ config, lib, pkgs, ... }: with lib; let
  beeper-desktop = pkgs.callPackage ../pkgs/beeper-desktop.nix { };
  matrix-react-sdk = pkgs.callPackage ../pkgs/element/matrix-react-sdk.nix { };
in
{
  # Make Element use my patches
  nixpkgs.overlays = [
    (self: super: {
      element-desktop = pkgs.callPackage ../pkgs/element/element-desktop.nix {
        inherit (pkgs.darwin.apple_sdk.frameworks) Security AppKit CoreServices;
        electron = pkgs.electron_17;

        # Need to use the custom element-web until
        # https://github.com/NixOS/nixpkgs/pull/172928 gets merged, then I can just
        # do overrideAttrs on pkgs.element-web.
        element-web = (pkgs.callPackage ../pkgs/element/element-web.nix { }).overrideAttrs (old: rec {
          configurePhase = ''
            runHook preConfigure

            export HOME=$PWD/tmp
            mkdir -p $HOME

            fixup_yarn_lock yarn.lock
            yarn config --offline set yarn-offline-mirror $offlineCache
            yarn install --offline --frozen-lockfile --ignore-platform --ignore-scripts --no-progress --non-interactive
            patchShebangs node_modules

            # Replace with my matrix-react-sdk
            rm -rf node_modules/matrix-react-sdk
            ln -s ${matrix-react-sdk} node_modules/matrix-react-sdk

            runHook postConfigure
          '';
        });
      };
    })
  ];

  home.packages = with pkgs; [
    gomuks
  ] ++ optionals (config.wayland.enable || config.xorg.enable)
    [
      beeper-desktop
      discord
      element-desktop
      fractal
      mumble
      neochat
      nheko
      zoom-us
    ];
}
