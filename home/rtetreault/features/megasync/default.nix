{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  services.megasync.enable = true;
  
  # Necessary for megasync to build
  # https://github.com/NixOS/nixpkgs/issues/290949
  nixpkgs.config.permittedInsecurePackages = [
    "freeimage-unstable-2021-11-01"
  ];

}