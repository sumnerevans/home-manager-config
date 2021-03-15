{ ... }: {
  xorg.enable = true;
  xorg.remapEscToCaps = false;
  networking.interfaces = [ "enp37s0" "wlp35s0" ];
  programs.i3status-rust.extraBlocks = [
    {
      block = "custom";
      command = ''[[ "$(~/bin/current_audio_device)" =~ "PCM2704 16-bit stereo audio DAC" ]] && echo  ||  echo  '';
      on_click = "~/bin/toggle_audio";
      interval = 5;
      priority = 89;
    }
  ];
}
