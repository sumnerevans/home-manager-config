{ config, pkgs, ... }: {
  imports = [
    ./audio-control-scripts.nix
  ];

  home.sessionVariables.WLR_NO_HARDWARE_CURSORS = "1";

  wayland.enable = true;
  wayland.windowManager.sway.extraOptions = [ "--unsupported-gpu" ];
  networking.interfaces = [ "enp37s0" "wlp35s0" ];

  mdf.port = 1024;

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
