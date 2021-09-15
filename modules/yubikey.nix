{ pkgs, ... }: {
  home.packages = with pkgs; [
    yubikey-manager
    yubikey-manager-qt
    yubioath-desktop
  ];
}
