{ pkgs, ... }: {
  # Make the gpg-agent work
  services.gpg-agent = let
    ttl = 60 * 60 * 4; # 4 hours
  in
    {
      enable = true;
      defaultCacheTtl = ttl;
      maxCacheTtl = ttl;
      pinentryFlavor = "gnome3";
      verbose = true;
    };
}
