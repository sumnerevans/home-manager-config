{ ... }: {
  programs.alacritty = {
    enable = true;
    settings = {
      window.title = "Terminal";
      font.size = 11.5;

      # Colors (One Dark)
      # https://github.com/eendroroy/alacritty-theme/blob/master/themes/one_dark.yaml
      colors = {
        # Default colors
        primary = {
          background = "0x1e2127";
          foreground = "0xabb2bf";
        };

        # Normal colors
        normal = {
          black = "0x1e2127";
          red = "0xe06c75";
          green = "0x98c379";
          yellow = "0xd19a66";
          blue = "0x3e82d6";
          magenta = "0xc678dd";
          cyan = "0x56b6c2";
          white = "0xabb2bf";
        };

        # Bright colors
        bright = {
          black = "0x5c6370";
          red = "0xe06c75";
          green = "0x98c379";
          yellow = "0xd19a66";
          blue = "0x61afef";
          magenta = "0xc678dd";
          cyan = "0x56b6c2";
          white = "0xffffff";
        };
      };
    };
  };
}
