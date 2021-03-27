{ config, ... }: {
  imports = [
    ./audio-control-scripts.nix
  ];

  xorg.enable = true;
  xorg.remapEscToCaps = false;
  networking.interfaces = [ "enp37s0" "wlp35s0" ];
  programs.i3status-rust.extraBlocks = [
    {
      block = "custom";
      command = ''[[ $(${config.home.homeDirectory}/bin/current-audio-device) =~ 'PCM2704 16-bit stereo audio DAC' ]] && echo  ||  echo  '';
      on_click = "${config.home.homeDirectory}/bin/toggle-audio";
      interval = 5;
      priority = 89;
    }
  ];
}
