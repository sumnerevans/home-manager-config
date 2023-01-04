{ pkgs ? import <nixpkgs> { } }: with pkgs;
mkShell {
  propagatedBuildInputs = [
    black
    git-crypt
    pre-commit
    rnix-lsp
  ];
}
