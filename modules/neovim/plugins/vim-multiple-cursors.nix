# Multiple cursor support
{ pkgs, ... }: with pkgs;{
  programs.neovim = {
    plugins = [
      {
        plugin = vimPlugins.vim-multiple-cursors;
        # config = ''
        #   func! Multiple_cursors_before()
        #     if deoplete#is_enabled()
        #       call deoplete#disable()
        #       let g:deoplete_is_enable_before_multi_cursors = 1
        #     else
        #       let g:deoplete_is_enable_before_multi_cursors = 0
        #     endif
        #   endfunc
        #   func! Multiple_cursors_after()
        #     if g:deoplete_is_enable_before_multi_cursors
        #       call deoplete#enable()
        #     endif
        #   endfunc
        # '';
      }
    ];
  };
}
