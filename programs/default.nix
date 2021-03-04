{ pkgs, ... }: with pkgs; let
  offlinemsmtp = callPackage ../pkgs/offlinemsmtp.nix {};
  sublime-music = callPackage ../pkgs/sublime-music.nix {};
in
{
  imports = [
    ./alacritty.nix
    ./git.nix
    ./i3status-rust.nix
    ./newsboat.nix
  ];

  home.packages = [
    delta
    gimp
    gnome3.gnome-power-manager
    gnome3.networkmanagerapplet
    fbida
    ocamlPackages.utop
    offlinemsmtp
    sqlitebrowser
    streamlink
    youtube-dl

    (
      sublime-music.override {
        chromecastSupport = true;
        serverSupport = true;
      }
    )
  ];

  programs.bat.enable = true;

  programs.chromium.enable = true;

  programs.direnv = {
    enable = true;
    enableNixDirenvIntegration = true;
    enableZshIntegration = true;
  };

  programs.feh.enable = true;

  # TODO firefox

  programs.fzf = { enable = true; enableZshIntegration = true; };

  programs.gpg.enable = true;

  programs.home-manager.enable = true;

  programs.htop.enable = true;

  programs.jq.enable = true;

  # TODO mako

  programs.mpv.enable = true;
  programs.mpv.config = {
    force-window = "yes";
    gpu-context = "wayland";
    hwdec = "auto-safe";
    profile = "gpu-hq";
    vo = "gpu";
    ytdl-format = "bestvideo+bestaudio";
  };

  # TODO neomutt

  # TODO neovim

  programs.noti.enable = true;

  programs.obs-studio.enable = true;
  programs.obs-studio.plugins = with pkgs; [ obs-wlrobs obs-v4l2sink ];

  # TODO offlineimap

  programs.opam = { enable = true; enableZshIntegration = true; };

  programs.password-store.enable = true;

  # TODO qutebrowser

  # TODO rofi

  # TODO ssh

  # TODO: tmux

  programs.vscode.enable = true;

  programs.zathura.enable = true;

  # TODO zsh
}
