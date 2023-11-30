{ pkgs, ... }:
with pkgs; {
  programs.neovim = {
    extraPackages = [ delta fd ripgrep ];
    plugins = [
      {
        type = "lua";
        plugin = vimPlugins.telescope-fzf-native-nvim;
      }
      {
        type = "lua";
        plugin = vimPlugins.telescope-nvim;
        config = ''
          require('telescope').setup {
            defaults = {
              layout_strategy = 'vertical',
              layout_config = {
                width = 0.80,
                height = 0.85,
              },
              mappings = {
                i = {
                  ["<esc>"] = require("telescope.actions").close,
                },
              },
            },
            pickers = {
              find_files = {
                layout_strategy = 'horizontal',
                layout_config = {
                  preview_width = 0.4,
                },
                find_command = {
                  'rg',
                  '--files',
                  '--hidden',
                  '--glob',
                  '!.git',
                  '--glob',
                  '!node_modules',
                  '--glob',
                  '!dist',
                  '--glob',
                  '!.direnv',
                  '--glob',
                  '!.venv',
                },
              },
              live_grep = {
                layout_config = { preview_height = 0.7 },
              },
              grep_string = {
                layout_config = { preview_height = 0.7 },
              },
              lsp_definitions = {
                layout_config = { preview_height = 0.75 },
              },
              lsp_implementations = {
                layout_config = { preview_height = 0.75 },
              },
              lsp_references = {
                layout_config = { preview_height = 0.75 },
              },
              lsp_dynamic_workspace_symbols = {
                layout_config = { preview_height = 0.75 },
              },
            },
          }

          local telescope_builtin = require('telescope.builtin')
          vim.keymap.set('n', '<C-p>', telescope_builtin.find_files, {})
          vim.keymap.set('n', '<C-S>', telescope_builtin.live_grep, {})
          vim.keymap.set('v', '<C-S>', telescope_builtin.grep_string, {})
        '';
      }
      {
        type = "lua";
        plugin = vimPlugins.telescope-undo-nvim;
        config = ''
          require('telescope').setup {
            extensions = {
              undo = {
                side_by_side = true,
              },
            },
          }
          require("telescope").load_extension("undo")

          vim.keymap.set('n', '<S-U>', require("telescope").extensions.undo.undo, {})
        '';
      }
    ];
  };
}
