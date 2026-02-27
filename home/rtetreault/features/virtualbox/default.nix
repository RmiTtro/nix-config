{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  home.persistence."/persistent" = {
    directories = [
      ".config/VirtualBox"
      "VirtualBox VMs"
    ];
  };
}