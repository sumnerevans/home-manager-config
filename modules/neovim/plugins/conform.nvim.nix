{ pkgs, ... }: {
  programs.neovim.plugins = [{
    type = "lua";
    plugin = pkgs.vimPlugins.conform-nvim;
    config = ''
      require("conform").setup({
        formatters_by_ft = {
          go = { "goimports", "gofmt" },
          markdown = { "prettier" },
          nix = { "nixfmt" },
        },
        formatters = {
          goimports = { command = "${pkgs.gotools}/bin/goimports" },
          gofmt = { command = "${pkgs.go}/bin/gofmt" },
          prettier = { command = "${pkgs.nodePackages.prettier}/bin/prettier" },
        },
      })
      vim.keymap.set('n', '<C-f>', function()
        require("conform").format {
          lsp_fallback = true,
        }
      end, opts)
    '';
  }];
}
