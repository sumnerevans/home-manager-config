{ pkgs, ... }: {
  programs.neovim.plugins = [
    {
      type = "lua";
      plugin = pkgs.vimPlugins.copilot-lua;
      config = ''
        require('copilot').setup({
          suggestion = { enabled = false },
          panel = { enabled = false },
        })
      '';
    }
    {
      type = "lua";
      plugin = pkgs.vimPlugins.copilot-cmp;
      config = ''
        require("copilot_cmp").setup()
      '';
    }
  ];
}
