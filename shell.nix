{ pkgs ? import <nixpkgs> {} }: with pkgs;
mkShell {
  propagatedBuildInputs = [
    rnix-lsp
  ];
}
