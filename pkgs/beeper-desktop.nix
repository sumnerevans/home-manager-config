{ lib, fetchurl, appimageTools }:
appimageTools.wrapType2 rec {
  name = "beeper-beta";
  version = "unstable-2022-03-11";

  src = fetchurl {
    url = "https://dl.todesktop.com/201202u1n7yn5b0/builds/220311nrmv5jqba/linux/appimage/x64";
    sha256 = "sha256-6/6ouK82Hm+oUWUdWSeylciFMMHhQCS327gnKSD8oj0=";
  };

  extraInstallCommands =
    let
      appimageContents = appimageTools.extractType2 { inherit name src; };
      installIcon = size: ''
        install -m 444 -D ${appimageContents}/usr/share/icons/hicolor/${size}x${size}/apps/${name}.png \
          $out/share/icons/hicolor/${size}x${size}/apps/${name}.png
      '';
    in
    ''
      install -Dm444 ${appimageContents}/${name}.desktop -t $out/share/applications
      substituteInPlace $out/share/applications/${name}.desktop \
        --replace 'Exec=AppRun --no-sandbox' 'Exec=${name}'
      ${lib.concatMapStringsSep "\n" installIcon (map toString [16 32 48 64 128 256 512 1024 ])}
    '';

  meta = with lib; {
    homepage = "https://www.beeper.com/";
    description = "Unified chat app";
    longDescription = ''
      A single app to chat on iMessage, WhatsApp, and 13 other networks. You
      can search, prioritize, and mute messages. And with a unified inbox,
      you'll never miss a message again.
    '';
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ sumnerevans ];
  };
}
