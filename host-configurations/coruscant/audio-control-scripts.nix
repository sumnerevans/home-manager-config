{ config, pkgs, runtimeShell, ... }: let
  grep = "${pkgs.gnugrep}/bin/grep";
  pacmd = "${pkgs.pulseaudio}/bin/pacmd";
  pactl = "${pkgs.pulseaudio}/bin/pactl";
  sed = "${pkgs.gnused}/bin/sed";
  mkBashScript = scriptText: {
    executable = true;
    text = ''
      #!${pkgs.bash}/bin/bash
      ${scriptText}
    '';
  };
  binDir = "${config.home.homeDirectory}/bin";

  switchToHeadphones = ''
    ${pactl} set-default-sink alsa_output.pci-0000_29_00.3.analog-stereo
  '';

  switchToSpeakers = ''
    ${pactl} set-default-sink alsa_output.usb-Audioengine_Audioengine_2_-00.analog-stereo
  '';
in
{
  home.packages = with pkgs; [
    # Add the pulseaudio package here so that pactl works.
    # TODO eventually, I should move off of pactl
    pulseaudio
  ];

  home.file."bin/current-audio-device" = mkBashScript ''
    ${pactl} info | ${grep} 'Default Sink' | ${pkgs.coreutils}/bin/cut -d ':' -f 2
  '';

  home.file."bin/toggle-audio" = mkBashScript ''
    # If it's on the headphones, toggle to speakers. Otherwise, toggle to the
    # headphones by default.
    if [[ $(${binDir}/current-audio-device) =~ "alsa_output.pci-0000_29_00.3.analog-stereo" ]]; then
      ${switchToSpeakers}
    else
      ${switchToHeadphones}
    fi
  '';

  home.file."bin/headphones" = mkBashScript switchToHeadphones;
  home.file."bin/speakers" = mkBashScript switchToSpeakers;
}
