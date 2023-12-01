{ config, pkgs, lib, ... }:
with lib;
let
  personalAccountConfig = {
    address = "me@sumnerevans.com";
    name = "Personal";
    color = "green";
    signatureLines = ''
      Sumner Evans
      Software Engineer at Beeper
      2 Chronicles 7:14

      https://sumnerevans.com | @sumner:nevarro.space | GPG: B50022FD
    '';
  };

  inquiriesConfig = {
    name = "Inquiries";
    address = "inquiries@sumnerevans.com";
    color = "green";
    signatureLines = ''
      Sumner Evans
      Software Engineer at Beeper
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
      Software Engineer at Beeper
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
      Software Engineer at Beeper

      https://sumnerevans.com | @sumner:nevarro.space | GPG: B50022FD
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
      helper.migaduConfig
      {
        primary = true;
        aliases = [ "alerts@sumnerevans.com" ];
      }
    ];

    Inquiries = mkMerge [
      (helper.commonConfig inquiriesConfig)
      (helper.imapnotifyConfig inquiriesConfig)
      (helper.signatureConfig personalAccountConfig)
      helper.migaduConfig
      { aliases = [ "resume@sumnerevans.com" ]; }
    ];

    Financial = mkMerge [
      (helper.commonConfig financialConfig)
      (helper.signatureConfig financialConfig)
      helper.migaduConfig
    ];

    Teaching = mkMerge [
      (helper.commonConfig teachingConfig)
      (helper.imapnotifyConfig teachingConfig)
      (helper.signatureConfig teachingConfig)
      helper.gpgConfig
      helper.migaduConfig
    ];
  };
}
