{ pkgs, ... }: {
  imports = [
    (
      let
        declCachix = builtins.fetchTarball "https://github.com/jonascarpay/declarative-cachix/archive/b63e9cb0d0962656d08fb4668a5b6b1ba1ca5648.tar.gz";
      in
      import "${declCachix}/home-manager.nix"
    )
  ];

  home.packages = [ pkgs.cachix ];

  caches.cachix = [
    {
      name = "sumnerevans";
      sha256 = "sha256:0did3acpg6azxclffz02ahhg5gf8mwzdhb11w16j3qhkhi8v2dmf";
    }
    {
      name = "nix-community";
      sha256 = "sha256:1rgbl9hzmpi5x2xx9777sf6jamz5b9qg72hkdn1vnhyqcy008xwg";
    }
  ];
}
