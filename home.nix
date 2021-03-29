{ config, pkgs, ... }: {
  imports = [
    ./modules
    ./programs
    ./host-config.nix
  ];

  nixpkgs.overlays = [
    (
      self: super: rec {
        python3 = super.python3.override {
          packageOverrides = self2: super2: {
            mpv = super2.buildPythonPackage rec {
              pname = "mpv";
              version = "0.5.2";
              src = super.fetchFromGitHub {
                owner = "jaseg";
                repo = "python-mpv";
                rev = "v${version}";
                sha256 = "0ffskpynhl1252h6a05087lvpjgn1cn2z3caiv3i666dn1n79fjd";
              };
              propagatedBuildInputs = [ super.mpv ];
              doCheck = false;
            };
          };
        };
      }
    )
  ];

  home = {
    stateVersion = "21.03";
    username = "sumner";
    homeDirectory = "/home/sumner";
  };

  # Always restart/start/stop systemd services on home manager switch.
  systemd.user.startServices = "sd-switch";
}
