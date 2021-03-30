{ pkgs, ... }: let
  agentTTL = 60 * 60 * 4; # 4 hours
in
{
  programs.gpg.enable = true;

  # Make the gpg-agent work
  services.gpg-agent = {
    enable = true;
    defaultCacheTtl = agentTTL;
    maxCacheTtl = agentTTL;
    pinentryFlavor = "gnome3";
    verbose = true;
  };
}
