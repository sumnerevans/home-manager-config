# Tab complete sanely
{ pkgs, ... }: with pkgs;{
  programs.neovim = {
    plugins = [
      {
        plugin = vimPlugins.supertab;
        config = ''
          let g:SuperTabDefaultCompletionType = "<c-n>"
        '';
      }
    ];
  };
}
