{ config, pkgs, ... }:
with pkgs;
let
  # Reverse ls when you type sl
  ls = "${coreutils}/bin/ls";
  slScript = pkgs.writeScriptBin "sl" ''
    #! ${python3}/bin/python
    import subprocess

    p = subprocess.Popen(
        ['${ls}', '-lah'],
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        universal_newlines=True)
    output, errors = p.communicate()

    lines = output.splitlines()

    max_line_len = max(len(l) for l in lines)

    for line in output.splitlines():
        print(' ' * (max_line_len - len(line)), end="")
        print(line[::-1])
  '';
in
{ home.packages = [ slScript ]; }
