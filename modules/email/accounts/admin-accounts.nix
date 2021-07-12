{ config, pkgs, lib, ... }: with lib; let
  adminConfig = {
    name = "Admin";
    address = "admin@sumnerevans.com";
    color = "green";
  };

  commentsConfig = {
    name = "Comments";
    address = "comments@sumnerevans.com";
    color = "green";
  };

  inquiriesConfig = {
    name = "Inquiries";
    address = "inquiries@sumnerevans.com";
    color = "green";
  };

  junkConfig = {
    name = "Junk";
    address = "junk@sumnerevans.com";
    color = "red";
  };

  bookMyTimeAdmin = {
    name = "BMT-Admin";
    address = "admin@bookmyti.me";
    color = "green";
  };

  nevarroAdmin = {
    name = "Nevarro-Admin";
    address = "admin@nevarro.space";
    color = "green";
  };

  helper = import ./account-config-helper.nix { inherit config pkgs lib; };
in
{
  accounts.email.accounts = {
    Admin = mkMerge [
      (helper.commonConfig adminConfig)
      helper.migaduConfig
      {
        aliases = [
          "abuse@sumnerevans.com"
          "hostmaster@sumnerevans.com"
          "postmaster@sumnerevans.com"
        ];
      }
    ];

    Comments = mkMerge [
      (helper.commonConfig commentsConfig)
      helper.migaduConfig
    ];

    Inquiries = mkMerge [
      (helper.commonConfig inquiriesConfig)
      helper.migaduConfig
    ];

    Junk = mkMerge [
      (helper.commonConfig junkConfig)
      helper.migaduConfig
    ];

    BMT-Admin = mkMerge [
      (helper.commonConfig bookMyTimeAdmin)
      helper.migaduConfig
    ];

    Nevarro-Admin= mkMerge [
      (helper.commonConfig nevarroAdmin)
      helper.migaduConfig
    ];
  };
}
