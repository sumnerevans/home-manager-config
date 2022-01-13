{ pkgs, ... }: with pkgs; {
  imports = [
    # Project Navigation and Configuration
    ./ctrlsf.nix
    ./editorconfig-vim.nix
    ./vim-rooter.nix

    # UI Chrome
    ./fzf-vim.nix
    # ./nerdtree.nix
    ./vim-airline.nix
    ./vim-togglelist.nix

    # Editor
    ./blamer.nix
    # ./deoplete.nix
    ./rainbow.nix
    # ./supertab.nix
    ./vim-commentary.nix
    ./vim-multiple-cursors.nix
    ./vim-signify.nix
    ./vim-template.nix

    # Integration with environment
    ./vim-autoswap.nix
    ./vim-tmux-navigator.nix

    # Language Support
    # ./ale.nix
    ./coc.nix
    # ./vim-markdown-composer.nix
  ];

  programs.neovim.plugins = with vimPlugins; [
    # Project Navigation and Configuration
    direnv-vim
    vim-fugitive

    # Editor
    auto-pairs
    vim-closetag
    vim-surround

    # Language Support
    vim-polyglot # Syntax support for basically all of the languages
  ];
}
