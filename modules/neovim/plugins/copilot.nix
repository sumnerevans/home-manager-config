{ pkgs, ... }: with pkgs; let
  copilot = pkgs.vimUtils.buildVimPluginFrom2Nix rec {
    pname = "copilot";
    version = "1.6.0";
    src = pkgs.fetchFromGitHub {
      owner = "github";
      repo = "copilot.vim";
      rev = "8ba151a20bc1d7a5c72e592e51bfc925d5bbb837";
      sha256 = "sha256-GmwR+S5sQnVUbVShP53jNpSKMZaoeh9Rf37v89wAJ3M=";
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

        let g:copilot_node_command = "${nodejs-16_x}/bin/node"
      '';
    }
  ];
}
