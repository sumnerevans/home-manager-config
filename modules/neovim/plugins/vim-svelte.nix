{ config, pkgs, ... }: {
  programs.neovim = {
    plugins = with pkgs.vimPlugins; [
      {
        plugin = vim-svelte;
        config = ''
          let g:svelte_preprocessors = ['typescript']
        '';
      }
    ];
  };
}
