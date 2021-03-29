{ pkgs, ... }: let
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
      pull.rebase = false;
      tag.gpgsign = true;
      diff.colorMoved = "default";

      sendemail = {
        annotate = "yes";
        smtpserver = "${offlinemsmtp}/bin/offlinemsmtp";
        smtpserveroption = [ "-a" "personal" "--" ];
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
}
