{ config, pkgs, ... }: {
  imports = [
    ./modules
    ./programs
    ./host-config.nix
  ];

  home = {
    stateVersion = "21.03";
    username = "sumner";
    homeDirectory = "/home/sumner";
  };

  nixpkgs.overlays = [
    # https://github.com/NixOS/nixpkgs/pull/15907
    (self: super: {
      remarshal = super.remarshal.overrideAttrs (old: rec {
        postPatch = ''
          substituteInPlace pyproject.toml \
            --replace "poetry.masonry.api" "poetry.core.masonry.api" \
            --replace 'PyYAML = "^5.3"' 'PyYAML = "*"' \
            --replace 'tomlkit = "^0.7"' 'tomlkit = "*"'
        '';
      });
    })
  ];

  # Always restart/start/stop systemd services on home manager switch.
  systemd.user.startServices = "sd-switch";
}
