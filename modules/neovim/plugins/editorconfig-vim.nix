# Enable .editorconfig support.
{ pkgs, ... }: with pkgs;{
  programs.neovim.plugins = [
    {
      plugin = vimPlugins.editorconfig-vim;
      config = ''
        let g:EditorConfig_preserve_formatoptions = 1
        let g:EditorConfig_exclude_patterns = ['fugitive://.*', 'scp://.*']
      '';
    }
  ];
}
