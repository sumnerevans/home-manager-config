{ config, lib, pkgs, ... }: with pkgs; let
  python-csmdirsearch = callPackage ../pkgs/python-csmdirsearch.nix { };
  python-gitlab = callPackage ../pkgs/python-gitlab.nix { };
  hasGui = config.wayland.enable || config.xorg.enable;
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

    # Python
    (
      python3.withPackages (
        ps: with ps; [
          dateutil
          fuzzywuzzy
          goobook
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
  ] ++ lib.optionals hasGui [
    # Configuration GUIs
    gnome3.gnome-power-manager
    gnome3.networkmanagerapplet

    # GUI Tools
    baobab
    bitwarden
    write_stylus
    xournal

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
  programs.bottom.enable = true;
  programs.home-manager.enable = true;
  programs.htop.enable = true;
  programs.noti.enable = true;
  programs.password-store.enable = true;

  # TODO ssh
}
