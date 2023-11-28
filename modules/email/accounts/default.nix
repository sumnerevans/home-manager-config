{ config, ... }: {
  imports = [ ./admin-accounts.nix ./gmail.nix ./personal.nix ./work.nix ];

  accounts.email.maildirBasePath = "${config.home.homeDirectory}/Mail";
}
