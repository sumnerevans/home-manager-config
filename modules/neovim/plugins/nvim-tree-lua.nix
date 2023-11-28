{ pkgs, ... }: {
  programs.neovim.plugins = [{
    type = "lua";
    plugin = pkgs.vimPlugins.nvim-tree-lua;
    config = ''
      require("nvim-tree").setup {
        view = {
          side = "right",
          width = 45,
        },
        trash = {
          cmd = "rm -rf",
        },
        renderer = {
          add_trailing = true,
          group_empty = true,
        },
      }

      vim.keymap.set('n', '<S-T>', function()
        require("nvim-tree.api").tree.toggle {
          find_file = true,
        }
      end, {})
    '';
  }];
}
