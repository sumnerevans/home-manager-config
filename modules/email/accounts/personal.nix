{ config, pkgs, lib, ... }: with lib; let
  accountConfig = {
    address = "me@sumnerevans.com";
    name = "Personal";
    color = "green";
    signatureLines = ''
      Sumner Evans
      Software Engineer at Beeper
      2 Chronicles 7:14

      https://sumnerevans.com | +1 (720) 459-1501 | GPG: B50022FD
    '';
  };

  helper = import ./account-config-helper.nix { inherit config pkgs lib; };
in
{
  accounts.email.accounts.Personal = mkMerge [
    (helper.commonConfig accountConfig)
    (helper.imapnotifyConfig accountConfig)
    (helper.signatureConfig accountConfig)
    helper.gpgConfig
    helper.migaduConfig
    {
      primary = true;
      aliases = [ "alerts@sumnerevans.com" "resume@sumnerevans.com" ];
    }
  ];
}
