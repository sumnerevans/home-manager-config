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
            config = {
              allowUnfree = true;
              permittedInsecurePackages = [ "olm-3.2.16" ];
            };
            overlays = [
              (final: prev: { inherit (menucalc.packages.${system}) menucalc; })
              (final: prev: { inherit (mdf.packages.${system}) mdf; })
              (final: prev: {
                harper = prev.rustPlatform.buildRustPackage rec {
                  pname = "harper";
                  version = "0.28.0";

                  src = prev.fetchFromGitHub {
                    owner = "Automattic";
                    repo = "harper";
                    rev = "v${version}";
                    hash =
                      "sha256-g+noAc+vKli2T8C2EAK4ejw/2DWZPhtKbezyt53iHYg=";
                  };

                  buildAndTestSubdir = "harper-ls";
                  useFetchCargoVendor = true;
                  cargoHash =
                    "sha256-Ql1WdwDnXBC4JHO/uzJJlacQC44bOaHo2i3M9atjf3I=";
                };
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
