{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  programs.firejail.enable = true;
}