# Enable git blame on the line.
{ pkgs, ... }: with pkgs; let
  blamer = pkgs.vimUtils.buildVimPluginFrom2Nix rec {
    pname = "blamer";
    version = "1.3.0";
    src = pkgs.fetchFromGitHub {
      owner = "APZelos";
      repo = "blamer.nvim";
      rev = "v${version}";
      sha256 = "sha256-uIrbnoS2llGjn/mLMftO4F6gss0xnPCE39yICd0N51Y=";
    };
    meta.homepage = "https://github.com/APZelos/blamer.nvim";
  };
in
{
  programs.neovim.plugins = [
    {
      plugin = blamer;
      config = ''
        let g:blamer_enabled = 1
        let g:blamer_date_format = '%Y-%m-%d'
        let g:blamer_template = '<committer>, <committer-time> • <commit-short> • <summary>'
      '';
    }
  ];
}
