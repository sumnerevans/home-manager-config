{ pkgs, lib, ... }:
with lib; {
  programs.neovim = {
    plugins = with pkgs.vimPlugins; [ vim-devicons nightfox-nvim ];

    extraConfig = ''
      colorscheme carbonfox
      set background=dark
    '';
  };
}
