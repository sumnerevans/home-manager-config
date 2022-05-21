{ pkgs, ... }: {
  programs.neovim = {
    extraPackages = with pkgs; [
      gopls
      kotlin-language-server
    ];

    coc = {
      enable = true;

      package = pkgs.vimUtils.buildVimPluginFrom2Nix {
        pname = "coc.nvim";
        version = "2022-05-21";
        src = pkgs.fetchFromGitHub {
          owner = "neoclide";
          repo = "coc.nvim";
          rev = "791c9f673b882768486450e73d8bda10e391401d";
          sha256 = "sha256-MobgwhFQ1Ld7pFknsurSFAsN5v+vGbEFojTAYD/kI9c=";
        };
        meta.homepage = "https://github.com/neoclide/coc.nvim/";
      };

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
        "explorer.position" = "right";

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
    };
  };
}
