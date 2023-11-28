{ config, pkgs, lib, ... }:
with lib;
let
  accountConfig = {
    address = "sumner@beeper.com";
    name = "Work";
    color = "blue";
    signatureLines = ''
      Sumner Evans | Software Engineer at Beeper
      https://sumnerevans.com | @sumner:nevarro.space | GPG: B50022FD
    '';
  };

  helper = import ./account-config-helper.nix { inherit config pkgs lib; };
in
{
  accounts.email.accounts.Work = mkMerge [
    (helper.commonConfig accountConfig)
    (helper.imapnotifyConfig accountConfig)
    (helper.signatureConfig accountConfig)
    helper.gpgConfig
    {
      flavor = "gmail.com";
      folders = {
        drafts = "[Gmail]/Drafts";
        sent = "[Gmail]/Sent Mail";
        trash = "[Gmail]/Trash";
      };
    }
  ];
}
