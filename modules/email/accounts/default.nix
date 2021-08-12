{ config, ... }: {
  imports = [
    ./admin-accounts.nix
    ./gmail.nix
    ./personal.nix
    ./summation-tech.nix
    ./work.nix
  ];

  accounts.email.maildirBasePath = "${config.home.homeDirectory}/Mail";
}
