{ pkgs, ... }: with pkgs; let
  copilot = pkgs.vimUtils.buildVimPluginFrom2Nix rec {
    pname = "copilot";
    version = "0.1.0";
    src = pkgs.fetchFromGitHub {
      owner = "github";
      repo = "copilot.vim";
      rev = "c2e75a3a7519c126c6fdb35984976df9ae13f564";
      sha256 = "sha256-V13La54aIb3hQNDE7BmOIIZWy7In5cG6kE0fti/wxVQ=";
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
