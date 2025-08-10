{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # ROG is installed by the system, this is just to setup the application user config
  addCopyOnChange.xdg.configFile."rog/rog-control-center.cfg".source = ./rog-control-center.cfg;
}