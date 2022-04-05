{ config, pkgs, ... }: {
  imports = [
    ./audio-control-scripts.nix
  ];

  xorg.enable = true;
  xorg.remapEscToCaps = false;
  networking.interfaces = [ "enp37s0" "wlp35s0" ];
  programs.i3status-rust.extraBlocks = [
    {
      block = "custom";
      command = ''[[ $(${config.home.homeDirectory}/bin/current-audio-device) =~ 'alsa_output.usb-Audioengine_Audioengine_2_-00.analog-stereo' ]] && echo  ||  echo  '';
      on_click = "${config.home.homeDirectory}/bin/toggle-audio && kill -USR1 $(${pkgs.procps}/bin/pgrep i3status-rs)";
      interval = 3;
      priority = 89;
    }
  ];
}
