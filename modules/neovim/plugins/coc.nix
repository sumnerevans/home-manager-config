{ pkgs, ... }: {
  programs.neovim = {
    extraPackages = with pkgs; [
      gopls
      kotlin-language-server
    ];

    coc = {
      enable = true;

      settings = {
        "coc.preferences.rootPatterns" = [ ".rooter_root" ".git" ".hg" ".projections.json" ];
        "explorer.keyMappings.global" = {
          "<cr>" = [
            "expandable?"
            [ "expanded?" "collapse" "expand" ]
            "open"
          ];
        };

        "explorer.file.showHiddenFiles" = true;
        "explorer.file.reveal.auto" = true;
        "explorer.git.icon.status.added" = "✚";
        "explorer.git.icon.status.copied" = "➜";
        "explorer.git.icon.status.deleted" = "✖";
        "explorer.git.icon.status.ignored" = "☒";
        "explorer.git.icon.status.mixed" = "✹";
        "explorer.git.icon.status.modified" = "✹";
        "explorer.git.icon.status.renamed" = "➜";
        "explorer.git.icon.status.unmerged" = "═";
        "explorer.git.icon.status.untracked" = "?";
        "explorer.git.showIgnored" = true;
        "explorer.icon.enableNerdfont" = true;

        "suggest.noselect" = true;

        "languageserver" = {
          "nix" = {
            "command" = "rnix-lsp";
            "filetypes" = [ "nix" ];
          };
          "racket" = {
            "command" = "racket";
            "args" = [ "--lib" "racket-langserver" ];
            "filetypes" = [ "racket" ];
          };
          "terraform" = {
            "command" = "terraform-lsp";
            "filetypes" = [ "terraform" ];
            "initializationOptions" = { };
          };
          "vala" = {
            "command" = "vala-language-server";
            "filetypes" = [ "vala" "genie" ];
          };
        };
      };

      pluginConfig = ''
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
            \ 'coc-java-debug',
            \ 'coc-json',
            \ 'coc-kotlin',
            \ 'coc-lists',
            \ 'coc-marketplace',
            \ 'coc-omnisharp',
            \ 'coc-prettier',
            \ 'coc-pyright',
            \ 'coc-rust-analyzer',
            \ 'coc-sh',
            \ 'coc-svelte',
            \ 'coc-texlab',
            \ 'coc-toml',
            \ 'coc-tsserver',
            \ 'coc-word',
            \ 'coc-xml',
            \ 'coc-yaml',
            \ ]

        set updatetime=300
        set shortmess+=c

        " Use tab for trigger completion with characters ahead and navigate.
        inoremap <silent><expr> <TAB>
          \ coc#pum#visible() ? coc#pum#next(1) :
          \ CheckBackspace() ? "\<Tab>" :
          \ coc#refresh()
        inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

        function! CheckBackspace() abort
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

        " Open the diagnostics when diagnostics change
        autocmd BufWritePost * call timer_start(500, { tid -> execute('execute "CocDiagnostics" | execute "botright lwindow" | execute "wincmd p"') })
      '';
    };
  };
}
