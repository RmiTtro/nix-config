{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [ krita ];
  
  # TODO: Add configurations
}