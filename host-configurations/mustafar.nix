{ ... }: {
  wayland.enable = true;
  laptop.enable = true;
  networking.interfaces = [ "wlp0s20f3" ];
}
