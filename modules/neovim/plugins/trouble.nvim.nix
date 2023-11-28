# Tree Sitter
{ pkgs, ... }: {
  programs.neovim.plugins = [{
    type = "lua";
    plugin = pkgs.vimPlugins.trouble-nvim;
    config = ''
      require('trouble').setup({
        height = 7,
        auto_open = true,
        auto_preview = false,
      })
    '';
  }];
}
