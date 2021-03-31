{ pkgs, ... }: {
  programs.neovim.plugins = [
    {
      plugin = pkgs.vimPlugins.vim-markdown-composer;
      config = ''
        let g:markdown_composer_autostart = 0
      '';
    }
  ];
}
