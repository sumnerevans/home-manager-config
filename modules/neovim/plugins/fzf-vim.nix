# Fuzzy finder with preview window
{ pkgs, ... }: with pkgs;{
  programs.neovim = {
    extraPackages = [ fzf ];
    plugins = [
      {
        plugin = vimPlugins.fzf-vim;
        config = ''
          nnoremap <C-p> :Files<CR>
          let g:fzf_preview_window = 'right:60%'
        '';
      }
    ];
  };
}
