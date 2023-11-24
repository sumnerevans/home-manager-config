# Enable git blame on the line.
{ pkgs, ... }: with pkgs; let
  templ-vim = pkgs.vimUtils.buildVimPlugin rec {
    pname = "templ.nix";
    version = "unstable-2023-11-24";
    src = pkgs.fetchFromGitHub {
      owner = "joerdav";
      repo = "templ.vim";
      rev = "5cc48b93a4538adca0003c4bc27af844bb16ba24";
      sha256 = "sha256-YdV8ioQJ10/HEtKQy1lHB4Tg9GNKkB0ME8CV/+hlgYs=";
    };
    meta.homepage = "https://github.com/joerdav/templ.vim";
  };
in
{
  programs.neovim.plugins = [
    templ-vim
  ];
}
