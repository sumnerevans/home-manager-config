{ pkgs ? import <nixpkgs> {} }: with pkgs;
mkShell {
  propagatedBuildInputs = [
    black
    rnix-lsp
  ];
}
