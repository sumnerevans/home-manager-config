{ pkgs, ... }: {
  programs.rofi = {
    enable = true;
    font = "pango:Iosevka 12";
    lines = 15;
    location = "top";
    terminal = "${pkgs.alacritty}/bin/alacritty";
    theme = "solarized_alternate";
    width = 25;
    yoffset = 80;
    extraConfig = {
      matching = "fuzzy";
    };
  };
  programs.rofi.pass.enable = true;
}
