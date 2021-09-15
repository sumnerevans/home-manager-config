{ config, lib, pkgs, ... }: with lib; with pkgs; let
  secretsDir = "${config.xdg.configHome}/nixpkgs/secrets";
  tracktime = callPackage ../pkgs/tracktime.nix {};
  yamlFormat = pkgs.formats.yaml {};
in
{
  home.packages = [ tracktime ];

  xdg.configFile."tracktime/tracktimerc".source = yamlFormat.generate "tracktimerc" {
    fullname = "Sumner Evans";
    github = {
      access_token = "cat ${secretsDir}/github-tracktime-access-token|";
      username = "sumnerevans";
    };

    gitlab = {
      api_root = "https://gitlab.com/api/v4/";
      api_key = "cat ${secretsDir}/gitlab-api-key|";
    };

    sourcehut = {
      api_root = "https://todo.sr.ht/api/";
      access_token = "cat ${secretsDir}/sourcehut-access-token|";
      username = "~sumner";
    };

    sync_time = true;
    tableformat = "fancy_grid";

    day_worked_min_threshold = 60;

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

    external_synchroniser_files = {
      # jira = "/home/sumner/projects/tracktime/examples/jira_selenium_chrome.py";
    };

    # Needed so that the synchroniser can find the Chrome binary.
    chromedriver.chrome_bin = "${pkgs.google-chrome}/bin/google-chrome-stable";
  };
}
