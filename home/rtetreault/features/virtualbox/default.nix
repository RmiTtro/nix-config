{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  permanenceHomeWrap = {
    directories = [
      ".config/VirtualBox"
      "VirtualBox VMs"
    ];
  };
}