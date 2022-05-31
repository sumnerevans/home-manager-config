{ config, lib, pkgs, ... }: with lib; with pkgs; let
  secretsDir = "${config.xdg.configHome}/nixpkgs/secrets";
  tracktime = callPackage ../pkgs/tracktime.nix { };
  yamlFormat = pkgs.formats.yaml { };
in
{
  home.packages = [ tracktime ];

  xdg.configFile."tracktime/tracktimerc".source = yamlFormat.generate "tracktimerc" {
    fullname = "Sumner Evans";
    github = {
      access_token = "${pkgs.coreutils}/bin/cat ${secretsDir}/github-tracktime-access-token|";
      username = "sumnerevans";
    };

    gitlab = {
      api_root = "https://gitlab.com/api/v4/";
      api_key = "${pkgs.coreutils}/bin/cat ${secretsDir}/gitlab-api-key|";
    };

    linear = {
      default_org = "beeper";
      api_key = "${pkgs.coreutils}/bin/cat ${secretsDir}/linear-personal-api-key|";
    };

    sourcehut = {
      api_root = "https://todo.sr.ht/api/";
      access_token = "${pkgs.coreutils}/bin/cat ${secretsDir}/sourcehut-access-token|";
      username = "~sumner";
    };

    sync_time = true;
    tableformat = "fancy_grid";

    day_worked_min_threshold = 120;

    project_rates = {
      "CSCI 400" = 40;
      "CSCI 406" = 40;
      "Grading 101" = 15;
      "teaching/aca" = 22;
    };

    customer_rates = {
      Beeper = 57.5;
      TTD = 51.92;
    };

    customer_addresses = {
      Beeper = ''
        207 High Street
        Palo Alto, CA 94301
      '';
      "Tracy Camp" = ''
        Computer Sceince Department
        Colorado School of Mines
      '';
      TTD = ''
        42 N. Chestnut St
        Ventura, CA 93001
        United States of America
      '';
    };

    customer_aliases = {
      Beeper = "Beeper Inc.";
      "Tracy Camp" = "Dr. Tracy Camp";
      TTD = "The Trade Desk";
    };
  };

  # Aliases
  programs.zsh.shellAliases = {
    tt-beeper = "tt start -c Beeper";
    tt-bri = "tt start -t linear -c Beeper -p BRI";
    tt-element = "tt start -c Beeper 'Element catchup'";
    tt-hspc = "tt start -t gl -p ColoradoSchoolOfMines/hspc-problems";
    tt-tea = "tt start -p teaching/ppl";
    tt-issues = "tt start -t gl -p 'beeper/issues' -c Beeper";
    tt-standup = "tt start -c Beeper 'Standup'";
  };
}
