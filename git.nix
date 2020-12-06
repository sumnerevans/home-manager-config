{ pkgs, ... }: let
  offlinemsmtp = pkgs.callPackage ./pkgs/offlinemsmtp.nix {};
in
{
  programs.git = {
    enable = true;

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

      sendemail = {
        annotate = "yes";
        smtpserver = "${offlinemsmtp}/bin/offlinemsmtp";
        smtpserveroption = [ "-a" "personal" "--" ];
      };
    };

    ignores = [

      "virtualenv"
      ".ropeproject"
      ".style.yapf"
      "*.vim-template:*"
      ".stylelintrc"
      "ctrlp-root"
      ".rooter_root"
      "*.orig"
      ".mypy_cache"
      "*_BACKUP_*"
      "*_BASE_*"
      "*_LOCAL_*"
      "*_REMOTE_*"
      ".ccls-cache"
    ];
  };
}
