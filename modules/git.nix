{ lib, pkgs, ... }: let
  offlinemsmtp = pkgs.callPackage ../pkgs/offlinemsmtp.nix {};
in
{
  home.packages = with pkgs.gitAndTools; [ hub lab ];

  programs.git = {
    enable = true;
    package = pkgs.gitAndTools.gitFull;

    userEmail = "me@sumnerevans.com";
    userName = "Sumner Evans";

    attributes = [ "*.pdf diff=pdf" ];
    delta.enable = true;

    signing = {
      key = "8904527AB50022FD";
      signByDefault = true;
    };

    extraConfig = {
      core.editor = "${pkgs.neovim}/bin/nvim";
      diff.colorMoved = "default";
      init.defaultBranch = "master";
      pull.rebase = false;
      tag.gpgsign = true;

      sendemail = {
        annotate = "yes";
        smtpserver = "${offlinemsmtp}/bin/offlinemsmtp";
        smtpserveroption = [ "-a" "Personal" "--" ];
      };
    };

    ignores = [
      "*.orig"
      "*_BACKUP_*"
      "*_BASE_*"
      "*_LOCAL_*"
      "*_REMOTE_*"
      ".ccls-cache"
      ".mypy_cache"
      ".rooter_root"
      ".ropeproject"
      ".stylelintrc"
    ];
  };

  home.file.".python-gitlab.cfg".text = ''
    [global]
    default = gitlab
    ssl_verify = true
    timeout = 5

    [gitlab]
    url = https://gitlab.com
    private_token = ${lib.removeSuffix "\n" (builtins.readFile ../secrets/gitlab-api-key)}
  '';
}
