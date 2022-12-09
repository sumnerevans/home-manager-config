# Multiple cursor support
{ pkgs, ... }: with pkgs;{
  programs.neovim = {
    plugins = [
      {
        plugin = vimPlugins.vim-visual-multi;
      }
    ];
  };
}
