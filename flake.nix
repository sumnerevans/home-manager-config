{
  description = "Home Manager configuration of sumner";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    declarative-cachix.url = "github:jonascarpay/declarative-cachix";
  };

  outputs = { nixpkgs, home-manager, declarative-cachix, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};

      mkConfig = hostModule: home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        modules = [
          ./home.nix
          hostModule
        ];

        extraSpecialArgs = { inherit declarative-cachix; };
      };
    in
    {
      homeConfigurations."tatooine" = mkConfig ./host-configurations/tatooine.nix;
    };
}
