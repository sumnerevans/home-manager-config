{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.wayland;

  configs = {
    ThinkPadInternal = {
      criteria = "Lenovo Group Limited 0x40BA";
      mode = "1920x1080@60Hz";
      position = "0,0";
    };
    KohakuInternal = {
      criteria = "Unknown 0x4142";
      mode = "3840x2160@60Hz";
      scale = 1.75;
      position = "0,0";
    };
    ThinkVision = {
      criteria = "Lenovo Group Limited M14 V906P5HA";
      mode = "1920x1080@60Hz";
    };
    DellP2421D = {
      criteria = "Dell Inc. DELL P2421D D643X53";
      mode = "2560x1440@60Hz";
      position = "2560,0";
    };
    DellS2417DG = {
      criteria = "Dell Inc. Dell S2417DG #ASNmc/dFujvd";
      mode = "2560x1440@143.998Hz";
      position = "0,0";
    };
    ScarifInternal = {
      criteria =
        "InfoVision Optoelectronics (Kunshan) Co.,Ltd China 0x8C44 Unknown";
    };
  };

  arrangeWorkspaces = [
    ''
      ${pkgs.sway}/bin/swaymsg '[workspace="10"]' move workspace to output right''
    ''
      ${pkgs.sway}/bin/swaymsg '[workspace="11: "]' move workspace to output right''
    ''
      ${pkgs.sway}/bin/swaymsg '[workspace="12: "]' move workspace to output right''
  ];
in {
  config = mkIf cfg.enable {
    home.packages = [ pkgs.kanshi ];
    services.kanshi = {
      enable = true;
      profiles = {
        Kohaku_Undocked = { outputs = [ configs.KohakuInternal ]; };
        ThinkPad_Undocked = { outputs = [ configs.ThinkPadInternal ]; };
        Kohaku_ThinkVision = {
          exec = arrangeWorkspaces;
          outputs = [
            configs.KohakuInternal
            (configs.ThinkVision // { position = "2194,0"; })
          ];
        };
        ThinkPad_ThinkVision = {
          exec = arrangeWorkspaces;
          outputs = [
            configs.ThinkPadInternal
            (configs.ThinkVision // { position = "1920,0"; })
          ];
        };
        DoubleDell = { outputs = [ configs.DellP2421D configs.DellS2417DG ]; };

        ScarifUndocked = {
          outputs = [
            (configs.ScarifInternal // {
              mode = "1920x1200@60Hz";
              position = "0,0";
            })
          ];
        };
        ScarifDockedBoth = {
          outputs = [
            (configs.ScarifInternal // { status = "disable"; })
            configs.DellS2417DG
            configs.DellP2421D
          ];
        };
        ScarifDockedOne = {
          outputs = [
            {
              criteria = "Dell Inc. Dell S2417DG #ASNmc/dFujvd";
              mode = "2560x1440@143.998Hz";
            }
            configs.ScarifInternal
          ];
        };
      };
    };
  };
}
