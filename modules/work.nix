{ config, lib, pkgs, ... }:
with lib;
let cfg = config.work;
in {
  options.work.enable = mkEnableOption "work mode";

  config = mkIf cfg.enable {
    # Automattic proxy
    systemd.user.services."autossh@" = {
      Unit.Description = "autossh";

      Service = let
        path = lib.makeBinPath (with pkgs; [ autossh openssh_hpn ]);
        PIDFile = "autossh-%i.pid";
      in {
        ExecSearchPath = path;
        Environment = [
          "AUTOSSH_POLL=60"
          "AUTOSSH_GATETIME=30"
          "SSH_AUTH_SOCK=%t/ssh-agent"
          "AUTOSSH_PIDFILE=%t/${PIDFile}"
        ];
        ExecStart = "autossh -M 0 -f -N %i";
        Type = "forking";
        inherit PIDFile;
      };
    };
  };
}
