{ lib, pkgs, ... }: with lib; with pkgs; let
  passCmd = "${pass}/bin/pass";
  tracktime = callPackage ../pkgs/tracktime.nix {};
  yamlFormat = pkgs.formats.yaml {};
in
{
  home.packages = [ tracktime ];

  xdg.configFile."tracktime/tracktimerc".source = yamlFormat.generate "tracktimerc" {
    fullname = "Sumner Evans";
    gitlab = {
      api_root = "https://gitlab.com/api/v4/";
      api_key = "${passCmd} VCS/GitLab-API-Key|";
    };

    sourcehut = {
      api_root = "https://todo.sr.ht/api/";
      access_token = "${passCmd} VCS/Sourcehut-Access-Token|";
      username = "~sumner";
    };

    jira = {
      root = "https://atlassian.thetradedesk.com/jira/";
      sso_email = "sumner.evans@thetradedesk.com";
      sso_password = "${passCmd} Work/TTD/SSO|";
    };

    sync_time = true;
    tableformat = "fancy_grid";

    project_rates = {
      "CSCI 406" = 40;
      "CSCI 400" = 40;
      "teaching/aca" = 40;
      "Grading 101" = 15;
    };

    customer_rates = {
      TTD = 50;
    };

    customer_addresses = {
      TTD = ''
        42 N. Chestnut St
        Ventura, CA 93001
        United States of America
      '';
      "Tracy Camp" = ''
        Computer Sceince Department
        Colorado School of Mines
      '';
    };

    customer_aliases = {
      TTD = "The Trade Desk";
      "Tracy Camp" = "Dr. Tracy Camp";
    };

    external_synchroniser_files = {
      # jira = "/home/sumner/projects/tracktime/examples/jira_selenium_chrome.py";
    };

    # Needed so that the synchroniser can find the Chrome binary.
    chromedriver.chrome_bin = "${pkgs.google-chrome}/bin/google-chrome-stable";
  };
}
