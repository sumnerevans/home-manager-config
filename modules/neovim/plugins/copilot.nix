{ pkgs, ... }: with pkgs; let
  copilot = pkgs.vimUtils.buildVimPluginFrom2Nix rec {
    pname = "copilot";
    version = "1.8.4";
    src = pkgs.fetchFromGitHub {
      owner = "github";
      repo = "copilot.vim";
      rev = "1358e8e45ecedc53daf971924a0541ddf6224faf";
      sha256 = "sha256-6xIOngHzmBrgNfl0JI5dUkRLGlq2Tf+HsUj5gha/Ppw=";
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
