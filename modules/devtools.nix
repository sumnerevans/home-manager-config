{ config, lib, pkgs, ... }: with lib; let
  tomlFormat = pkgs.formats.toml { };
  hasGui = config.wayland.enable || config.xorg.enable;
  exposePort = pkgs.writeShellScriptBin "exposeport" ''
    sudo ssh -L $2:localhost:$2 $1
  '';
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
        android-studio
        dfeet
        jetbrains.idea-community
        openjdk11
        postman
        sqlitebrowser
        wireshark
      ]
    );

    programs.zsh.shellAliases = {
      tat = "${pkgs.eternal-terminal}/bin/et tatooine";
      tat-expose = "${exposePort}/bin/exposeport tatooine.sumnerevans.com";
      tat-synapse = "${exposePort}/bin/exposeport tatooine.sumnerevans.com 8008";
    };

    # Enable developer programs
    programs.direnv.enable = true;
    programs.direnv.nix-direnv.enable = true;
    programs.jq.enable = true;
    programs.opam.enable = true;
    programs.vscode.enable = hasGui;

    xdg.configFile."pypoetry/config.toml".source = tomlFormat.generate "config.toml" {
      virtualenvs.in-project = true;
    };

    home.file.".ideavimrc".text = ''
      set clipboard+=unnamed
    '';
  };
}
