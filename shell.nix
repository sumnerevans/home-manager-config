{ pkgs ? import <nixpkgs> { } }: with pkgs;
mkShell {
  propagatedBuildInputs = [
    black
    cargo
    git-crypt
    pre-commit
    rnix-lsp
  ];
}
