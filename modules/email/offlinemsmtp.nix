{ config, pkgs, ... }: with pkgs; let
  offlinemsmtp = callPackage ../../pkgs/offlinemsmtp.nix {};
in
{
  systemd.user.services.offlinemsmtp = {
    Unit = {
      Description = "offlinemsmtp daemon";
      PartOf = [ "graphical-session.target" ];
    };

    Service = {
      ExecStart = ''
        ${offlinemsmtp}/bin/offlinemsmtp --daemon \
          --send-mail-file ${config.home.homeDirectory}/tmp/offlinemsmtp-sendmail \
          --file ${config.xdg.configHome}/msmtp/config
      '';
      Restart = "always";
      RestartSec = 5;
    };

    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };
}
