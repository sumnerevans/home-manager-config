{ config, lib, pkgs, ... }: let
  agentTTL = 60 * 60 * 4; # 4 hours
  waylandCfg = config.wayland;
  xorgCfg = config.xorg;

  yubikey-touch-detector = pkgs.callPackage ../pkgs/yubikey-touch-detector.nix {};
in
{
  programs.gpg.enable = true;

  # Make the gpg-agent work
  services.gpg-agent = {
    enable = true;
    defaultCacheTtl = agentTTL;
    maxCacheTtl = agentTTL;
    pinentryFlavor = "gnome3";
    verbose = true;
  };


  systemd.user.services.yubikey-touch-detector = lib.mkIf (waylandCfg.enable || xorgCfg.enable) {
    Unit = {
      Description = "YubiKey touch detector";
      PartOf = [ "graphical-session.target" ];
    };

    Service = {
      ExecStart = "${yubikey-touch-detector}/bin/yubikey-touch-detector --libnotify";
      Restart = "always";
      RestartSec = 5;
    };

    Install.WantedBy = [ "graphical-session.target" ];
  };
}
