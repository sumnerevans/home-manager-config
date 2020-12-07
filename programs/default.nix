{ pkgs, ... }: {
  imports = [
    ./alacritty.nix
    # TODO firefox
    ./git.nix
    ./i3status-rust.nix
  ];

  programs.bat.enable = true;

  programs.chromium.enable = true;

  programs.direnv = {
    enable = true;
    enableNixDirenvIntegration = true;
    enableZshIntegration = true;
  };

  programs.feh.enable = true;

  programs.fzf = { enable = true; enableZshIntegration = true; };

  programs.gpg.enable = true;

  programs.home-manager.enable = true;

  programs.htop.enable = true;

  programs.jq.enable = true;

  # TODO mako

  # TODO: mbsync

  programs.mpv.enable = true;

  # TODO offlinemsmtp

  # TODO neomutt

  # TODO neovim

  programs.noti.enable = true;

  programs.obs-studio.enable = true;
  programs.obs-studio.plugins = with pkgs; [ obs-wlrobs obs-v4l2sink ];

  # TODO offlineimap

  programs.opam = { enable = true; enableZshIntegration = true; };
  home.packages = with pkgs.ocamlPackages; [ utop ];

  programs.password-store.enable = true;

  # TODO qutebrowser

  # TODO rofi

  # TODO ssh

  # TODO texlive
  # programs.texlive.enable = true;

  # TODO: tmux

  programs.vscode.enable = true;

  programs.zathura.enable = true;

  # TODO zsh
}
