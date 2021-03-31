{ lib, pkgs, ... }: with pkgs; {
  programs.neovim.plugins = [
    {
      plugin = vimPlugins.vim-togglelist;
      config = ''
        nmap <script> <silent> E :call ToggleLocationList()<CR>
      '';
    }
  ];
}
