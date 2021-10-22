{ lib, fetchurl, appimageTools }:
let
  buildNum = "211021a4pp9tq02";
in
appimageTools.wrapType2 rec {
  name = "beeper";

  src = fetchurl {
    url = "https://dl.todesktop.com/201202u1n7yn5b0/builds/${buildNum}/linux/appimage/x64";
    sha256 = "sha256-2rii+zbXYoeOZZ8EVyU/g7jusVOcRrvHqsaCVDNprhE=";
  };

  extraInstallCommands =
    let
      appimageContents = appimageTools.extractType2 { inherit name src; };
    in
    ''
      install -Dm444 ${appimageContents}/beeper-beta.desktop -t $out/share/applications
      substituteInPlace $out/share/applications/beeper-beta.desktop \
        --replace 'Exec=AppRun' 'Exec=${name}'
      install -m 444 -D ${appimageContents}/usr/share/icons/hicolor/1024x1024/apps/beeper-beta.png \
        $out/share/icons/hicolor/1024x1024/apps/beeper-beta.png
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
