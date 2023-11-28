{ lib, ... }: {
  programs.foot = {
    enable = true;
    server.enable = true;
    settings = {
      scrollback = { lines = 100000; };

      url = {
        launch = "xdg-open \${url}";
        label-letters = "sadfjklewcmpgh";
        osc8-underline = "url-mode";
        protocols = "http, https, ftp, ftps, file, gemini, gopher";
        uri-characters = ''
          abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-_.,~:;/?#@!$&%*+="'()[]'';
      };

      key-bindings = { show-urls-launch = "Control+Shift+K"; };

      # Colors (One Dark)
      # https://github.com/eendroroy/alacritty-theme/blob/master/themes/one_dark.yaml
      colors = {
        # Default colors
        background = "1e2127";
        foreground = "abb2bf";

        # Normal colors
        regular0 = "1e2127";
        regular1 = "e06c75";
        regular2 = "98c379";
        regular3 = "d19a66";
        regular4 = "3e82d6";
        regular5 = "c678dd";
        regular6 = "56b6c2";
        regular7 = "abb2bf";

        # Bright colors
        bright0 = "5c6370";
        bright1 = "e06c75";
        bright2 = "98c379";
        bright3 = "d19a66";
        bright4 = "61afef";
        bright5 = "c678dd";
        bright6 = "56b6c2";
        bright7 = "ffffff";
      };
    };
  };
}
