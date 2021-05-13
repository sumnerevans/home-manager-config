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

  # Always restart/start/stop systemd services on home manager switch.
  systemd.user.startServices = "sd-switch";
}
