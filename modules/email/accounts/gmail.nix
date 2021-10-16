{ config, pkgs, lib, ... }: with lib; let
  accountConfig = {
    address = "sumner.evans98@gmail.com";
    name = "Gmail";
    color = "yellow";
    signatureLines = ''
      Sumner Evans
      Software Engineer at Beeper
      2 Chronicles 7:14

      https://sumnerevans.com | @sumner:nevarro.space | GPG: B50022FD

      Note, this is not my main email, please update your contact information
      for me to my new email: me@sumnerevans.com.
    '';
  };

  helper = import ./account-config-helper.nix { inherit config pkgs lib; };
in
{
  accounts.email.accounts.Gmail = mkMerge [
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
