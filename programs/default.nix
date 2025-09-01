{ config, lib, pkgs, ... }:
with pkgs;
let
  hasGui = config.wayland.enable || config.xorg.enable;
in {
  home.packages = [
    # Shell Utilities
    aspell
    aspellDicts.en
    bind
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
        icalendar
        pillow
        pip
        pycairo
        pygobject3
        pynvim
        python-Levenshtein
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
    bitwarden
    write_stylus
    xournalpp

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
