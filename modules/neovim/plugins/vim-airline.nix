# Cool status bar
{ pkgs, ... }: with pkgs; {
  programs.neovim.plugins = [
    {
      plugin = vimPlugins.vim-airline;
      config = ''
        let g:airline_powerline_fonts = 1                       " Enable fancy chars
        let g:airline#extensions#coc#enabled = 1                " Code competion/linting
        let g:airline#extensions#fugitiveline#enabled = 1       " Git branch, etc
        let g:airline#extensions#tabline#enabled = 1            " Show the tabline
        let g:airline#extensions#tabline#show_tabs = 0          " Don't show tabs, just buffers
      '';
    }
    {
      plugin = vimPlugins.vim-airline-themes;
      config = "let g:airline_theme='one'";
    }
  ];
}
