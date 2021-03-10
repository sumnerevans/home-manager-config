{ pkgs, ... }: with pkgs; let
  menucalc = callPackage ../pkgs/menucalc.nix {};
  offlinemsmtp = callPackage ../pkgs/offlinemsmtp.nix {};
  python-csmdirsearch = callPackage ../pkgs/python-csmdirsearch.nix {};
  python-gitlab = callPackage ../pkgs/python-gitlab.nix {};
  sublime-music = callPackage ../pkgs/sublime-music.nix {
    chromecastSupport = true;
    serverSupport = true;
  };
  tracktime = callPackage ../pkgs/tracktime.nix {};
in
{
  imports = [
    ./alacritty.nix
    ./browsers.nix
    ./git.nix
    ./i3status-rust.nix
    ./newsboat.nix
    ./tmux.nix
  ];

  home.packages = [
    # Shell Utilities
    aspell
    aspellDicts.en
    bitwarden-cli
    chezmoi
    delta
    dfeet
    fd
    ffmpeg-full
    file
    fortune
    fslint
    iftop
    kbdlight
    khal
    libnotify
    light
    lsof
    mkpasswd
    neofetch
    nodejs
    nox
    openssl
    pavucontrol
    pciutils
    playerctl
    ranger
    restic
    ripgrep
    screen
    screenfetch
    tokei
    tracktime
    tree
    trickle
    unzip
    usbutils
    vdirsyncer
    watchexec
    wget
    youtube-dl
    zip

    # Communication
    discord
    element-desktop
    mumble
    offlinemsmtp
    zoom-us

    # Multimedia
    fbida
    gimp
    guvcview
    imagemagick
    inkscape
    kdenlive
    libreoffice-fresh
    spotify
    steam
    streamlink
    sublime-music

    # Configuration GUIs
    gnome3.gnome-power-manager
    gnome3.networkmanagerapplet

    # GUI Tools
    baobab
    bitwarden
    menucalc
    sqlitebrowser
    wireshark
    write_stylus
    xournal

    # Python
    (
      python38.withPackages (
        ps: with ps; [
          dateutil
          fuzzywuzzy
          html2text
          i3ipc
          icalendar
          pip
          pycairo
          pygobject3
          pynvim
          python-csmdirsearch
          python-gitlab
          python-Levenshtein
          pytz
          vobject
          watchdog
        ]
      )
    )

    (
      xfce.thunar.override {
        thunarPlugins = [
          xfce.thunar-archive-plugin
          xfce.thunar-volman
        ];
      }
    )
  ];

  programs.bat.enable = true;

  programs.chromium.enable = true;

  programs.direnv = {
    enable = true;
    enableNixDirenvIntegration = true;
    enableZshIntegration = true;
  };

  programs.feh.enable = true;

  # TODO firefox

  programs.fzf = { enable = true; enableZshIntegration = true; };

  programs.gpg.enable = true;

  programs.home-manager.enable = true;

  programs.htop.enable = true;

  programs.jq.enable = true;

  programs.mpv.enable = true;
  programs.mpv.config = {
    force-window = "yes";
    gpu-context = "wayland";
    hwdec = "auto-safe";
    profile = "gpu-hq";
    vo = "gpu";
    ytdl-format = "bestvideo+bestaudio";
  };

  # TODO neomutt

  # TODO neovim

  programs.noti.enable = true;

  programs.obs-studio.enable = true;
  programs.obs-studio.plugins = with pkgs; [ obs-wlrobs obs-v4l2sink ];

  programs.opam = { enable = true; enableZshIntegration = true; };

  programs.password-store.enable = true;

  # TODO qutebrowser

  # TODO ssh

  # TODO: tmux

  programs.vscode.enable = true;

  programs.zathura.enable = true;

  # TODO zsh
}
