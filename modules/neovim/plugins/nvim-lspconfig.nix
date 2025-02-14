{ pkgs, ... }:
let
  pylspPython = pkgs.python3.withPackages (ps:
    with ps; [
      black
      isort
      mypy
      pyls-isort
      python-lsp-black
      python-lsp-server
    ]);
in {
  # Make a default vale config file so the LSP doesn't explode
  xdg.configFile."vale/.vale.ini".text = "";

  programs.neovim = {
    extraPackages = with pkgs; [
      ocamlPackages.ocamlformat
      fantomas
      gopls # needed for templ
    ];
    plugins = with pkgs.vimPlugins; [
      {
        plugin = Ionide-vim;
        config = ''
          let g:fsharp#lsp_auto_setup = 0
          let g:fsharp#exclude_project_directories = ['paket-files']
        '';
      }
      {
        type = "lua";
        plugin = nvim-lspconfig;
        config = ''
          local lspconfig = require('lspconfig')
          local capabilities = require("cmp_nvim_lsp").default_capabilities()

          lspconfig.bashls.setup {
            cmd = { "${pkgs.nodePackages.bash-language-server}/bin/bash-language-server", "start" },
            capabilities = capabilities,
          }
          lspconfig.clangd.setup {
            cmd = { "${pkgs.clang-tools}/bin/clangd" },
            capabilities = capabilities,
          }
          lspconfig.cssls.setup {
            cmd = { "${pkgs.vscode-langservers-extracted}/bin/vscode-css-language-server", "--stdio" },
            capabilities = capabilities,
          }
          lspconfig.eslint.setup {
            cmd = { "${pkgs.vscode-langservers-extracted}/bin/vscode-eslint-language-server", "--stdio" },
            capabilities = capabilities,
          }
          lspconfig.gopls.setup {
            cmd = { "${pkgs.gopls}/bin/gopls" },
            capabilities = capabilities,
            settings = {
              gopls = {
                analyses = {
                  unusedparams = true,
                  unusedvariable = true,
                  unusedwrite = true,
                  useany = true,
                },
                hints = {
                  assignVariableTypes = true,
                  compositeLiteralFields = true,
                  compositeLiteralTypes = true,
                  constantValues = true,
                  functionTypeParameters = true,
                  parameterNames = true,
                  rangeVariableTypes = true,
                },
                staticcheck = true,
              },
            },
          }
          lspconfig.harper_ls.setup {
            cmd = { "${pkgs.harper}/bin/harper-ls", "--stdio" },
            capabilities = capabilities,
            settings = {
              ["harper-ls"] = {
                userDictPath = vim.fn.stdpath("config") .. "/spell/en.utf-8.add",
              }
            },
          }
          lspconfig.html.setup {
            cmd = { "${pkgs.vscode-langservers-extracted}/bin/vscode-html-language-server", "--stdio" },
            capabilities = capabilities,
          }
          lspconfig.jsonls.setup {
            cmd = { "${pkgs.vscode-langservers-extracted}/bin/vscode-json-language-server", "--stdio" },
            capabilities = capabilities,
          }
          lspconfig.kotlin_language_server.setup {
            cmd = { "${pkgs.kotlin-language-server}/bin/kotlin-language-server" },
            capabilities = capabilities,
          }
          lspconfig.nil_ls.setup {
            cmd = { "${pkgs.nil}/bin/nil" },
            capabilities = capabilities,
            settings = {
              ["nil"] = {
                formatting = {
                  command = { "${pkgs.nixfmt-classic}/bin/nixfmt" },
                },
              },
            },
          }
          lspconfig.ocamllsp.setup {
            cmd = { "${pkgs.ocamlPackages.ocaml-lsp}/bin/ocamllsp" },
            capabilities = capabilities,
          }
          lspconfig.pylsp.setup {
            cmd = { "${pylspPython}/bin/pylsp" },
            capabilities = capabilities,
            settings = {
              pylsp = {
                plugins = {
                  pyls_black = { enabled = true },
                  isort = { enabled = true, profile = "black" },
                },
              },
            },
          }
          lspconfig.templ.setup {
            cmd = { "templ", "lsp" },
            capabilities = capabilities,
          }
          lspconfig.texlab.setup {
            cmd = { "${pkgs.texlab}/bin/texlab" },
            capabilities = capabilities,
          }
          lspconfig.ts_ls.setup {
            cmd = { "${pkgs.typescript-language-server}/bin/typescript-language-server", "--stdio" },
            capabilities = capabilities,
          }
          lspconfig.vale_ls.setup {
            cmd = { "${pkgs.vale-ls}/bin/vale-ls" },
            capabilities = capabilities,
          }
          lspconfig.yamlls.setup {
            cmd = { "${pkgs.nodePackages.yaml-language-server}/bin/yaml-language-server", "--stdio" },
            capabilities = capabilities,
            settings = {
              yaml = {
                schemas = {
                  ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
                },
              },
            },
          }
          -- F#
          require('ionide').setup {
            autostart = true,
            capabilities = capabilities,
          }

          -- Use LspAttach autocommand to only map the following keys
          -- after the language server attaches to the current buffer
          vim.api.nvim_create_autocmd('LspAttach', {
            group = vim.api.nvim_create_augroup('UserLspConfig', {}),
            callback = function(ev)
              local telescope_builtin = require('telescope.builtin')

              local client = vim.lsp.get_client_by_id(ev.data.client_id)
              if client.server_capabilities.inlayHintProvider then
                vim.lsp.inlay_hint.enable(true, { bufnr = ev.buf })
              end

              -- Buffer local mappings.
              -- See `:help vim.lsp.*` for documentation on any of the below functions
              local opts = { buffer = ev.buf }
              vim.keymap.set('n', 'gd', telescope_builtin.lsp_definitions, {})
              vim.keymap.set('n', 'gi', telescope_builtin.lsp_implementations, {})
              vim.keymap.set('n', 'gr', telescope_builtin.lsp_references, {})
              vim.keymap.set('n', 'S', telescope_builtin.lsp_dynamic_workspace_symbols, {})
              vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
              vim.keymap.set('n', '<F6>', vim.lsp.buf.rename, opts)
              vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
            end,
          })

          local max_width = math.max(math.floor(vim.o.columns * 0.7), 100)
          local max_height = math.max(math.floor(vim.o.lines * 0.3), 30)

          -- NOTE: the hover handler returns the bufnr,winnr so can be used for mappings
          vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, {
            border = 'rounded',
            max_width = max_width,
            max_height = max_height,
          })

          vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, {
            border = 'rounded',
            max_width = max_width,
            max_height = max_height,
          })
        '';
      }
    ];
  };
}
