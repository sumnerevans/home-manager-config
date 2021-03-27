{ config, pkgs, runtimeShell, ... }: let
  grep = "${pkgs.gnugrep}/bin/grep";
  pacmd = "${pkgs.pulseaudio}/bin/pacmd";
  sed = "${pkgs.gnused}/bin/sed";
  mkBashScript = scriptText: {
    executable = true;
    text = ''
      #!${pkgs.bash}/bin/bash
      ${scriptText}
    '';
  };
  binDir = "${config.home.homeDirectory}/bin";
in
{
  home.file."bin/change-audio-sink" = mkBashScript ''
    device_description=$1

    if [[ $device_description == "" ]]; then
        echo "Usage: ./change-audio-sink 'DESCRIPTION OF SINK'"
        exit 1
    fi

    # Find the index of the device with the given description.
    sinks="$(${pacmd} list-sinks | ${grep} -e 'index:' -e 'device.description')"
    i=0
    dev_index=0
    activate=0
    while IFS= read -r line; do
        if [ $(( $i % 2 )) -eq 0 ]; then
            dev_index="$(echo "$line" | ${sed} -n 's/^.*index: \(.*\)$/\1/p')"
        else
            description="$(echo "$line" | ${sed} -n 's/^.*device.description = "\(.*\)"$/\1/p')"

            if [[ $description =~ $device_description ]]; then
                break
            fi
        fi
        i=$(($i + 1))
    done <<< "$sinks"

    echo "Switching default sink to: $dev_index"
    ${pacmd} set-default-sink $dev_index

    sink_inputs="$(${pacmd} list-sink-inputs | ${grep} -e 'index:')"
    while IFS= read -r line; do
        input_id="$(echo "$line" | ${sed} -n 's/^.*index: \(.*\)$/\1/p')"
        echo "Switching input $input_id to $dev_index"
        ${pacmd} move-sink-input $input_id $dev_index
    done <<< "$sink_inputs"

    exit 2
  '';

  home.file."bin/current-audio-device" = mkBashScript ''
    # Find the description of the active audio sink.
    sinks="$(${pacmd} list-sinks | ${grep} -e 'index:' -e 'device.description')"
    i=0
    has_star=0
    activate=0
    while IFS= read -r line; do
        if [ $(( $i % 2 )) -eq 0 ]; then
            has_star="$(echo "$line" | ${sed} -n 's/^.*\(\*\) index: .*$/\1/p')"
        else
            description="$(echo "$line" | ${sed} -n 's/^.*device.description = "\(.*\)"$/\1/p')"

            if [[ $has_star == "*" ]]; then
                echo $description
                exit 0
            fi
        fi
        i=$(($i + 1))
    done <<< "$sinks"
  '';

  home.file."bin/toggle-audio" = mkBashScript ''
    # If it's on the headphones, toggle to speakers. Otherwise, toggle to the
    # headphones by default.
    if [[ $(${binDir}/current-audio-device) =~ "Family 17h (Models 00h-0fh)" ]]; then
        ${binDir}/change-audio-sink 'PCM2704 16-bit stereo audio'
    else
        ${binDir}/change-audio-sink 'Family 17h \(Models 00h-0fh\)'
    fi
  '';

  home.file."bin/headphones" = mkBashScript ''
    ${binDir}/change-audio-sink 'Family 17h \(Models 00h-0fh\)'
  '';

  home.file."bin/speakers" = mkBashScript ''
    ${binDir}/change-audio-sink 'PCM2704 16-bit stereo audio DAC'
  '';
}
