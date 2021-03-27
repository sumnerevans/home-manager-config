{ pkgs, ... }: let
  writepingScript = pkgs.writeShellScript "writeping" ''
    ${pkgs.coreutils}/bin/touch ~/tmp/rolling_ping

    # Append the new ping time.
    ping=$(/run/wrappers/bin/ping -c 1 -W 1 8.8.8.8)
    if [[ $? != 0 ]]; then
        echo "fail" > ~/tmp/rolling_ping
    else
        ${pkgs.coreutils}/bin/cat ~/tmp/rolling_ping | ${pkgs.gnugrep}/bin/grep "fail"
        [[ $? == 0 ]] && rm ~/tmp/rolling_ping
        ping=$(echo $ping | \
          ${pkgs.gnugrep}/bin/grep 'rtt' | \
          ${pkgs.coreutils}/bin/cut -d '/' -f 5)
        echo $ping >> ~/tmp/rolling_ping
    fi

    # Only keep the last 10 values.
    echo "$(${pkgs.coreutils}/bin/tail ~/tmp/rolling_ping)" > ~/tmp/rolling_ping
  '';
in
{
  systemd.user.services.writeping = {
    Unit.Description = "Write the new ping value for rolling ping average calculation";

    Service = {
      Type = "oneshot";
      ExecStart = "${writepingScript}";
    };
  };

  systemd.user.timers.writeping = {
    Unit.Description = "Write the new ping value for rolling ping average calculation";

    Timer = {
      OnCalendar = "*:*:0/10"; # Every 10 seconds
      Unit = "writeping.service";
    };

    Install.WantedBy = [ "timers.target" ];
  };
}
