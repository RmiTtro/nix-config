{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # Enable CUPS to print documents.
  services.printing.enable = true;
  
  # To eneable network discovery of printer
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };
}