{ config, lib, pkgs, ... }:
let
  offlinemsmtp = pkgs.callPackage ../pkgs/offlinemsmtp.nix { };
  git-get = pkgs.callPackage ../pkgs/git-get.nix { };
in {
  home.packages = with pkgs.gitAndTools; [ gh hub lab git-get ];

  programs.git = {
    enable = true;
    package = pkgs.gitAndTools.gitFull;
    lfs.enable = true;

    userEmail = "me@sumnerevans.com";
    userName = "Sumner Evans";

    attributes = [ "*.pdf diff=pdf" ];
    delta.enable = true;

    signing = {
      key = "8904527AB50022FD";
      signByDefault = true;
    };

    aliases = { "s" = "show --ext-diff"; };

    extraConfig = {
      core.editor = "nvim";
      diff = {
        colorMoved = "default";
        submodule = "log";
      };
      init.defaultBranch = "master";
      pull.ff = "only";
      tag.gpgsign = true;
      status.submoduleSummary = true;
      rebase.autoSquash = true;

      gitget = { root = "${config.home.homeDirectory}/projects"; };

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
      ".venv"
      "__pycache__"
      ".direnv"
    ];
  };

  home.file.".python-gitlab.cfg".text = ''
    [global]
    default = gitlab
    ssl_verify = true
    timeout = 5

    [gitlab]
    url = https://gitlab.com
    private_token = ${
      lib.removeSuffix "\n" (builtins.readFile ../secrets/gitlab-api-key)
    }
  '';

  programs.zsh.shellAliases = {
    ga = "git add";
    gaa = "git add -A";
    gap = "git add -p";
    gc = "git commit --signoff";
    gca = "gc -a";
    gcaa = "gca --amend";
    gcan = "gc --amend --no-edit";
    gcaan = "gcaa --no-edit";
    gch = "git checkout";
    gd = "git diff";
    gdc = "git diff --cached";
    gfetch = "git fetch";
    gl =
      "git log --pretty=format:'%C(auto)%h %ad %C(green)%s%Creset %C(auto)%d [%an (%G? %GK)]' --graph --date=format:'%Y-%m-%d %H:%M' --all";
    gpull = "git pull";
    gpush = "git push";
    grhh = "git reset --hard HEAD";
    gs = "git status";
    gsh = "git show --ext-diff";
    gst = "git stash";
  };
}
