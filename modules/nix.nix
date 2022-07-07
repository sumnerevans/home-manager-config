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
      sha256 = "sha256:042yrl18pfiqnjmy7rmiq0rsi8kldvi88w2g1lv90y40pmcq9zdy";
    }
    {
      name = "nix-community";
      sha256 = "sha256:1955r436fs102ny80wfzy99d4253bh2i1vv1x4d4sh0zx2ssmhrk";
    }
  ];
}
