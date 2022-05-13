{ config, lib, pkgs, ... }: with pkgs; let
  python-csmdirsearch = callPackage ../pkgs/python-csmdirsearch.nix { };
  python-gitlab = callPackage ../pkgs/python-gitlab.nix { };
  hasGui = config.wayland.enable || config.xorg.enable;
in
{
  # Fix for https://gitlab.gnome.org/GNOME/libnotify/-/issues/25/
  # until https://github.com/NixOS/nixpkgs/pull/172287 gets to unstable
  nixpkgs.overlays = [
    (self: super: {
      libnotify = super.libnotify.overrideAttrs (old: rec {
        pname = "libnotify";
        version = "0.7.12";

        src = fetchurl {
          url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
          sha256 = "dEsrN1CBNfgmG3Vanevm4JrdQhrcdb3pMPbhmLcKtG4=";
        };
      });
    })
  ];

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
    networkmanagerapplet

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
