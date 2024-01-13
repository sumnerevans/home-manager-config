{ config, lib, pkgs, ... }:
with lib;
with pkgs;
let
  secretsDir = "${config.xdg.configHome}/home-manager/secrets";
  tracktime = callPackage ../pkgs/tracktime.nix { };
  yamlFormat = pkgs.formats.yaml { };
in {
  home.packages = [ tracktime ];

  xdg.configFile."tracktime/tracktimerc".source =
    yamlFormat.generate "tracktimerc" {
      fullname = "Sumner Evans";
      github = {
        access_token =
          "${pkgs.coreutils}/bin/cat ${secretsDir}/github-tracktime-access-token|";
        username = "sumnerevans";
      };

      gitlab = {
        api_root = "https://gitlab.com/api/v4/";
        api_key = "${pkgs.coreutils}/bin/cat ${secretsDir}/gitlab-api-key|";
      };

      linear = {
        default_org = "beeper";
        api_key =
          "${pkgs.coreutils}/bin/cat ${secretsDir}/linear-personal-api-key|";
      };

      sourcehut = {
        api_root = "https://todo.sr.ht/api/";
        access_token =
          "${pkgs.coreutils}/bin/cat ${secretsDir}/sourcehut-access-token|";
        username = "~sumner";
      };

      sync_time = true;
      tableformat = "fancy_grid";

      day_worked_min_threshold = 120;

      customer_rates = {
        Beeper = 57.5;
        TTD = 51.92;
      };

      customer_addresses = {
        Beeper = ''
          207 High Street
          Palo Alto, CA 94301
        '';
        TTD = ''
          42 N. Chestnut St
          Ventura, CA 93001
          United States of America
        '';
      };

      customer_aliases = {
        Beeper = "Beeper Inc.";
        TTD = "The Trade Desk";
      };
    };

  # Aliases
  programs.zsh.shellAliases = {
    tt-be = "tt start -t linear -c Beeper -p BE";
    tt-beeper = "tt start -c Beeper";
    tt-boop = "tt start -t linear -c Beeper -p BOOP";
    tt-element = "tt start -c Beeper 'Element catchup'";
    tt-hspc = "tt start -t gh -p ColoradoSchoolOfMines/hspc-problems";
    tt-issues = "tt start -t gl -p 'beeper/issues' -c Beeper";
    tt-nevarro = "tt start -c Nevarro";
    tt-standup = "tt start -c Beeper 'Standup'";
    tt-tea = "tt start -p teaching/algo";
    tt-tut = "tt start -p teaching/tutoring";
  };
}
