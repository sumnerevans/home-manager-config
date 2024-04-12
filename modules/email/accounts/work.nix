{ config, pkgs, lib, ... }:
with lib;
let
  automatticConfig = {
    address = "sumner.evans@automattic.com";
    name = "Automattic";
    color = "blue";
  };
  beeperConfig = {
    address = "sumner@beeper.com";
    name = "Beeper";
    color = "green";
  };

  helper = import ./account-config-helper.nix { inherit config pkgs lib; };
in {
  accounts.email.accounts = mkIf (config.work.enable) {
    Automattic = mkMerge [
      (helper.commonConfig automatticConfig)
      (helper.imapnotifyConfig automatticConfig)
      {
        primary = true;
        flavor = "gmail.com";
        folders = {
          drafts = "[Gmail]/Drafts";
          sent = "[Gmail]/Sent Mail";
          trash = "[Gmail]/Trash";
        };
        signature = {
          showSignature = "append";
          text = ''
            Sumner Evans
            Software Engineer at Beeper (part of Automattic)
            https://sumnerevans.com | @sumner:nevarro.space
          '';
        };
      }
    ];
    Beeper = mkMerge [
      (helper.commonConfig beeperConfig)
      (helper.imapnotifyConfig beeperConfig)
      {
        flavor = "gmail.com";
        folders = {
          drafts = "[Gmail]/Drafts";
          sent = "[Gmail]/Sent Mail";
          trash = "[Gmail]/Trash";
        };
        signature = {
          showSignature = "append";
          text = ''
            Sumner Evans
            Software Engineer at Beeper (part of Automattic)
            https://sumnerevans.com | @sumner:nevarro.space
          '';
        };
      }
    ];
  };
}
