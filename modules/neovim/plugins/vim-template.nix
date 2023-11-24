# Sublime Text-like search
{ config, pkgs, ... }:
let
  vim-template = pkgs.vimUtils.buildVimPlugin rec {
    pname = "vim-template";
    version = "0.0.1";
    src = pkgs.fetchFromGitHub {
      owner = "aperezdc";
      repo = "vim-template";
      rev = "618d3f2713ab300b9d8e755fd9fbc43d4f394d7e";
      sha256 = "sha256-zPWmIzo4HBgdyeXPkF5NWjt3ISzSdpzBX5gmyr1m08M=";
    };
    meta.homepage = "https://github.com/aperezdc/vim-template";
  };
in
{
  programs.neovim.plugins = [
    {
      plugin = vim-template;
      config = ''
        let g:templates_no_builtin_templates = 1
        let g:templates_directory = [
            \'${config.xdg.configHome}/nvim/templates',
            \]
      '';
    }
  ];
}
