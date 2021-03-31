{ pkgs, ... }: {
  programs.neovim.plugins = [
    {
      plugin = pkgs.vimPlugins.vim-signify;
      config = ''
        let g:signify_sign_delete = '-' " Make delete use - rather than _
      '';
    }
  ];
}
