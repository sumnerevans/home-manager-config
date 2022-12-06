{ pkgs, ... }: with pkgs; {
  programs.neovim.plugins = [
    {
      plugin = vimPlugins.vim-localvimrc;
      config = ''
        let g:localvimrc_persistent = 2

        let g:localvimrc_persistence_file = "/home/sumner/.config/nvim/localvimrc_persistent"
      '';
    }
  ];
}
