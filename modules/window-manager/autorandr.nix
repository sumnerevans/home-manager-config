{ config, lib, pkgs, ... }: with lib; let
  cfg = config.xorg;
  fingerprints = {
    ThinkPad_Internal = "00ffffffffffff0030aeba4000000000001c0104a5221378e238d5975e598e271c505400000001010101010101010101010101010101243680a070381f403020350058c210000019502b80a070381f403020350058c2100000190000000f00d10930d10930190a0030e4e705000000fe004c503135365746432d535044420094";
    ThinkVision = "00ffffffffffff0030aedd61000000002a1e0104a51f12783aee95a3544c99260f5054bdcf84a94081008180818c9500950fa94ab300023a801871382d40582c450035ae1000001e000000fc004d31340a202020202020202020000000fd00324b1e5a14000a202020202020000000ff0056393036503548410affffffff0101020314b4499011040302011f121365030c0010007c2e90a0601a1e4030203600dc0b1100001cab22a0a050841a3030203600dc0b1100001c662156aa51001e30468f3300dc0b1100001e000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000022";
  };

  configs = {
    ThinkPad_Internal = {
      enable = true;
      primary = true;
      position = "0x0";
      mode = "1920x1080";
      rate = "60.00";
    };
    ThinkVision = {
      enable = true;
      mode = "1920x1080";
      rate = "60.00";
    };
  };
in
{
  config = mkIf cfg.enable {
    programs.autorandr = {
      enable = true;
      hooks = {
        postswitch = {
          "change-background" = "systemctl restart --user wallpaper";
          "notify-dbus" = ''${pkgs.libnotify}/bin/notify-send "Profile changed to $AUTORANDR_CURRENT_PROFILE"'';
        };
      };
      profiles = {
        ThinkPad = {
          fingerprint = {
            eDP-1 = fingerprints.ThinkPad_Internal;
          };
          config = {
            eDP-1 = configs.ThinkPad_Internal;
          };
        };
        ThinkVision = {
          fingerprint = {
            eDP-1 = fingerprints.ThinkPad_Internal;
            DP-1 = fingerprints.ThinkVision;
          };
          config = {
            eDP-1 = configs.ThinkPad_Internal;
            DP-1 = configs.ThinkVision // { position = "1920x0"; };
          };
        };
      };
    };
  };
}
