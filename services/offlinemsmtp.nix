{ pkgs, ... }: with pkgs; let
  offlinemsmtp = callPackage ../pkgs/offlinemsmtp.nix {};
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
          --send-mail-file /home/sumner/tmp/offlinemsmtp-sendmail
      '';
      Restart = "always";
      RestartSec = 5;
    };

    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };
}
