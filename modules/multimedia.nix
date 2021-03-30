{ pkgs, ... }: with pkgs; let
  sublime-music = callPackage ../pkgs/sublime-music.nix {
    chromecastSupport = true;
    serverSupport = true;
  };
in
{
  home.packages = [
    # Shell Utilities
    ffmpeg-full
    pavucontrol
    playerctl
    youtube-dl

    # Multimedia
    fbida
    gimp
    guvcview
    imagemagick
    inkscape
    kdenlive
    libreoffice-fresh
    spotify
    steam
    streamlink
    sublime-music
  ];

  programs.feh.enable = true;

  programs.mpv.enable = true;
  programs.mpv.config = {
    force-window = "yes";
    gpu-context = "wayland";
    hwdec = "auto-safe";
    profile = "gpu-hq";
    vo = "gpu";
    ytdl-format = "bestvideo+bestaudio";
  };

  programs.obs-studio.enable = true;
  programs.obs-studio.plugins = with pkgs; [ obs-wlrobs obs-v4l2sink ];

  programs.zathura.enable = true;
}
