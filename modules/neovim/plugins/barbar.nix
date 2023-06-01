{ pkgs, ... }: {
  programs.neovim.plugins = with pkgs.vimPlugins; [
    nvim-web-devicons
    {
      plugin = barbar-nvim;
      config = ''
        " Buffer navigation
        map <C-H> <Cmd>BufferPrevious<CR>
        map <C-L> <Cmd>BufferNext<CR>
        map <C-W> <Cmd>BufferClose<CR>
      '';
    }
  ];
}
