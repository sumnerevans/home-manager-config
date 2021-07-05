{ pkgs ? import <nixpkgs> {} }: with pkgs;
mkShell {
  propagatedBuildInputs = [
    black
    git-crypt
    rnix-lsp
  ];
}
