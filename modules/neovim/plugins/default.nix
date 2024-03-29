{ pkgs, ... }: {
  imports = [
    # Project Navigation
    ./telescope.nix

    # Local Environment Configuration and Integration
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
    ./virtcolumn.nvim.nix

    # Editor
    ./copilot.nix
    ./nvim-neoclip.nix
    ./vim-commentary.nix
    ./vim-template.nix

    # Language Server, Completion, and Formatting
    ./conform.nvim.nix
    ./nvim-cmp.nix
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
    pkgs.vimPlugins.vim-tmux-clipboard
    pkgs.vimPlugins.vim-visual-multi
  ];
}
