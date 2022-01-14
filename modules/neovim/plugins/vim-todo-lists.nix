{ pkgs, ... }:
let
  vim-todo-lists = pkgs.vimUtils.buildVimPluginFrom2Nix rec {
    pname = "vim-todo-lists";
    version = "0.8.0";
    src = pkgs.fetchFromGitHub {
      owner = "aserebryakov";
      repo = "vim-todo-lists";
      rev = version;
      sha256 = "sha256-iIWQrYq81o1aR021lLRisTr7BykrQo4pg3/8wdnddBg=";
    };
    meta.homepage = "https://github.com/aserebryakov/vim-todo-lists";
  };
in
{
  programs.neovim.plugins = [
    { plugin = vim-todo-lists; }
  ];
}
