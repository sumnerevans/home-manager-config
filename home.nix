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

  # services.pantalaimon = {
  #   enable = true;
  #   settings = {
  #     Default = {LogLevel="Debug";SSL=true;};
  #     local-matrix = {Homeserver="https://matrix.sumnerevans.com";ListenAddress="127.0.0.1";ListenPort=8008;};
  #   };
  # };
}
