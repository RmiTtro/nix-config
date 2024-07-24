{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # To start the application, use: sudo pentablet-driver
  home.packages = with pkgs; [ libsForQt5.xp-pen-g430-driver ];
}