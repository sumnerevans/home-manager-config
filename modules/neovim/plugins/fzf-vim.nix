# Fuzzy finder with preview window
{ pkgs, ... }:
let
  nvim-lspfuzzy = pkgs.vimUtils.buildVimPlugin rec {
    pname = "lspfuzzy";
    version = "1.0.0";
    src = pkgs.fetchFromGitHub {
      owner = "ojroques";
      repo = "nvim-lspfuzzy";
      rev = "v${version}";
      hash = "sha256-qs20m7J8Apq336xTz0M/6eKVeTwkbTKa6mNqng8gZ5I=";
    };
    meta.homepage = "https://github.com/luochen1990/rainbow/";
  };
in with pkgs; {
  programs.neovim = {
    extraPackages = [ fzf ];
    plugins = [
      {
        plugin = vimPlugins.fzf-vim;
        config = ''
          nnoremap <C-p> :Files<CR>
          let g:fzf_preview_window = 'right:60%'
        '';
      }
      {
        type = "lua";
        plugin = nvim-lspfuzzy;
        config = ''
          require('lspfuzzy').setup {
            fzf_preview = {          -- arguments to the FZF '--preview-window' option
              'up:+{2}-/2'        -- preview above and centered on entry
            },
          }
        '';
      }
    ];
  };
}
