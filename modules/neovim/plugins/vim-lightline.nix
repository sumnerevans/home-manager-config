{ pkgs, ... }: {
  programs.neovim.plugins = with pkgs.vimPlugins; [
    {
      plugin = lightline-vim;
      config = ''
        let g:lightline = {
          \   'active': {
          \     'left': [
          \         [ 'mode', 'paste' ],
          \         [ 'readonly', 'filename', 'modified' ],
          \         [ 'coc_info', 'coc_hints', 'coc_errors', 'coc_warnings', 'coc_ok' ],
          \         [ 'coc_status' ]
          \     ]
          \   },
          \   'tabline': {
          \     'left': [ ['buffers'] ]
          \   },
          \   'component_expand': {
          \     'buffers': 'lightline#bufferline#buffers'
          \   },
          \   'component_type': {
          \     'buffers': 'tabsel'
          \   }
          \ }

        let g:lightline.colorscheme = 'one'
      '';
    }
    {
      plugin = vim-lightline-coc;
      config = ''
        call lightline#coc#register()
      '';
    }
    {
      plugin = lightline-bufferline;
      config = ''
        let g:lightline#bufferline#clickable = 1
        let g:lightline.component_raw = {'buffers': 1}
      '';
    }
  ];
}
