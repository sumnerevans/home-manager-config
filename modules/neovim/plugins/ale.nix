{ lib, pkgs, ... }: with lib;
let
  aleFixers = {
    c = [ [ "clang-format" pkgs.clang ] ];
    cpp = [ [ "clang-format" pkgs.clang ] ];
    go = [ [ "gofmt" pkgs.go ] [ "goimports" pkgs.goimports ] ];
    nix = [ [ "nixpkgs-fmt" pkgs.nixpkgs-fmt ] ];
    python = [ [ "black" pkgs.black ] ];
    rust = [ [ "rustfmt" pkgs.rustfmt ] ];
  };
  aleLinters = {
    python = [
      [ "pyls" pkgs.python-language-server ]
    ];
  };
  mapListForLang = lang: l: "'${lang}': [${concatMapStringsSep ", " (f: "'${elemAt f 0}'") l}]";
in
{
  programs.neovim = {
    extraPackages =
      flatten (mapAttrsToList (l: fixers: map (f: elemAt f 1) fixers) aleFixers)
      ++ flatten (mapAttrsToList (l: linters: map (f: elemAt f 1) linters) aleLinters);

    plugins = [{
      plugin = pkgs.vimPlugins.ale;
      config = ''
        let g:ale_open_list = 1                 " Auto open the error list
        let g:ale_set_loclist = 0               " Limit the size of the ALE output to 5 lines
        let g:ale_set_quickfix = 1              " Limit the size of the ALE output to 5 lines
        let g:ale_list_window_size = 5          " Limit the size of the ALE output to 5 lines

        " Completion
        let g:ale_completion_enabled = 1        " Enable completion
        set completeopt=menu,menuone,preview,noselect,noinsert

        let g:ale_sign_error = '✖'              " Consistent sign column with Language Client
        let g:ale_sign_warning = '⚠'
        let g:ale_sign_info = '➤'

        let g:ale_fixers = {${concatStringsSep ", " (mapAttrsToList mapListForLang aleFixers)}}
        let g:ale_linters = {${concatStringsSep ", " (mapAttrsToList mapListForLang aleLinters)}}

        " Remap for format (selected region|document)
        xmap <C-S-F> <Plug>(ale_fix)
        nmap <C-S-F> <Plug>(ale_fix)

        " Remap keys for gotos
        nmap <silent> gd <Plug>(ale_go_to_definition)
        nmap <silent> gy <Plug>(ale_go_to_type_definition)
        nmap <silent> gr <Plug>(ale_find_references)

        " Hover and rename
        " TODO figure out how to make this work

        " Get fancy symbols for all of the different completion types.
        let g:ale_completion_symbols = {
          \ 'text': ' ',
          \ 'method': ' ',
          \ 'function': ' ',
          \ 'constructor': ' ',
          \ 'field': ' ',
          \ 'variable': ' ',
          \ 'class': ' ',
          \ 'interface': ' ',
          \ 'module': ' ',
          \ 'property': ' ',
          \ 'unit': 'unit ',
          \ 'value': 'val ',
          \ 'enum': ' ',
          \ 'keyword': 'keyword ',
          \ 'snippet': ' ',
          \ 'color': 'color ',
          \ 'file': ' ',
          \ 'reference': 'ref ',
          \ 'folder': ' ',
          \ 'enum member': ' ',
          \ 'constant': ' ',
          \ 'struct': ' ',
          \ 'event': 'event ',
          \ 'operator': ' ',
          \ 'type_parameter': 'type param ',
          \ '<default>': 'v '
          \ }
      '';
    }];
  };
}
