{ ... }: {
  xorg.enable = true;
  laptop.enable = true;
  networking.interfaces = [ "enp0s31f6" "wlp4s0" ];
}
