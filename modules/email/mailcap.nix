{ pkgs, ... }:
let
  feh = "${pkgs.feh}/bin/feh";
  libreoffice = "${pkgs.libreoffice}/bin/libreoffice";
  icalviewScript = pkgs.writeScript "icalview" (builtins.readFile ./icalview.py);
in
{
  xdg.configFile."neomutt/mailcap".text = ''
    # HTML
    text/html; ${pkgs.elinks}/bin/elinks -dump %s; copiousoutput;

    # PDF documents
    application/pdf; ${pkgs.zathura}/bin/zathura %s

    # Images
    image/jpg; ${feh} %s
    image/jpeg; ${feh} %s
    image/pjpeg; ${feh} %s
    image/png; ${feh} %s
    image/gif; ${feh} %s

    # iCal
    text/calendar; ${icalviewScript}; copiousoutput
    application/calendar; ${icalviewScript}; copiousoutput
    application/ics; ${icalviewScript}; copiousoutput

    # Office Suites
    application/msword; ${libreoffice} %s;
    application/vnd.ms-word.document.12; ${libreoffice} %s;
    application/vnd.openxmlformats-officedocument.wordprocessingml.document; ${libreoffice} %s;
    application/vnd.oasis.opendocument.text; ${libreoffice} %s;

    # Microsoft LookOut
    application/ms-tnef; ${pkgs.tnef}/bin/tnef -w -C /home/sumner/tmp %s;
  '';
}
