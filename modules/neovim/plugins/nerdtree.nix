# Directory tree on the left
{ pkgs, ... }: with pkgs;{
  programs.neovim = {
    plugins = [
      { plugin = vimPlugins.nerdtree-git-plugin; }
      {
        plugin = vimPlugins.nerdtree;
        config = ''
          map <S-T> :NERDTreeToggle<CR>
        '';
      }
    ];
  };
}
