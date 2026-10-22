# Solaar is to manage logitech device
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  programs.solaar.enable = true;
  programs.solaar.userService.enable = true;
}