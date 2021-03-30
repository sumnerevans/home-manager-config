{ pkgs ? import <nixpkgs> {} }: with pkgs; let
  openssl = "${pkgs.openssl}/bin/openssl";
  pass = "${pkgs.pass}/bin/pass";
  tar = "${pkgs.gnutar}/bin/tar";
  tee = "${pkgs.coreutils}/bin/tee";

  passwordId = "SysAdmin/home-manager-secrets-key";
  secretsFileManager = writeShellScriptBin "secrets-file-manager" ''
    set -xe

    SECRETS_FILE_PATH=''${SECRETS_FILE_PATH:-.secrets_password_file}

    [[ -f $SECRETS_FILE_PATH ]] || ${pass} ${passwordId} | ${tee} $SECRETS_FILE_PATH

    function enc_dec() {
        ${openssl} aes-256-cbc -iter 100000 -pbkdf2 -pass file:$SECRETS_FILE_PATH $@
    }

    if [[ "$1" == "update" ]]; then
        ${tar} cv secrets | enc_dec > secrets.tar.enc
    elif [[ "$1" == "extract" ]]; then
        enc_dec -d -in secrets.tar.enc | ${tar} xv
    else
        echo "Invalid parameters. Must specify 'update' or 'extract'."
        exit 1
    fi
  '';
in
pkgs.mkShell {
  propagatedBuildInputs = with python3Packages; [
    rnix-lsp
    secretsFileManager
  ];
}
