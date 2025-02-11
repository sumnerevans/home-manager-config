{ config, pkgs, lib, ... }:
with lib;
let
  personalAccountConfig = {
    address = "me@sumnerevans.com";
    name = "Personal";
    color = "green";
    signatureLines = ''
      Sumner Evans
      Software Engineer at Automattic working on Beeper
      2 Chronicles 7:14

      https://sumnerevans.com | @sumner:nevarro.space
    '';
  };

  inquiriesConfig = {
    name = "Inquiries";
    address = "inquiries@sumnerevans.com";
    color = "green";
    signatureLines = ''
      Sumner Evans
      Software Engineer at Automattic working on Beeper
      2 Chronicles 7:14

      https://sumnerevans.com | @sumner:nevarro.space
    '';
  };

  financialConfig = {
    name = "Financial";
    address = "financial@sumnerevans.com";
    color = "green";
    signatureLines = ''
      Jonathan Sumner Evans
      Software Engineer at Automattic working on Beeper
      2 Chronicles 7:14

      https://sumnerevans.com | @sumner:nevarro.space
    '';
  };

  teachingConfig = {
    name = "Teaching";
    address = "teaching@sumnerevans.com";
    color = "green";
    signatureLines = ''
      Sumner Evans
      Adjunct Professor, Colorado School of Mines
      Software Engineer at Automattic working on Beeper

      https://sumnerevans.com | @sumner:nevarro.space
    '';
  };

  travelConfig = {
    name = "Travel";
    address = "travel@sumnerevans.com";
    color = "green";
    signatureLines = ''
      Sumner Evans
      Software Engineer at Automattic working on Beeper
    '';
  };

  helper = import ./account-config-helper.nix { inherit config pkgs lib; };
in {
  accounts.email.accounts = {
    Personal = mkMerge [
      (helper.commonConfig personalAccountConfig)
      (helper.imapnotifyConfig personalAccountConfig)
      (helper.signatureConfig personalAccountConfig)
      helper.gpgConfig
      {
        flavor = "migadu.com";
        primary = !config.work.enable;
        aliases = [ "alerts@sumnerevans.com" ];
      }
    ];

    Inquiries = mkMerge [
      (helper.commonConfig inquiriesConfig)
      (helper.imapnotifyConfig inquiriesConfig)
      (helper.signatureConfig personalAccountConfig)
      {
        flavor = "migadu.com";
        aliases = [ "resume@sumnerevans.com" ];
      }
    ];

    Financial = mkMerge [
      (helper.commonConfig financialConfig)
      (helper.signatureConfig financialConfig)
      { flavor = "migadu.com"; }
    ];

    Teaching = mkMerge [
      (helper.commonConfig teachingConfig)
      (helper.imapnotifyConfig teachingConfig)
      (helper.signatureConfig teachingConfig)
      helper.gpgConfig
      { flavor = "migadu.com"; }
    ];

    Travel = mkMerge [
      (helper.commonConfig travelConfig)
      (helper.imapnotifyConfig travelConfig)
      (helper.signatureConfig travelConfig)
      { flavor = "migadu.com"; }
    ];
  };
}
