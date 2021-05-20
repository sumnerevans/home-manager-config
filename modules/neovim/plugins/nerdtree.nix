# Directory tree on the left
{ pkgs, ... }: with pkgs;{
  programs.neovim = {
    extraPackages = [
      vimPlugins.nerdtree-git-plugin
    ];

    plugins = [
      {
        plugin = vimPlugins.nerdtree;
        config = ''
          map <S-T> :NERDTreeToggle<CR>
        '';
      }
    ];
  };
}
