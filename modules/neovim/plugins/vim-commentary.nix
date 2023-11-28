{ pkgs, ... }: {
  programs.neovim.plugins = [{
    plugin = pkgs.vimPlugins.vim-commentary;
    config = ''
      noremap <F8> :Commentary<CR>
    '';
  }];
}
