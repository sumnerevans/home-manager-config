# Always change the CWD to the project root.
{ pkgs, ... }:
with pkgs; {
  programs.neovim.plugins = [{
    plugin = vimPlugins.vim-tmux-navigator;
    config = ''
      let g:tmux_navigator_no_mappings = 1
      let g:tmux_navigator_disable_when_zoomed = 1

      nnoremap <silent> <A-h> :TmuxNavigateLeft<cr>
      nnoremap <silent> <A-j> :TmuxNavigateDown<cr>
      nnoremap <silent> <A-k> :TmuxNavigateUp<cr>
      nnoremap <silent> <A-l> :TmuxNavigateRight<cr>
    '';
  }];
}
