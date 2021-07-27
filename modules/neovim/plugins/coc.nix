{ pkgs, ... }: {
  programs.neovim = {
    plugins = with pkgs.vimPlugins; [
      {
        plugin = coc-nvim;
        config = ''
          " CoC Extensions
          let g:coc_global_extensions=[
              \ 'coc-clangd',
              \ 'coc-css',
              \ 'coc-dictionary',
              \ 'coc-docker',
              \ 'coc-elixir',
              \ 'coc-eslint',
              \ 'coc-explorer',
              \ 'coc-go',
              \ 'coc-html',
              \ 'coc-java',
              \ 'coc-json',
              \ 'coc-lists',
              \ 'coc-marketplace',
              \ 'coc-omnisharp',
              \ 'coc-pyright',
              \ 'coc-sh',
              \ 'coc-texlab',
              \ 'coc-tsserver',
              \ 'coc-word',
              \ 'coc-yaml',
              \ ]

          set updatetime=300
          set shortmess+=c

          " Use tab for trigger completion with characters ahead and navigate.
          inoremap <silent><expr> <TAB>
                \ pumvisible() ? "\<C-n>" :
                \ <SID>check_back_space() ? "\<TAB>" :
                \ coc#refresh()
          inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

          function! s:check_back_space() abort
            let col = col('.') - 1
            return !col || getline('.')[col - 1]  =~# '\s'
          endfunction

          " Remap keys for gotos
          nmap <silent> gd <Plug>(coc-definition)
          nmap <silent> gy <Plug>(coc-type-definition)
          nmap <silent> gi <Plug>(coc-implementation)
          nmap <silent> gr <Plug>(coc-references)

          " Formatting
          vmap <C-F> <Plug>(coc-format-selected)
          xmap <C-F> :call CocAction('format')<CR>
          nmap <C-F> :call CocAction('format')<CR>

          " Hover and rename
          nmap <silent> <F6> <Plug>(coc-rename)
          nnoremap <silent> K :call CocAction('doHover')<CR>

          " Go to symbol in (document|project)
          nmap <silent> S :CocList symbols<CR>

          " CoC Explorer
          function! CocExploreCwd()
              let cwd = substitute(execute(":pwd"), '\n', "", "")
              exe 'CocCommand explorer ' . cwd
          endfunction
          map <S-T> :call CocExploreCwd()<CR>
        '';
      }
    ];
  };
}
