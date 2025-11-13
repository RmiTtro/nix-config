{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  programs.nemo.plugins = [ pkgs.megashellextnemo ];
}