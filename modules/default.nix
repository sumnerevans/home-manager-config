{ pkgs, ... }:
let
  editor = "nvim";
in
{
  imports = [
    ./alacritty.nix
    ./browsers.nix
    ./calendar
    ./communication.nix
    ./devtools.nix
    ./email
    ./foot.nix
    ./fzf.nix
    ./git.nix
    ./gpg.nix
    ./multimedia.nix
    ./neovim
    ./nix.nix
    ./newsboat.nix
    ./scripts
    ./ssh.nix
    ./symlinks.nix
    ./syncthing.nix
    ./tmux.nix
    ./tracktime.nix
    ./ttchat.nix
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
