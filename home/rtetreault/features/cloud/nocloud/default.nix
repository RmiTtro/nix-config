{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [ ../cloud-options.nix ];

  cloud.enable = false;
}