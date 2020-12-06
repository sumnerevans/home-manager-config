{ ... }: {
  imports = [
    ./alacritty.nix
    # TODO firefox
    ./git.nix
  ];

  programs.bat.enable = true;

  programs.chromium.enable = true;

  programs.direnv = {
    enable = true;
    enableNixDirenvIntegration = true;
    enableZshIntegration = true;
  };

  programs.feh.enable = true;

  programs.fzf.enable = true;
  programs.fzf.enableZshIntegration = true;

  programs.gpg.enable = true;

  programs.home-manager.enable = true;

  programs.htop.enable = true;
}
