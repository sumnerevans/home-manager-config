# nvim-cmp
{ pkgs, ... }: {
  programs.neovim = {
    plugins = with pkgs.vimPlugins; [{
      type = "lua";
      plugin = nvim-lint;
      config = ''
        vim.api.nvim_create_autocmd({ "BufWritePost" }, {
          callback = function()
            require("lint").try_lint()
          end,
        })
      '';
    }];
  };
}
