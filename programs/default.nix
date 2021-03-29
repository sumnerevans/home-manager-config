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
  home.packages = [
    # Shell Utilities
    aspell
    aspellDicts.en
    bind
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
    libarchive
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
    xdg_utils
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
  };

  programs.feh.enable = true;

  programs.fzf = {
    enable = true;
    defaultCommand = "fd --type f --hidden --follow --exclude .git";
  };

  programs.gpg.enable = true;

  programs.home-manager.enable = true;
  programs.home-manager.path = "$HOME/projects/home-manager";

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

  programs.noti.enable = true;

  programs.obs-studio.enable = true;
  programs.obs-studio.plugins = with pkgs; [ obs-wlrobs obs-v4l2sink ];

  programs.opam.enable = true;

  programs.password-store.enable = true;

  # TODO qutebrowser

  # TODO ssh

  # TODO: tmux

  programs.vscode.enable = true;

  programs.zathura.enable = true;
}
