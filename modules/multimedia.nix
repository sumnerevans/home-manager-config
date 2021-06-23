{ config, lib, pkgs, ... }: with lib; with pkgs; let
  sublime-music = callPackage ../pkgs/sublime-music.nix {
    chromecastSupport = true;
    serverSupport = true;
  };
  cfg = config.gaming;
in
{
  options.gaming.enable = mkEnableOption "gaming programs";

  config = {
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
      streamlink
      sublime-music
    ] ++ (
      optionals cfg.enable [
        steam
      ]
    );

    programs.feh.enable = true;

    programs.mpv.enable = true;
    programs.mpv.config = {
      force-window = "yes";
      hwdec = "auto-safe";
      profile = "gpu-hq";
      vo = "gpu";
      ytdl-format = "bestvideo+bestaudio";
    };

    programs.obs-studio.enable = true;
    programs.obs-studio.plugins = with pkgs; [
      obs-studio-plugins.wlrobs
      obs-v4l2sink
    ];

    programs.zathura.enable = true;
  };
}
