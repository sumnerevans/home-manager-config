{ config, lib, pkgs, ... }:
with lib;
let
  tomlFormat = pkgs.formats.toml { };
  iniFormat = pkgs.formats.ini { };
  hasGui = config.wayland.enable || config.xorg.enable;
in {
  options = {
    devTools.enable = mkEnableOption "developer tools and applications" // {
      default = true;
    };
  };

  config = mkIf config.devTools.enable {
    home.packages = with pkgs;
      [
        # Shell Utilities
        eternal-terminal
        nodePackages.jsonlint
        mosh
        tree-sitter
        watchexec

        # SQL Terminal GUI
        postgresql
        litecli
        pgcli

        # Better Python REPL
        python3Packages.ptpython
      ] ++ (
        # GUI Tools
        optionals hasGui [
          d-spy
          rars
          remmina
          sqlitebrowser
          wireshark

          # GTK Development
          icon-library
        ]);

    # Go
    programs.go = {
      enable = true;
      package = pkgs.go_1_24;
      telemetry.mode = "on";
    };

    # Enable developer programs
    programs.direnv.enable = true;
    programs.direnv.nix-direnv.enable = true;
    programs.jq.enable = true;
    programs.opam.enable = true;
    programs.vscode.enable = hasGui;
    programs.vscode.profiles.default.extensions = with pkgs.vscode-extensions;
      [ golang.go ];

    xdg.configFile."pypoetry/config.toml".source =
      tomlFormat.generate "config.toml" { virtualenvs.in-project = true; };

    home.file.".ideavimrc".text = ''
      set clipboard+=unnamed
    '';

    xdg.configFile."pgcli/config".source = iniFormat.generate "config" {
      main = {
        wider_completion_menu = "True";
        log_file = "${config.home.homeDirectory}/.cache/pgcli/log";
        vi = "True";
      };
    };
  };
}
