{ config, lib, pkgs, ... }: with lib; let
  tomlFormat = pkgs.formats.toml { };
  iniFormat = pkgs.formats.ini { };
  hasGui = config.wayland.enable || config.xorg.enable;
  exposePort = pkgs.writeShellScriptBin "exposeport" ''
    sudo ssh -L $2:localhost:$2 $1
  '';

  package = pkgs.vscode;
  extensions = with pkgs.vscode-extensions; [
    # ms-vsliveshare.vsliveshare
  ];

  finalPackage = (pkgs.vscode-with-extensions.override {
    vscode = package;
    vscodeExtensions = extensions;
  }).overrideAttrs (old: {
    inherit (package) pname version;
  });
in
{
  options = {
    devTools.enable = mkEnableOption "developer tools and applications" // {
      default = true;
    };
  };

  config = mkIf config.devTools.enable {
    home.packages = with pkgs; [
      # Shell Utilities
      delta
      eternal-terminal
      exposePort
      mosh
      watchexec

      # SQL Terminal GUI
      litecli
      pgcli
    ] ++ (
      # GUI Tools
      optionals hasGui [
        cambalache
        dfeet
        jetbrains.idea-community
        openjdk11
        postman
        sqlitebrowser
        visualvm
        wireshark

        # GTK Development
        icon-library
      ]
    );

    programs.zsh.shellAliases = {
      tat = "sudo ${pkgs.eternal-terminal}/bin/et sumner@tatooine.sumnerevans.com -t 443:443,8008:8008,8009:8009,3719:3719";
      tat-expose = "${exposePort}/bin/exposeport tatooine.sumnerevans.com";
      tat-synapse = "${exposePort}/bin/exposeport tatooine.sumnerevans.com 8008";
    };

    # Enable developer programs
    programs.direnv.enable = true;
    programs.direnv.nix-direnv.enable = true;
    programs.jq.enable = true;
    programs.opam.enable = true;
    programs.vscode.enable = hasGui;
    programs.vscode.package = finalPackage;

    xdg.configFile."pypoetry/config.toml".source = tomlFormat.generate "config.toml" {
      virtualenvs.in-project = true;
    };

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
