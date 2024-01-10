{
  services.syncthing = {
    enable = true;
    extraOptions = [ "--gui-address=http://0.0.0.0:8384" ];
  };
}
