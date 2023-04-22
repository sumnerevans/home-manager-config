# Always change the CWD to the project root.
{ lib, pkgs, ... }: with lib; with pkgs; {
  programs.neovim = {
    extraPackages = [ ctags ];
    plugins = [
      {
        plugin = vimPlugins.vista-vim;
        config = ''
          let g:vista_default_executive = 'coc'

          let g:vista#renderer#enable_icon = 0
          let g:vista_echo_cursor_strategy = "floating_win"

          let g:vista_log_file = expand('~/tmp/vista.log')
        '';
      }
    ];
  };
}
