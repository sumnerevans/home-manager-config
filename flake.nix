{
  description = "Home Manager configuration of sumner";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils.url = "github:numtide/flake-utils";
    declarative-cachix.url = "github:jonascarpay/declarative-cachix";
    menucalc = {
      url = "github:sumnerevans/menu-calc";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    mdf = {
      url = "github:sumnerevans/mdf";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, declarative-cachix, flake-utils
    , menucalc, mdf }:
    let
      system = "x86_64-linux";
      mkConfig = hostModule:
        home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
            overlays = [
              (final: prev: { inherit (menucalc.packages.${system}) menucalc; })
              (final: prev: { inherit (mdf.packages.${system}) mdf; })
              (final: prev: {
                element-desktop =
                  prev.element-desktop.override { electron = prev.electron; };
              })
            ];
          };

          modules = [ ./home.nix hostModule ];

          extraSpecialArgs = { inherit declarative-cachix; };
        };
    in {
      homeConfigurations."tatooine" =
        mkConfig ./host-configurations/tatooine.nix;
      homeConfigurations."coruscant" = mkConfig ./host-configurations/coruscant;
      homeConfigurations."scarif" = mkConfig ./host-configurations/scarif.nix;
      homeConfigurations."mustafar" =
        mkConfig ./host-configurations/mustafar.nix;
      homeConfigurations."automattic" =
        mkConfig ./host-configurations/automattic.nix;
    } // (flake-utils.lib.eachDefaultSystem (system:
      let pkgs = import nixpkgs { system = system; };
      in {
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            black
            cargo
            git-crypt
            nixfmt-classic
            pre-commit
          ];
        };
      }));
}
