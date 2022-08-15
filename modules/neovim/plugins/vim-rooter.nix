# Always change the CWD to the project root.
{ lib, pkgs, ... }: with lib; with pkgs; let
  rooter_patterns = [ ".rooter_root" ".git" ];
in
{
  programs.neovim.plugins = [
    {
      plugin = vimPlugins.vim-rooter;
      config = ''
        let g:rooter_patterns = [${concatMapStringsSep ", " (p: "'${p}'") rooter_patterns}]
      '';
    }
  ];
}
