{ pkgs, ... }:
let
  editor = "${pkgs.neovim}/bin/nvim";
in
{
  imports = [
    ./alacritty.nix
    ./browsers.nix
    ./calendar
    ./communication.nix
    ./devtools.nix
    ./email
    ./fzf.nix
    ./git.nix
    ./gpg.nix
    ./multimedia.nix
    ./neovim
    ./newsboat.nix
    ./scripts
    ./ssh.nix
    ./symlinks.nix
    ./syncthing.nix
    ./tmux.nix
    ./tracktime.nix
    ./udiskie.nix
    ./window-manager
    ./xdg.nix
    ./yubikey.nix
    ./zsh
  ];

  home.sessionVariables = {
    COLORTERM = "truecolor";
    VISUAL = "${editor}";
    EDITOR = "${editor}";
  };
}
