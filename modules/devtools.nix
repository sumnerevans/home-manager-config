{ config, lib, pkgs, ... }: with lib; let
  tomlFormat = pkgs.formats.toml { };
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
      watchexec
    ] ++ (
      # GUI Tools
      optionals (config.wayland.enable || config.xorg.enable) [
        dfeet
        sqlitebrowser
        wireshark
      ]
    );

    # Enable developer programs
    programs.direnv.enable = true;
    programs.direnv.enableNixDirenvIntegration = true;
    programs.gh.enable = true;
    programs.gh.gitProtocol = "ssh";
    programs.jq.enable = true;
    programs.opam.enable = true;
    programs.vscode.enable = true;

    xdg.configFile."pypoetry/config.toml".source = tomlFormat.generate "config.toml" {
      virtualenvs.in-project = true;
    };
  };
}
