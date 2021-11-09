{ pkgs, ... }: {
  programs.tmux = {
    enable = true;
    baseIndex = 1;
    keyMode = "vi";
    clock24 = true;
    escapeTime = 0;
    historyLimit = 10000;
    newSession = true;
    shell = "${pkgs.zsh}/bin/zsh";
    terminal = "tmux-256color";

    plugins = with pkgs.tmuxPlugins; [
      yank
      #resurrect
      {
        # Resurrect tmux sessions (https://github.com/tmux-plugins/tmux-continuum)
        plugin = continuum;
        extraConfig = ''
          set -g @continuum-restore 'on'
        '';
      }
    ];

    extraConfig = ''
      # Use Alt-HJKL to move around between vim panes and tmux windows.
      is_vim="ps -o state= -o comm= -t '#{pane_tty}' \
          | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|n?vim?x?)(diff)?$'"
      bind -n M-C-h if-shell "$is_vim" 'send-keys M-h' 'select-pane -L'
      bind -n M-C-j if-shell "$is_vim" 'send-keys M-j' 'select-pane -D'
      bind -n M-C-k if-shell "$is_vim" 'send-keys M-k' 'select-pane -U'
      bind -n M-C-l if-shell "$is_vim" 'send-keys M-l' 'select-pane -R'

      bind -n M-h if-shell "$is_vim" 'send-keys M-h' 'select-pane -L'
      bind -n M-j if-shell "$is_vim" 'send-keys M-j' 'select-pane -D'
      bind -n M-k if-shell "$is_vim" 'send-keys M-k' 'select-pane -U'
      bind -n M-l if-shell "$is_vim" 'send-keys M-l' 'select-pane -R'

      # Open a new window with Alt-Enter
      bind -n M-C-Enter split-window -h
      bind -n M-Enter split-window -h

      # Use the mouse
      set -gq mouse on

      # Improve copy mode
      bind-key -T copy-mode-vi 'v' send-keys -X begin-selection
      bind-key -T copy-mode-vi 'y' send-keys -X copy-selection-and-cancel

      set -ga terminal-overrides ',*256col*:Tc'
    '';
  };
}
