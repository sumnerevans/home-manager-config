{ config, pkgs, lib, ... }: with lib; let
  summationTechAdmin = {
    name = "ST-Admin";
    address = "admin@summation.tech";
    color = "red";
  };

  summationTechSumner = {
    name = "ST-Sumner";
    address = "sumner@summation.tech";
    color = "red";
  };

  helper = import ./account-config-helper.nix { inherit config pkgs lib; };
in
{
  accounts.email.accounts = {
    ST-Admin = mkMerge [
      (helper.commonConfig summationTechAdmin)
      helper.migaduConfig
    ];

    ST-Sumner = mkMerge [
      (helper.commonConfig summationTechSumner)
      helper.migaduConfig
    ];
  };
}
