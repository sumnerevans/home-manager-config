{ config, pkgs, ... }: with pkgs; let
  aliasfile = "${config.xdg.configHome}/neomutt/aliases";
  mailboxfile = "${config.xdg.configHome}/neomutt/mailboxes";
  bindir = "${config.home.homeDirectory}/bin";
  mutt-display-filter = pkgs.writeScriptBin "mdf" (builtins.readFile ./bin/mutt-display-filter.py);

  syncthingdir = "${config.home.homeDirectory}/Syncthing";
in
{
  home.file."bin/mutt_helper" = {
    text = ''
      #!/usr/bin/env sh
      ${config.home.sessionVariables.TERMINAL} -t Mutt -e neomutt "$@"
    '';
    executable = true;
  };

  home.symlinks."${aliasfile}" = "${syncthingdir}/.config/neomutt/aliases";
  home.symlinks."${mailboxfile}" = "${syncthingdir}/.config/neomutt/mailboxes";

  programs.neomutt = {
    enable = true;
    vimKeys = true;
    binds = [
      { action = "complete-query"; key = "<Tab>"; map = [ "editor" ]; }
      { action = "sidebar-prev"; key = "\\Cp"; map = [ "index" "pager" ]; }
      { action = "sidebar-next"; key = "\\Cn"; map = [ "index" "pager" ]; }
      { action = "sidebar-open"; key = "\\Co"; map = [ "index" "pager" ]; }

    ];
    macros = [
      {
        action = "!systemctl --user start mbsync &^M";
        key = "<F5>";
        map = [ "index" ];
      }
      {
        action = "<change-folder>${config.accounts.email.accounts.Personal.maildir.absPath}/INBOX<enter>";
        key = "P";
        map = [ "index" ];
      }
      {
        action = "<change-folder>${config.accounts.email.accounts.Mines.maildir.absPath}/INBOX<enter>";
        key = "M";
        map = [ "index" ];
      }
      {
        action = "<change-folder>${config.accounts.email.accounts.Gmail.maildir.absPath}/INBOX<enter>";
        key = "A";
        map = [ "index" ];
      }
      {
        action = "<change-folder>?<change-dir><home>^K=<enter><tab>";
        key = "c";
        map = [ "index" ];
      }
      {
        action = "<save-message>?<tab>";
        key = "s";
        map = [ "index" ];
      }
    ];

    sidebar = {
      enable = true;
      width = 40;
      format = "%B%?F? [%F]?%* %?N?%N/?%S";
      shortPath = false;
    };

    settings = {
      alias_file = aliasfile;
      confirmappend = "no";
      edit_headers = "yes";
      fast_reply = "yes";
      folder = "${config.home.homeDirectory}/Mail";
      imap_check_subscribed = "yes";
      include = "yes";
      mail_check = "0";
      mail_check_stats = "yes";
      mailcap_path = "${config.xdg.configHome}/neomutt/mailcap";
      mark_old = "no";
      markers = "no";
      pager_context = "3";
      pager_index_lines = "10";
      pager_stop = "yes";
      sort_aux = "reverse-last-date-received";
      sort_re = "yes";
      tmpdir = "${config.home.homeDirectory}/tmp";
      wrap = "100";
    };

    extraConfig = ''
      source ${aliasfile}
      source ${mailboxfile}
      set display_filter="${mutt-display-filter}/bin/mdf"

      # Use return to open message because I'm not a savage
      unbind index <return>
      bind index <return> display-message

      # Use N to toggle new
      unbind index N
      bind index N toggle-new

      # Status Bar
      set status_chars  = " *%A"
      set status_format = "───[ Folder: %f (%l %s/%S)]───[%r%m messages%?n? (%n new)?%?d? (%d to delete)?%?t? (%t tagged)?%?F? (%F flagged)?]───%>─%?p?( %p postponed)?───"

      lists .*@lists.sr.ht

      # ====== COLORS ======
      color attachment        yellow          black
      color prompt            yellow          black
      color message           white           black
      color error             red             black
      color indicator         black           yellow
      color status            brightwhite     blue
      color tree              magenta         black
      color normal            white           black
      color markers           brightyellow    black
      color search            white           black

      # Index
      color index             brightwhite     black   ~N # unread
      color index             white           black   ~O # read
      color index             brightgreen     black   ~F # flagged
      color index             red             black   ~D # deleted

      # Header
      color hdrdefault        white           black
      color header            brightgreen     black   (^Subject\:)

      # Color Links blue
      color body              brightblue      black "(ftp|http|https)://[^ ]+"
      color body              brightblue      black [-a-z_0-9.]+@[-a-z_0-9.]+

      # Color signature verification
      color body              brightgreen     black "^(gpg: )?Good signature"
      color body              brightgreen     black "^(gpg: )?Encrypted"
      color body              brightred       black "^(gpg: )?Bad signature"
      color body              red             black "^(gpg: )?Problem signature from:.*"
      color body              red             black "^(gpg: )?warning:"
      color body              red             black "^(gpg: ).*failed:"

      # Body
      color quoted            cyan            black
      color signature         cyan            black

      # Sidebar
      color sidebar_highlight white           color8
      color sidebar_new       cyan            black

      # Patch syntax highlighting
      color   normal  white           default
      color   body    brightwhite     default         ^(diff).*
      color   body    white           default         ^[\-\-\-].*
      color   body    white           default         ^[\+\+\+].*
      color   body    green           default         ^[\+].*
      color   body    red             default         ^[\-].*
      color   body    brightblue      default         [@@].*
      color   body    white           default         ^(\s).*
      color   body    brightwhite     default         ^(Signed-off-by).*
      color   body    brightwhite     default         ^(Cc)
    '';
  };
}
