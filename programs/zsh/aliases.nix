{ config, pkgs, lib, ... }: with lib; let
  pdfviewer = "zathura --fork";
in
{
  programs.zsh = {
    shellAliases = {
      ##### Command Shortcuts #####
      # Printing
      alpr = "ssh isengard lpr -P bb136-printer -o coallate=true";
      alprd = "ssh isengard lpr -P bb136-printer -o coallate=true -o Duplex=DuplexNoTumble";
      lpr = "lpr -o coallate=true";
      hlpr = "lpr -P HP_ENVY_4500_series";
      hlprd = "hlpr -o Duplex=DuplexNoTumble";

      # Git
      ga = "git add";
      gaa = "git add -A";
      gap = "git add -p";
      gc = "git commit";
      gca = "gc -a";
      gcaa = "gca --amend";
      gcan = "gc --amend --no-edit";
      gcaan = "gcaa --no-edit";
      gch = "git checkout";
      gd = "git diff";
      gdc = "git diff --cached";
      gfetch = "git fetch";
      gl = "git log --pretty=format:'%C(auto)%h %ad %C(green)%s%Creset %C(auto)%d [%an (%G? %GK)]' --graph --date=format:'%Y-%m-%d %H:%M' --all";
      gpull = "git pull";
      gpush = "git push";
      grhh = "git reset --hard HEAD";
      gs = "git status";
      gst = "git stash";

      # Config
      i3conf = "chezmoi edit -a ~/.config/i3/config";
      muttrc = "chezmoi edit -a ~/.mutt/muttrc && chezmoi apply";
      nvimrc = "chezmoi edit -a ~/.config/nvim/init.vim";
      projectlist = "vim ~st/projectlist && projectsync";
      quotesfile = "chezmoi edit -a ~/.mutt/quotes && strfile -r ~/.mutt/quotes";
      reload = ". ~/.zshrc && echo 'ZSH Config Reloaded from ~/.zshrc'";
      sshconf = "vim ~/.ssh/config";
      swayconf = "chezmoi edit -a ~/.config/sway/config";
      vimrc = "realvim ~/.vim/vimrc";
      vimshort = "chezmoi edit -a ~/.vim/shortcuts";
      xresources = "chezmoi edit -a ~/.Xresources && xrdb -load ~/.Xresources && echo '~/Xresources reloaded'";

      # Other aliases
      antioffice = "libreoffice --headless --convert-to pdf";
      feh = "feh -.";
      getquote = "fortune ~/.mutt/quotes";
      grep = "grep --color -n";
      hostdir = "python -m http.server";
      iftop = "sudo iftop -i any";
      journal = "vim ${config.home.homeDirectory}/Documents/journal/$(date +%Y-%m-%d).rst";
      la = "ls -a";
      ll = "ls -lah";
      ls = mkIf config.isLinux "ls --color -F";
      man = "MANWIDTH=80 man --nh --nj";
      myip = "curl 'https://api.ipify.org?format=text' && echo";
      ohea = "echo 'You need to either wake up or go to bed!'";
      open = if config.isLinux then "(thunar &> /dev/null &)" else "open .";
      pdflatex = "pdflatex -shell-escape";
      pwd = "pwd && pwd -P";
      sbcl = "rlwrap sbcl";
      screen = "screen -DR";
      soviet = "amixer set Master on 50% && mpv --quiet -vo caca 'https://www.youtube.com/watch?v=U06jlgpMtQs'";
      tar = "${pkgs.libarchive}/bin/bsdtar";
      tt-tea = "tt start -p teaching/aca";
      wdir = "watch --color -n .5 'ls -lha --color=always'";
      xelatex = "xelatex -shell-escape";
      zathura = pdfviewer;

      # Use nvim by default if it exists
      realvim = "command vim";
      vim = "nvim";
    };

    initExtra = ''
      # File Type Associations
      alias -s cpp=$EDITOR
      alias -s doc=$OFFICE
      alias -s docx=$OFFICE
      alias -s exe=$WINE
      alias -s h=$EDITOR
      alias -s md=$EDITOR
      alias -s mp4=$VIDEOVIEWER
      alias -s mkv=$VIDEOVIEWER
      alias -s ods=$OFFICE
      alias -s odt=$OFFICE
      alias -s pdf=${pdfviewer}
      alias -s ppt=$OFFICE
      alias -s pptx=$OFFICE
      alias -s tex=$EDITOR
      alias -s txt=$EDITOR
      alias -s xls=$OFFICE
      alias -s xlsx=$OFFICE

      # Making GNU fileutils more verbose
      for c in cp mv rm chmod chown rename; do
          alias $c="$c -v"
      done
    '';
  };
}
