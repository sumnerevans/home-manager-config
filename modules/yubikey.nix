{ config, lib, pkgs, ... }: {
  # home.packages = with pkgs; [
  #   yubikey-manager
  # ] ++ lib.optionals (config.wayland.enable || config.xorg.enable) [
  #   yubikey-manager-qt
  #   yubioath-desktop
  # ];
}
