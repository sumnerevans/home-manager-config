# Autocompletion
{ pkgs, ... }: with pkgs; {
  programs.neovim.plugins = [
    {
      plugin = vimPlugins.deoplete-nvim;
      config = ''
        let g:deoplete#enable_at_startup = 1

        autocmd BufNewFile,BufRead call deoplete#custom#option('sources', {'_':['ale', 'buffer','file']})
      '';
    }
  ];
}
