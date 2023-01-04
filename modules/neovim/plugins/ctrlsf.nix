# Sublime Text-like search
{ pkgs, ... }:
let
  ctrlsf = pkgs.vimUtils.buildVimPluginFrom2Nix rec {
    pname = "ctrlsf";
    version = "2.1.2";
    src = pkgs.fetchFromGitHub {
      owner = "dyng";
      repo = "ctrlsf.vim";
      rev = "v${version}";
      sha256 = "sha256-h1/cbhdB8usyaPoV+P32+2Iml6x/iEbpKCWe3tqEgLI=";
    };
    meta.homepage = "https://github.com/dyng/ctrlsf.vim";
  };
in
{
  programs.neovim.plugins = [
    {
      plugin = ctrlsf;
      config = ''
        nmap <C-S> <Plug>CtrlSFPrompt
        vmap <C-S> <Plug>CtrlSFVwordPath
        let g:ctrlsf_ackprg = 'rg'
        let g:ctrlsf_auto_focus = { "at": "start" }
        let g:ctrlsf_default_root = 'cwd'
        let g:ctrlsf_mapping = {
            \ "next": "n",
            \ "prev": "N",
            \ }
        let g:ctrlsf_position = 'bottom'
        let g:ctrlsf_winsize = '70%'
      '';
    }
  ];
}
