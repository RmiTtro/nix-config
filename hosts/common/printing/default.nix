{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: let 
  inherit (outputs.lib) assignIfAttrOf;
in {
  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Necessary to be able to manage printers from the applet in the task bar
  environment.systemPackages = with pkgs; [
    system-config-printer
  ];
  
  # To eneable network discovery of printer
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  environment.persistence."/persistent" = {
    directories = [
      "/etc/cups/"
    ];
  };
}