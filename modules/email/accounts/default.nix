{ config, ... }: {
  imports = [
    ./admin-accounts.nix
    ./gmail.nix
    ./mines.nix
    ./personal.nix
    ./summation-tech.nix
  ];

  accounts.email.maildirBasePath = "${config.home.homeDirectory}/Mail";
}
