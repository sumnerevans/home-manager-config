{ config, lib, pkgs, ... }: with lib; {
  imports = [
    ./aliases.nix
    ./completion.nix
    ./dir-hashes.nix
    ./functions.nix
    ./plugins.nix
  ];

  options = {
    isLinux = mkEnableOption "Linux support" // { default = true; };
    isMacOS = mkEnableOption "macOS support";
    autoAddSSHKeysToAgent = mkEnableOption "automatically add SSH keys to the SSH agent" // { default = true; };
  };

  config = {
    programs.zsh = {
      enable = true;
      defaultKeymap = "viins";

      localVariables = {
        OFFICE = "libreoffice";
        VIDEOVIEWER = "mpv";
        WINE = "wine";
      };

      sessionVariables = {
        # Make Rust blow up verbosely
        RUST_BACKTRACE = 1;

        # Pipenv
        PIPENV_MAX_DEPTH = 10000; # basically infinite
        PIPENV_VENV_IN_PROJECT = 1; # store the virtual environment in .venv in the project directory

        # Use colors!
        TERM = "xterm-256color";
      };

      history = {
        expireDuplicatesFirst = true;
        ignoreAllDups = true;
        extended = true;
        path = "${config.home.homeDirectory}/.histfile";

        ignorePatterns = [
          "gl"
          "gs"
          "tt"
          "l"
          "ll"
        ];
      };

      initExtraFirst = ''
        # If inside of an SSH session, run tmux.
        if [[ -n $SSH_CONNECTION ]]; then
            if command -v tmux &> /dev/null &&
                    [ -n "$PS1" ] &&
                    [[ ! "$TERM" =~ screen ]] &&
                    [[ ! "$TERM" =~ tmux ]] &&
                    [ -z "$TMUX" ]; then
                exec tmux attach && exit
            fi
        fi

        export TERM=xterm-256color
      '';

      initExtra =
        let
          tput = "${pkgs.ncurses}/bin/tput";
          opensshAdd = optionalString config.autoAddSSHKeysToAgent ''
            # Add my key to the ssh-agent if necessary
            ${pkgs.openssh}/bin/ssh-add -l | \
              ${pkgs.gnugrep}/bin/grep "The agent has no identities" && \
              ${pkgs.openssh}/bin/ssh-add
          '';
        in
        ''
          # TODO a lot of this stuff has to be after all of the aliases
          if [[ $FOR_MUTT_HELPER != 1 ]]; then

            ${builtins.readFile ./key-widgets.zsh}
            ${builtins.readFile ./prompt.zsh}
            ${builtins.readFile ./git-repo-nav.zsh}

            # Colors
            autoload colors zsh/terminfo
            colors
            ${optionalString config.isLinux "eval $(dircolors -b)"}
            ${optionalString config.isMacOS "export CLICOLOR=1"}

            setopt appendhistory
            setopt extendedglob
            setopt autopushd
            setopt nobeep  # Don't beep ever

            ${opensshAdd}

            echo "$(${tput} bold)======================================================================$(${tput} sgr 0)"

            # Notify me if I haven't written in my journal for the day.
            if [[ ! -f ${config.home.homeDirectory}/Documents/journal/$(${pkgs.coreutils}/bin/date +%Y-%m-%d).rst ]]; then
                echo "\n$(${tput} bold)>>>> Make sure to write in your journal today. <<<<$(${tput} sgr 0)"
                echo
            fi

            # Show a quote
            ${pkgs.fortune}/bin/fortune ${config.xdg.dataHome}/fortune/quotes

            echo "$(${tput} bold)======================================================================$(${tput} sgr 0)"

          fi
        '';
    };

    programs.direnv.enableZshIntegration = true;
    programs.fzf.enableZshIntegration = true;
    programs.opam.enableZshIntegration = true;

    home.sessionPath = [
      "${config.home.homeDirectory}/.local/bin"
      "${config.home.homeDirectory}/.cargo/bin"
      "${config.home.homeDirectory}/go/bin"
      "${config.home.homeDirectory}/.beeper-stack-tools"
    ];
  };
}
