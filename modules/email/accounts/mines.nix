{ config, pkgs, lib, ... }: with lib; let
  accountConfig = {
    address = "jonathanevans@mymail.mines.edu";
    name = "Mines";
    color = "cyan";
    signatureLines = ''
      Jonathan Sumner Evans           Instructor: CSCI 564
      https://sumnerevans.com         CS@Mines Alumnus
      +1 (720) 459-1501               M.S. Computer Science
      GPG: B50022FD                   Software Engineer @ Beeper
    '';
  };

  helper = import ./account-config-helper.nix { inherit config pkgs lib; };
in
{
  accounts.email.accounts.Mines = mkMerge [
    (helper.commonConfig accountConfig)
    (helper.imapnotifyConfig accountConfig)
    (helper.signatureConfig accountConfig)
    helper.gpgConfig
    {
      folders = {
        drafts = "[Gmail]/Drafts";
        sent = "[Gmail]/Sent Mail";
        trash = "[Gmail]/Trash";
      };

      realName = "Jonathan Sumner Evans";
      passwordCommand = "${pkgs.pass}/bin/pass Mail/Offlineimap/Mines";
      imap.host = "imap.gmail.com";
      smtp.host = "smtp.mines.edu";

      msmtp.extraConfig = {
        from = "jonathanevans@mines.edu";
        passwordeval = "${pkgs.pass}/bin/pass School/Mines/MultiPass";
        user = "jonathanevans";
      };

      neomutt.extraConfig = ''
        set from="jonathanevans@mines.edu"
        alternates '^jonathanevans@mymail.mines.edu$'"
      '';
    }
  ];
}
