{ pkgs, lib, ... }: with lib; rec {
  # Create a signature script that gets a quote.
  # TODO: fix the path to quotesfile
  mkSignatureScript = signatureLines: pkgs.writeScript "signature" ''
    #!${pkgs.python3}/bin/python
    import subprocess

    ${concatMapStringsSep "\n" (l: ''print("${l}")'') (splitString "\n" signatureLines)}

    # Quote
    quotes_cmd = ["${pkgs.fortune}/bin/fortune", "/home/sumner/.mutt/quotes"]
    quote = ""
    # Not sure why, but sometimes fortune returns an empty fortune.
    while len(quote) == 0:
        quote = subprocess.check_output(quotes_cmd).decode("utf-8").strip()
    print(quote)
  '';

  # Common configuration
  commonConfig = { address, name, color ? "", ... }: {
    inherit address;

    realName = mkDefault "Sumner Evans";
    userName = mkDefault address;
    passwordCommand = mkDefault "${pkgs.pass}/bin/pass Mail/${address}";

    mbsync = {
      enable = true;
      create = "both";
      remove = "both";
    };

    msmtp.enable = true;

    neomutt = {
      enable = true;
      sendMailCommand = "offlinemsmtp -a ${name}";
      extraConfig = mkIf (color != "") "color status ${color} default";
    };

    folders.inbox = "INBOX";
  };

  gpgConfig.gpg = {
    encryptByDefault = true;
    key = "3F15C22BFD125095F9C072758904527AB50022FD";
    signByDefault = true;
  };

  imapnotifyConfig = { name, ... }: {
    imapnotify = {
      enable = true;
      boxes = [ "INBOX" ];
      onNotify = "${pkgs.isync}/bin/mbsync ${name}:%s";
      onNotifyPost = "${pkgs.libnotify}/bin/notify-send 'New mail in ${name}:%s'";
    };
  };

  migaduConfig = {
    imap.host = "imap.migadu.com";
    smtp.host = "smtp.migadu.com";
  };

  signatureConfig = { signatureLines, ... }: {
    neomutt.extraConfig = ''
      set signature="${mkSignatureScript signatureLines}|"
    '';
  };
}
