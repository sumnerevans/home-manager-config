{
  imports = [
    (
      let
        declCachix = builtins.fetchTarball "https://github.com/jonascarpay/declarative-cachix/archive/1986455ab3e55804458bf6e7d2a5f5b8a68defce.tar.gz";
      in
      import "${declCachix}/home-manager.nix"
    )
  ];

  caches.cachix = [
    { name = "sumnerevans"; sha256 = "111dzynldwpisdrj138kql1v9a62k5p7bk00fcjm2gvlbma2d9bv"; }
  ];
}
