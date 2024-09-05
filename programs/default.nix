{ config, lib, pkgs, ... }:
with pkgs;
let
  python-csmdirsearch = callPackage ../pkgs/python-csmdirsearch.nix { };
  python-gitlab = callPackage ../pkgs/python-gitlab.nix { };
  hasGui = config.wayland.enable || config.xorg.enable;
in {
  home.packages = [
    # Shell Utilities
    aspell
    aspellDicts.en
    bind
    bitwarden-cli
    czkawka
    fd
    file
    fortune
    iftop
    kbdlight
    libarchive
    libheif
    libnotify
    libxml2
    light
    lsof
    mkpasswd
    ncdu
    neofetch
    nodejs
    nox
    openssl
    pciutils
    pcre
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
    xdg-utils
    zip

    # Python
    (python3.withPackages (ps:
      with ps; [
        python-dateutil
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
      ]))
  ] ++ lib.optionals hasGui [
    # Configuration GUIs
    gnome-power-manager
    networkmanagerapplet

    # GUI Tools
    baobab
    # Disabled until https://nixpk.gs/pr-tracker.html?pr=230971 hits unstable
    # bitwarden
    write_stylus
    xournal

    # Virtual Machine Client
    virt-manager

    (xfce.thunar.override {
      thunarPlugins = [ xfce.thunar-archive-plugin xfce.thunar-volman ];
    })
  ];

  programs.bat.enable = true;
  programs.bottom.enable = true;
  programs.home-manager.enable = true;
  programs.htop.enable = true;
  programs.noti.enable = true;
  programs.password-store.enable = true;

  # TODO ssh
}
