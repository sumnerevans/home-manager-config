{ pkgs, declarative-cachix, ... }: {
  imports = [
    declarative-cachix.homeManagerModules.declarative-cachix
  ];

  nix.package = pkgs.nix;

  home.packages = [ pkgs.cachix ];

  caches.cachix = [
    {
      name = "sumnerevans";
      sha256 = "sha256:0l8bn98zhpcwl8yv3hlm00411xrv7lxq30xcmq2xbg82hgh6rwdj";
    }
    {
      name = "nix-community";
      sha256 = "sha256:0m6kb0a0m3pr6bbzqz54x37h5ri121sraj1idfmsrr6prknc7q3x";
    }
  ];

  nixpkgs.config = {
    packageOverrides = pkgs: {
      nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
        inherit pkgs;
      };
    };
    allowUnfree = true;
    android_sdk.accept_license = true;
  };
}
