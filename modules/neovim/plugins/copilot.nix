{ pkgs, ... }: with pkgs; let
  copilot = pkgs.vimUtils.buildVimPlugin rec {
    pname = "copilot";
    version = "1.11.4";
    src = pkgs.fetchFromGitHub {
      owner = "github";
      repo = "copilot.vim";
      rev = "309b3c803d1862d5e84c7c9c5749ae04010123b8";
      sha256 = "sha256-yuaG4kOSXSivFQCvc6iEZP230tlaFoXcZb0WxBjeWdA=";
    };
    meta.homepage = "https://github.com/features/copilot";
  };
in
{
  programs.neovim.plugins = [
    {
      plugin = copilot;
      config = ''
        imap <silent><script><expr> <C-c> copilot#Accept("\<CR>")
        imap <silent> <C-l> <Plug>(copilot-next)
        let g:copilot_no_tab_map = v:true
      '';
    }
  ];
}
