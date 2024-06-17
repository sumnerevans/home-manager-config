{ pkgs, ... }: {
  programs.neovim.plugins = with pkgs.vimPlugins; [
    nvim-web-devicons
    {
      plugin = barbar-nvim;
      config = ''
        " Buffer navigation
        map <C-W> <Cmd>BufferClose<CR>
      '';
    }
  ];
}
