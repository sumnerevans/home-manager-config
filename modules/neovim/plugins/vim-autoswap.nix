# Swap to the already opened file
{ lib, pkgs, ... }: with pkgs; {
  programs.neovim = {
    extraPackages = [ wmctrl ];
    plugins = [
      {
        plugin = vimPlugins.vim-autoswap;
        config = "let g:autoswap_detect_tmux = 1";
      }
    ];
  };
}
