{ config, lib, pkgs, ... }: with lib; let
  cfg = config.wayland;

  configs = {
    KohakuInternal = {
      criteria = "eDP-1";
      mode = "3840x2160@60Hz";
      scale = 1.75;
      position = "0,0";
    };
  };
in
{
  config = mkIf cfg.enable {
    home.packages = [ pkgs.kanshi ];
    services.kanshi = {
      enable = true;
      profiles = {
        Undocked = {
          outputs = [ configs.KohakuInternal ];
        };
        ThinkVision = {
          outputs = [
            configs.KohakuInternal
            {
              criteria = "Lenovo Group Limited M14 V906P5HA";
              mode = "1920x1080@60Hz";
              position = "2194,0";
            }
          ];
        };
      };
    };
  };
}
