{ pkgs, ... }: {
  programs.neovim.plugins = [
    {
      plugin = pkgs.vimPlugins.ale;
      config = ''
        let g:ale_disable_lsp = 1

        let g:ale_open_list = 1                 " Auto open the error list
        let g:ale_completion_enabled = 1        " Enable completion
        let g:ale_set_loclist = 0               " Limit the size of the ALE output to 5 lines
        let g:ale_set_quickfix = 1              " Limit the size of the ALE output to 5 lines
        let g:ale_list_window_size = 5          " Limit the size of the ALE output to 5 lines

        let g:ale_sign_error = '✖'              " Consistent sign column with Language Client
        let g:ale_sign_warning = '⚠'
        let g:ale_sign_info = '➤'
      '';
    }
  ];
}
