{ ... }: {
  xorg.enable = true;
  laptop.enable = true;
  networking.interfaces = [ "enp0s31f6" "wlp4s0" ];
  programs.i3status-rust.extraBlocks = [
    {
      block = "battery";
      interval = 30;
      format = "{percentage}% {time}";
      device = "BAT1";
      priority = 111;
    }
  ];
}
