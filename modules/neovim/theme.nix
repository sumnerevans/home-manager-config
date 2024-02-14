{ pkgs, lib, ... }:
with lib; {
  programs.neovim = {
    plugins = with pkgs.vimPlugins; [ vim-devicons nightfox-nvim ];

    extraConfig = ''
      if ($TERM == 'alacritty' || $TERM == 'tmux-256color' || $TERM == 'xterm-256color' || $TERM == 'screen-256color') && !has('gui_running')
          set termguicolors
      endif

      colorscheme carbonfox
      set background=dark
    '';
  };
}
