{ config, pkgs, ... }: with pkgs; let
  python-csmdirsearch = callPackage ../pkgs/python-csmdirsearch.nix { };
  python-gitlab = callPackage ../pkgs/python-gitlab.nix { };
in
{
  home.packages = [
    # Shell Utilities
    aspell
    aspellDicts.en
    bind
    bitwarden-cli
    fd
    file
    fortune
    fslint
    iftop
    kbdlight
    libarchive
    libnotify
    light
    lsof
    mkpasswd
    neofetch
    nodejs
    nox
    openssl
    pciutils
    pwgen
    ranger
    restic
    ripgrep
    screen
    screenfetch
    tokei
    tree
    trickle
    unzip
    usbutils
    wget
    xdg_utils
    zip

    # Configuration GUIs
    gnome3.gnome-power-manager
    gnome3.networkmanagerapplet

    # GUI Tools
    baobab
    bitwarden
    write_stylus
    xournal

    # Python
    (
      python3.withPackages (
        ps: with ps; [
          dateutil
          fuzzywuzzy
          html2text
          i3ipc
          icalendar
          pillow
          pip
          pycairo
          pygobject3
          pynvim
          python-Levenshtein
          python-csmdirsearch
          python-gitlab
          pytz
          tabulate
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

  programs.home-manager.enable = true;

  programs.htop.enable = true;

  programs.noti.enable = true;

  programs.password-store.enable = true;

  # TODO ssh
}
