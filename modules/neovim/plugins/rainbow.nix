{ pkgs, ... }: let
  rainbow = pkgs.vimUtils.buildVimPluginFrom2Nix rec {
    pname = "rainbow";
    version = "3.3.1";
    src = pkgs.fetchFromGitHub {
      owner = "luochen1990";
      repo = "rainbow";
      rev = "v${version}";
      sha256 = "sha256-mKdgDQisD2w6dstTY+FUKh0vQeg57w39+Ga4Z/KKZPk=";
    };
    meta.homepage = "https://github.com/luochen1990/rainbow/";
  };
in
{
  programs.neovim.plugins = [
    {
      plugin = rainbow;
      config = ''
        let g:rainbow_active = 1
        let g:rainbow_conf = {
                    \   'separately': {
                    \       'nerdtree': 0,
                    \       'tex': {
                    \           'parentheses': ['start=/(/ end=/)/', 'start=/\[/ end=/\]/'],
                    \       },
                    \   }
                    \}
      '';
    }
  ];
}
