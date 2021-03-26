{ pkgs, lib, ... }: with lib; {
  mkSignatureScript = signatureLines: pkgs.writeScript "signature" ''
    #!${pkgs.python3}/bin/python
    import subprocess

    ${concatMapStringsSep "\n" (l: ''print("${l}")'') (splitString "\n" signatureLines)}

    # Quote
    quotes_cmd = ['${pkgs.fortune}/bin/fortune', '/home/sumner/.mutt/quotes']
    quote = ""
    # Not sure why, but sometimes fortune returns an empty fortune.
    while len(quote) == 0:
        quote = subprocess.check_output(quotes_cmd).decode('utf-8').strip()
    print(quote)
  '';
}
