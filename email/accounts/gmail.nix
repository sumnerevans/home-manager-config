{ pkgs, lib, ... }: with lib; let
  accountConfig = {
    address = "sumner.evans98@gmail.com";
    name = "Gmail";
    color = "yellow";
    signatureLines = ''
      Sumner Evans
      Software Engineer at The Trade Desk
      2 Chronicles 7:14

      https://sumnerevans.com | +1 (720) 459-1501 | GPG: B50022FD

      Note, this is not my main email, please update your contact information
      for me to my new email: me@sumnerevans.com.
    '';
  };

  helper = import ./account-config-helper.nix { inherit pkgs lib; };
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
