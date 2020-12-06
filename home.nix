{ pkgs, ... }:
{
  programs.home-manager.enable = true;
  programs.git = {
    enable = true;
    userEmail = "me@sumnerevans.com";
    userName = "Sumner Evans";

    attributes = [ "*.pdf diff=pdf" ];

    delta.enable = true;

    signing = {
      key = "8904527AB50022FD";
      signByDefault = true;
    };
  };
}
