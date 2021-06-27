{ config, lib, pkgs, ... }: with lib;
{
  programs.fzf = {
    enable = true;
    changeDirWidgetOptions = [ "--preview 'tree -C {} | head -200'" ];
    defaultCommand = "fd --type f --hidden --follow";
    defaultOptions = [ "--border" "--height 40%" ];
    fileWidgetOptions = [ "--preview 'bat --style=numbers --color=always --line-range :500 {}'" ];
  };
}
