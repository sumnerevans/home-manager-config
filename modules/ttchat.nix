{ pkgs, ... }:
let yamlFormat = pkgs.formats.yaml { };
in {
  home.packages = [ pkgs.ttchat ];

  home.file.".ttchat/config.yaml".source = yamlFormat.generate "config.yaml" {
    clientID = "q6batx0epp608isickayubi39itsckt";
    username = "sumnerevans";
    lineSpacing = 1;
  };
}
