{ pkgs, ... }: {
  imports = [
    # Project Navigation
    ./ctrlsf.nix
    ./fzf-vim.nix

    # Local Environment Configuration and Integration
    ./editorconfig-vim.nix
    ./vim-autoswap.nix
    ./vim-localvimrc.nix
    ./vim-rooter.nix
    ./vim-tmux-navigator.nix

    # UI Chrome
    ./barbar.nix
    ./blamer.nix
    ./gitsigns-nvim.nix
    ./vim-lightline.nix
    ./nvim-tree-lua.nix

    # Editor
    ./copilot.nix
    ./vim-commentary.nix
    ./vim-template.nix

    # Language Server and Completion
    ./nvim-cmp.nix
    ./nvim-lint.nix
    ./nvim-lspconfig.nix
    ./trouble.nvim.nix

    # Synatx Highlighting
    ./rainbow-delimiters.nix
    ./tree-sitter.nix
  ];

  programs.neovim.plugins = [
    # Local Environment Configuration and Integration
    pkgs.vimPlugins.direnv-vim

    # Editor
    pkgs.vimPlugins.vim-closetag
    pkgs.vimPlugins.vim-surround
    pkgs.vimPlugins.vim-visual-multi
  ];
}
